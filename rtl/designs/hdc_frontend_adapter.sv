// hdc_frontend_adapter.sv
// 
// Exploratory repo-native HDC lowering scaffold.
// 
// This frontend adapter transforms quantized samples into hypervector-friendly
// intermediate forms without requiring multiply/divide operators.
// No foundry, thermal, power, or medical validation is implied by this scaffold.
// 
// 1. `level_index_cmp` : A sheer comparator-ladder for TorchHD -> round()
// 2. `seg_rotate_bind` : Segment-based ID shift preventing 10,000-bit fanout.

`timescale 1ns / 1ps

// 1. DSP/ALU Bypass Level Quantizer
// Replaces multi/div from TorchHD: idx = clamp(round((x-low)/((high-low)/(L-1))), 0, L-1)
module level_index_cmp #(
    parameter int IN_W   = 10,
    parameter int LEVELS = 32,
    // Packed threshold vector, with threshold 0 in the least-significant slice.
    parameter logic signed [(IN_W * (LEVELS - 1)) - 1:0] THR_FLAT = '0
) (
    input  logic signed [IN_W-1:0] x,
    output logic [$clog2(LEVELS)-1:0] idx
);
    function automatic logic signed [IN_W-1:0] threshold_at(input int index);
        threshold_at = THR_FLAT[(index * IN_W) +: IN_W];
    endfunction

    integer i;
    always_comb begin
        idx = '0;
        for (i = 0; i < LEVELS-1; i++) begin
            idx += (x >= threshold_at(i));
        end
    end
endmodule


// 2. Segment-decomposed rotate + bind
// Decomposing the massive TorchHD `ngrams` permute function so that only adjacent 
// BRAM Segments shift their bits (address shift + residual local bit rotation).
module seg_rotate_bind #(
    parameter int SEG_D = 256
) (
    // mem[(seg_id - q) mod NSEG]
    input  logic [SEG_D-1:0] seg_a,    
    
    // mem[(seg_id - q - 1) mod NSEG]
    input  logic [SEG_D-1:0] seg_b,    
    
    // The role seed hypervector to bind with
    input  logic [SEG_D-1:0] role_seg, 
    
    // residual bit rotate (r = shift % SEG_D)
    input  logic [$clog2(SEG_D)-1:0] r,
    
    output logic [SEG_D-1:0] bound_seg
);
    logic [SEG_D-1:0] perm_seg;
    integer shift_amt;
    always_comb begin
        shift_amt = r;
        if (r == 0) begin
            perm_seg = seg_a;
        end else begin
            perm_seg = (seg_a >> shift_amt) | (seg_b << (SEG_D - shift_amt));
        end
        // Canonical repo-native default is XOR; XNOR remains an optional convention.
        bound_seg = perm_seg ^ role_seg; 
    end
endmodule
