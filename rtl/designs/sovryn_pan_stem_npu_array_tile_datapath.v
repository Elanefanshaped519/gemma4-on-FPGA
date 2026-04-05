module sovryn_pan_stem_npu_array_tile_datapath(
  input wire [1:0] opcode,
  input wire [15:0] operand_a,
  input wire [15:0] operand_b,
  output reg [15:0] result_data
);
  always @* begin
    case (opcode)
      2'b01: result_data = operand_a + operand_b;
      2'b10: result_data =
`ifdef SOVRYN_FORMAL_ABSTRACT
        16'd0;
`else
        operand_a * operand_b;
`endif
      default: result_data = 16'd0;
    endcase
  end
endmodule
