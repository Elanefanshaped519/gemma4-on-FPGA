module sovryn_pan_stem_npu_array_v4_seed_e_issue #(
  parameter LOCAL_ROW = 0,
  parameter LOCAL_COL = 0
)(
  input wire cmd_in_valid,
  input wire [23:0] cmd_in_payload,
  output wire apply_valid,
  output wire [1:0] opcode,
  output wire [1:0] local_addr,
  output wire [15:0] local_data
);
  wire [1:0] cmd_opcode = cmd_in_payload[23:22];
  wire [1:0] cmd_row = cmd_in_payload[21:20];
  wire [1:0] cmd_col = cmd_in_payload[19:18];

  assign apply_valid = cmd_in_valid
    && (cmd_row == LOCAL_ROW[1:0])
    && (cmd_col == LOCAL_COL[1:0]);
  assign opcode = cmd_opcode;
  assign local_addr = cmd_in_payload[17:16];
  assign local_data = cmd_in_payload[15:0];
endmodule
