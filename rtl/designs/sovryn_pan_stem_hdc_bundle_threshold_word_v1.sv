`timescale 1ns / 1ps

module sovryn_pan_stem_hdc_bundle_threshold_word_v1 #(
    parameter int WORD_W = 8,
    parameter int POP_THRESHOLD = 4
) (
    input  logic [WORD_W-1:0] bundled_word,
    input  logic [WORD_W-1:0] tie_word,
    output logic class_bit
);
    integer bit_index;
    integer ones_count;

    always_comb begin
        ones_count = 0;
        for (bit_index = 0; bit_index < WORD_W; bit_index += 1) begin
            ones_count += bundled_word[bit_index] ? 1 : 0;
        end
        if (ones_count > POP_THRESHOLD) begin
            class_bit = 1'b1;
        end else if (ones_count < POP_THRESHOLD) begin
            class_bit = 1'b0;
        end else begin
            class_bit = tie_word[0];
        end
    end
endmodule
