module sovryn_pan_stem_npu_array_v2_innercore_a_execute(
  input wire clk,
  input wire rst_n,
  input wire issue_valid,
  input wire [1:0] issue_opcode,
  input wire [1:0] issue_addr,
  input wire [15:0] issue_data,
  input wire [15:0] operand_a,
  input wire [15:0] operand_b,
  output reg execute_valid,
  output reg [1:0] execute_opcode,
  output reg [1:0] execute_addr,
  output reg [15:0] execute_data,
  output reg [15:0] execute_result
);
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      execute_valid <= 1'b0;
      execute_opcode <= 2'd0;
      execute_addr <= 2'd0;
      execute_data <= 16'd0;
      execute_result <= 16'd0;
    end else begin
      execute_valid <= issue_valid;
      execute_opcode <= issue_opcode;
      execute_addr <= issue_addr;
      execute_data <= issue_data;
      case (issue_opcode)
        2'b01: execute_result <= operand_a + operand_b;
        2'b10: begin
`ifdef SOVRYN_FORMAL_ABSTRACT
          execute_result <= 16'd0;
`else
          execute_result <= operand_a * operand_b;
`endif
        end
        default: execute_result <= issue_data;
      endcase
    end
  end
endmodule
