module sovryn_pan_stem_npu_array_v3_seed_a_execute_mul(
  input wire clk,
  input wire rst_n,
  input wire issue_valid,
  input wire [1:0] issue_opcode,
  input wire [1:0] issue_addr,
  input wire [15:0] operand_a,
  input wire [15:0] operand_b,
  output reg mul_valid,
  output reg [1:0] mul_addr,
  output reg [15:0] mul_result
);
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      mul_valid <= 1'b0;
      mul_addr <= 2'd0;
      mul_result <= 16'd0;
    end else begin
      mul_valid <= issue_valid && (issue_opcode == 2'b10);
      mul_addr <= issue_addr;
      if (issue_valid && (issue_opcode == 2'b10)) begin
`ifdef SOVRYN_FORMAL_ABSTRACT
        mul_result <= 16'd0;
`else
        mul_result <= operand_a * operand_b;
`endif
      end
    end
  end
endmodule
