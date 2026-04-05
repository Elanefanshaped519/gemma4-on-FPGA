module sovryn_pan_stem_npu_array_tile #(
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

  wire [1:0] cmd_opcode = cmd_in_payload[23:22];
  wire [1:0] cmd_target_row = cmd_in_payload[21:20];
  wire [1:0] cmd_target_col = cmd_in_payload[19:18];
  wire [1:0] cmd_addr = cmd_in_payload[17:16];
  wire [15:0] cmd_data = cmd_in_payload[15:0];
  wire cmd_matches = cmd_in_valid && (cmd_target_row == ROW_ID) && (cmd_target_col == COL_ID);

  wire queue_valid;
  wire [CMD_PACKET_WIDTH-1:0] queue_payload;
  wire consume_queue = queue_valid;
  wire [15:0] operand_a;
  wire [15:0] operand_b;
  wire [15:0] computed_result;
  wire local_observe_valid;
  wire [OBS_PACKET_WIDTH-1:0] local_observe_payload;

  sovryn_pan_stem_npu_array_tile_queue #(
    .WIDTH(CMD_PACKET_WIDTH)
  ) queue_inst (
    .clk(clk),
    .rst_n(rst_n),
    .enqueue_valid(cmd_matches),
    .enqueue_payload(cmd_in_payload),
    .consume(consume_queue),
    .queued_valid(queue_valid),
    .queued_payload(queue_payload)
  );

  sovryn_pan_stem_npu_array_tile_datapath datapath_inst (
    .opcode(queue_payload[23:22]),
    .operand_a(operand_a),
    .operand_b(operand_b),
    .result_data(computed_result)
  );

  sovryn_pan_stem_npu_array_tile_commit commit_inst (
    .clk(clk),
    .rst_n(rst_n),
    .apply_valid(queue_valid),
    .opcode(queue_payload[23:22]),
    .local_row(ROW_ID),
    .local_col(COL_ID),
    .local_addr(queue_payload[17:16]),
    .local_data(queue_payload[15:0]),
    .computed_result(computed_result),
    .operand_a(operand_a),
    .operand_b(operand_b),
    .observe_valid(local_observe_valid),
    .observe_payload(local_observe_payload)
  );

  assign cmd_out_valid = cmd_in_valid && !cmd_matches;
  assign cmd_out_payload = cmd_in_payload;

  assign observe_out_valid = local_observe_valid ? 1'b1 : observe_in_valid;
  assign observe_out_payload = local_observe_valid ? local_observe_payload : observe_in_payload;
endmodule
