module sovryn_pan_stem_npu_array_v4_seed_a_tile #(
  parameter LOCAL_ROW = 0,
  parameter LOCAL_COL = 0,
  parameter CMD_PACKET_WIDTH = 24,
  parameter OBS_PACKET_WIDTH = 22
)(
  input wire clk,
  input wire rst_n,
  input wire cmd_in_valid,
  input wire [CMD_PACKET_WIDTH-1:0] cmd_in_payload,
  output wire observe_out_valid,
  output wire [OBS_PACKET_WIDTH-1:0] observe_out_payload
);
  wire issue_valid;
  wire [1:0] issue_opcode;
  wire [1:0] issue_addr;
  wire [15:0] issue_data;

  sovryn_pan_stem_npu_array_v4_seed_a_issue #(
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
    .issue_data(issue_data)
  );

  sovryn_pan_stem_npu_array_v4_seed_a_state #(
    .LOCAL_ROW(LOCAL_ROW),
    .LOCAL_COL(LOCAL_COL)
  ) state_inst (
    .clk(clk),
    .rst_n(rst_n),
    .apply_valid(issue_valid),
    .opcode(issue_opcode),
    .local_addr(issue_addr),
    .local_data(issue_data),
    .observe_valid(observe_out_valid),
    .observe_payload(observe_out_payload)
  );
endmodule
