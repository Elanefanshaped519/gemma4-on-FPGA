module sovryn_pan_stem_npu_array_v4_seed_g_hetero_successor_state_tile_stub(
  input wire clk,
  input wire rst_n,
  input wire advance_tick,
  input wire lane_enable,
  input wire arbitration_grant,
  input wire state_valid_in,
  input wire [15:0] state_in,
  input wire [15:0] delta_in,
  input wire [15:0] state_reuse_in,
  output wire [15:0] state_out,
  output wire [15:0] state_reuse_out,
  output wire boundary_live
);
  wire step_valid;
  reg [3:0] local_state_phase_q;
  reg [15:0] local_state_acc_q;

  sovryn_pan_stem_npu_array_v4_seed_g_issue issue_inst (
    .advance_tick(advance_tick),
    .step_valid(step_valid)
  );

  assign boundary_live = local_state_phase_q[0] ^ local_state_acc_q[2];
  assign state_out = local_state_acc_q;
  assign state_reuse_out = local_state_acc_q ^ state_reuse_in;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      local_state_phase_q <= 4'd0;
      local_state_acc_q <= 16'd0;
    end else if (step_valid && lane_enable && state_valid_in) begin
      local_state_phase_q <= local_state_phase_q + 4'd1;
      local_state_acc_q <= local_state_acc_q + state_in + delta_in + state_reuse_in + {15'd0, arbitration_grant};
    end
  end
endmodule
