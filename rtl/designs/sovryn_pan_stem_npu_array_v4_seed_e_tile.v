module sovryn_pan_stem_npu_array_v4_seed_e_tile #(
  parameter LOCAL_ROW = 0,
  parameter LOCAL_COL = 0
)(
  input wire clk,
  input wire rst_n,
  input wire cmd_in_valid,
  input wire [23:0] cmd_in_payload
);
  wire apply_valid;
  wire [1:0] opcode;
  wire [1:0] local_addr;
  wire [15:0] local_data;

  sovryn_pan_stem_npu_array_v4_seed_e_issue #(
    .LOCAL_ROW(LOCAL_ROW),
    .LOCAL_COL(LOCAL_COL)
  ) issue_inst (
    .cmd_in_valid(cmd_in_valid),
    .cmd_in_payload(cmd_in_payload),
    .apply_valid(apply_valid),
    .opcode(opcode),
    .local_addr(local_addr),
    .local_data(local_data)
  );

  sovryn_pan_stem_npu_array_v4_seed_e_state state_inst (
    .clk(clk),
    .rst_n(rst_n),
    .apply_valid(apply_valid),
    .opcode(opcode),
    .local_addr(local_addr),
    .local_data(local_data)
  );
endmodule
