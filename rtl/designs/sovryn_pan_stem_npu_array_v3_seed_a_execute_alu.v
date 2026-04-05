module sovryn_pan_stem_npu_array_v3_seed_a_execute_alu(
  input wire clk,
  input wire rst_n,
  input wire issue_valid,
  input wire [1:0] issue_opcode,
  input wire [1:0] issue_addr,
  input wire [15:0] issue_data,
  input wire [15:0] operand_a,
  input wire [15:0] operand_b,
  output reg alu_valid,
  output reg [1:0] alu_opcode,
  output reg [1:0] alu_addr,
  output reg [15:0] alu_data,
  output reg [15:0] alu_result
);
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      alu_valid <= 1'b0;
      alu_opcode <= 2'd0;
      alu_addr <= 2'd0;
      alu_data <= 16'd0;
      alu_result <= 16'd0;
    end else begin
      alu_valid <= issue_valid && (issue_opcode != 2'b10);
      alu_opcode <= issue_opcode;
      alu_addr <= issue_addr;
      alu_data <= issue_data;
      case (issue_opcode)
        2'b01: alu_result <= operand_a + operand_b;
        default: alu_result <= issue_data;
      endcase
    end
  end
endmodule
