module sovryn_pan_stem_npu_array_v4_seed_f_tile(
  input wire clk,
  input wire rst_n,
  input wire cmd_token_valid,
  input wire [1:0] cmd_token_kind,
  input wire [1:0] cmd_token_addr,
  input wire [15:0] cmd_token_data,
  input wire cmd_token_phase
);
  wire pending_valid;
  wire [1:0] pending_kind;
  wire [1:0] pending_addr;
  wire [15:0] pending_data;
  wire pending_phase;

  sovryn_pan_stem_npu_array_v4_seed_f_issue issue_inst (
    .clk(clk),
    .rst_n(rst_n),
    .cmd_token_valid(cmd_token_valid),
    .cmd_token_kind(cmd_token_kind),
    .cmd_token_addr(cmd_token_addr),
    .cmd_token_data(cmd_token_data),
    .cmd_token_phase(cmd_token_phase),
    .consume_ready(pending_valid),
    .pending_valid(pending_valid),
    .pending_kind(pending_kind),
    .pending_addr(pending_addr),
    .pending_data(pending_data),
    .pending_phase(pending_phase)
  );

  sovryn_pan_stem_npu_array_v4_seed_f_state state_inst (
    .clk(clk),
    .rst_n(rst_n),
    .pending_valid(pending_valid),
    .pending_kind(pending_kind),
    .pending_addr(pending_addr),
    .pending_data(pending_data),
    .pending_phase(pending_phase)
  );
endmodule
