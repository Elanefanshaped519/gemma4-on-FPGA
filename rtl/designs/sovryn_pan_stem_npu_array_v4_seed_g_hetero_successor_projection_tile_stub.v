module sovryn_pan_stem_npu_array_v4_seed_g_hetero_successor_projection_tile_stub(
  input wire clk,
  input wire rst_n,
  input wire advance_tick,
  input wire lane_enable,
  input wire arbitration_grant,
  input wire [7:0] activation_in,
  input wire [7:0] weight_in,
  input wire [7:0] partial_sum_in,
  output wire [7:0] projection_out,
  output wire [7:0] partial_sum_out,
  output wire boundary_live
);
  wire step_valid;
  reg [1:0] local_projection_phase_q;
  reg [7:0] local_projection_acc_q;

  sovryn_pan_stem_npu_array_v4_seed_g_issue issue_inst (
    .advance_tick(advance_tick),
    .step_valid(step_valid)
  );

  assign boundary_live = local_projection_phase_q[0] ^ local_projection_acc_q[0];
  assign projection_out = local_projection_acc_q;
  assign partial_sum_out = local_projection_acc_q ^ partial_sum_in;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      local_projection_phase_q <= 2'd0;
      local_projection_acc_q <= 8'd0;
    end else if (step_valid && lane_enable) begin
      local_projection_phase_q <= local_projection_phase_q + 2'd1;
      local_projection_acc_q <= local_projection_acc_q + activation_in + weight_in + partial_sum_in + {7'd0, arbitration_grant};
    end
  end
endmodule
