module sovryn_pan_stem_npu_array_v3_seed_a_tile #(
  parameter LOCAL_ROW = 0,
  parameter LOCAL_COL = 0,
  parameter CMD_PACKET_WIDTH = 24,
  parameter OBS_PACKET_WIDTH = 22
)(
  input wire clk,
  input wire rst_n,
  input wire cmd_in_valid,
  input wire [CMD_PACKET_WIDTH-1:0] cmd_in_payload,
  output wire cmd_out_valid,
  output wire [CMD_PACKET_WIDTH-1:0] cmd_out_payload,
  input wire observe_in_valid,
  input wire [OBS_PACKET_WIDTH-1:0] observe_in_payload,
  output wire observe_out_valid,
  output wire [OBS_PACKET_WIDTH-1:0] observe_out_payload
);
  localparam [1:0] ROW_ID = LOCAL_ROW[1:0];
  localparam [1:0] COL_ID = LOCAL_COL[1:0];

  wire issue_valid;
  wire [1:0] issue_opcode;
  wire [1:0] issue_addr;
  wire [15:0] issue_data;
  wire alu_valid;
  wire [1:0] alu_opcode;
  wire [1:0] alu_addr;
  wire [15:0] alu_data;
  wire [15:0] alu_result;
  wire mul_valid;
  wire [1:0] mul_addr;
  wire [15:0] mul_result;
  wire [15:0] operand_a;
  wire [15:0] operand_b;
  wire local_observe_valid;
  wire [OBS_PACKET_WIDTH-1:0] local_observe_payload;

  sovryn_pan_stem_npu_array_v3_seed_a_issue #(
    .LOCAL_ROW(LOCAL_ROW),
    .LOCAL_COL(LOCAL_COL),
    .CMD_PACKET_WIDTH(CMD_PACKET_WIDTH)
  ) issue_inst (
    .clk(clk),
    .rst_n(rst_n),
    .cmd_in_valid(cmd_in_valid),
    .cmd_in_payload(cmd_in_payload),
    .issue_valid(issue_valid),
    .issue_opcode(issue_opcode),
    .issue_addr(issue_addr),
    .issue_data(issue_data),
    .cmd_out_valid(cmd_out_valid),
    .cmd_out_payload(cmd_out_payload)
  );

  sovryn_pan_stem_npu_array_v3_seed_a_execute_alu execute_alu_inst (
    .clk(clk),
    .rst_n(rst_n),
    .issue_valid(issue_valid),
    .issue_opcode(issue_opcode),
    .issue_addr(issue_addr),
    .issue_data(issue_data),
    .operand_a(operand_a),
    .operand_b(operand_b),
    .alu_valid(alu_valid),
    .alu_opcode(alu_opcode),
    .alu_addr(alu_addr),
    .alu_data(alu_data),
    .alu_result(alu_result)
  );

  sovryn_pan_stem_npu_array_v3_seed_a_execute_mul execute_mul_inst (
    .clk(clk),
    .rst_n(rst_n),
    .issue_valid(issue_valid),
    .issue_opcode(issue_opcode),
    .issue_addr(issue_addr),
    .operand_a(operand_a),
    .operand_b(operand_b),
    .mul_valid(mul_valid),
    .mul_addr(mul_addr),
    .mul_result(mul_result)
  );

  sovryn_pan_stem_npu_array_v3_seed_a_retire_writeback retire_writeback_inst (
    .clk(clk),
    .rst_n(rst_n),
    .alu_valid(alu_valid),
    .alu_opcode(alu_opcode),
    .alu_addr(alu_addr),
    .alu_data(alu_data),
    .alu_result(alu_result),
    .mul_valid(mul_valid),
    .mul_addr(mul_addr),
    .mul_result(mul_result),
    .local_row(ROW_ID),
    .local_col(COL_ID),
    .operand_a(operand_a),
    .operand_b(operand_b),
    .local_observe_valid(local_observe_valid),
    .local_observe_payload(local_observe_payload)
  );

  sovryn_pan_stem_npu_array_v3_seed_a_observe_debug #(
    .OBS_PACKET_WIDTH(OBS_PACKET_WIDTH)
  ) observe_debug_inst (
    .clk(clk),
    .rst_n(rst_n),
    .local_observe_valid(local_observe_valid),
    .local_observe_payload(local_observe_payload),
    .observe_in_valid(observe_in_valid),
    .observe_in_payload(observe_in_payload),
    .observe_out_valid(observe_out_valid),
    .observe_out_payload(observe_out_payload)
  );
endmodule
