// bundle_maj2_tile.sv
// 
// Exploratory repo-native HDC bundling scaffold.
//
// This is the direct realization of the UCSD SHEARer "Area Approximate"
// Majority Adder-Tree. A pure adder tree over 10k bits requires massive logic arrays.
// This module encodes a local-majority bundling strategy for exploration only.
// No foundry-validated area, power, or medical claim is implied here.
//
// Pattern: 36 inputs -> Six independent 6-bit Majority-tied blocks -> 
// One Second Stage 6-bit Majority-tied block. 
// Uses deterministic tie-bits to avoid undefined local ties in simulation.

`timescale 1ns / 1ps

// 1. Stage 1 Local Majority 
module maj6_tie (
    input  logic [5:0] x,
    input  logic       tie_bit,  // Fixed random bit per dimension
    output logic       y
);
    logic [2:0] pc;
    always_comb begin
        pc = x[0] + x[1] + x[2] + x[3] + x[4] + x[5];
        // Majority definition: more than 3 votes, or exactly 3 + tie_break
        y  = (pc > 3) | ((pc == 3) & tie_bit);
    end
endmodule


// 2. State 2 Majority Reduction
// Compresses 36 Vector Streams into exactly 1 logic stream per spatial dimension
module maj2_reduce36 (
    input  logic [35:0] x,
    input  logic [6:0]  tie_bits,   // 6 first-stage + 1 second-stage tied resolvers
    output logic        y
);
    logic [5:0] s1;
    genvar g;
    generate
        for (g = 0; g < 6; g++) begin : G
            maj6_tie u_maj1(
                .x(x[g*6 +: 6]), 
                .tie_bit(tie_bits[g]), 
                .y(s1[g])
            );
        end
    endgenerate
    
    maj6_tie u_maj2(
        .x(s1), 
        .tie_bit(tie_bits[6]), 
        .y(y)
    );
endmodule


// 3. Final sign-compare / HDC bundle thresholding segment
// Executed once the sparse counters (or reduced tree outputs) are aggregated.
module bundle_threshold_seg #(
    parameter int SEG_D   = 256,
    parameter int ACC_W   = 8
) (
    input  logic signed [ACC_W-1:0] acc [0:SEG_D-1],
    input  logic [SEG_D-1:0]        tie_hv,
    output logic [SEG_D-1:0]        out_hv
);
    integer d;
    always_comb begin
        for (d = 0; d < SEG_D; d++) begin
            if      (acc[d] > 0) out_hv[d] = 1'b1;
            else if (acc[d] < 0) out_hv[d] = 1'b0;
            else                 out_hv[d] = tie_hv[d];
        end
    end
endmodule
