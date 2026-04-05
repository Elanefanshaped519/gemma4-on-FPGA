`timescale 1ns / 1ps

module sovryn_pan_stem_hdc_bundle_word_maj2_v1 #(
    parameter int WORD_W = 8,
    parameter int STATIC_INPUT_COUNT = 5
) (
    input  logic [WORD_W-1:0] dynamic_word,
    input  logic [(STATIC_INPUT_COUNT*WORD_W)-1:0] static_words_flat,
    input  logic [WORD_W-1:0] tie_word,
    output logic [WORD_W-1:0] bundled_word
);
    integer bit_index;
    integer static_index;
    integer ones_count;
    integer total_word_count;
    logic resolved_bit;

    always_comb begin
        total_word_count = STATIC_INPUT_COUNT + 1;
        bundled_word = '0;
        for (bit_index = 0; bit_index < WORD_W; bit_index += 1) begin
            ones_count = dynamic_word[bit_index] ? 1 : 0;
            for (static_index = 0; static_index < STATIC_INPUT_COUNT; static_index += 1) begin
                ones_count += static_words_flat[(static_index * WORD_W) + bit_index] ? 1 : 0;
            end
            if (ones_count > (total_word_count / 2)) begin
                resolved_bit = 1'b1;
            end else if (ones_count < (total_word_count / 2)) begin
                resolved_bit = 1'b0;
            end else begin
                resolved_bit = tie_word[bit_index];
            end
            bundled_word[bit_index] = resolved_bit;
        end
    end
endmodule
