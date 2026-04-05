module sovryn_pan_stem_npu_array_v4_seed_g_hetero_successor_sfu_tile_stub(
  input wire clk,
  input wire rst_n,
  input wire advance_tick,
  input wire lane_enable,
  input wire arbitration_grant,
  input wire operand_valid_in,
  input wire [7:0] operand_in,
  input wire [7:0] norm_bias_in,
  input wire [7:0] reduction_in,
  output wire [7:0] sfu_out,
  output wire [7:0] reduction_out,
  output wire boundary_live
);
  wire step_valid;
  reg [2:0] local_sfu_phase_q;
  reg [7:0] local_sfu_window_q;

  sovryn_pan_stem_npu_array_v4_seed_g_issue issue_inst (
    .advance_tick(advance_tick),
    .step_valid(step_valid)
  );

  assign boundary_live = local_sfu_phase_q[1] ^ local_sfu_window_q[3];
  assign sfu_out = local_sfu_window_q;
  assign reduction_out = local_sfu_window_q ^ reduction_in;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      local_sfu_phase_q <= 3'd0;
      local_sfu_window_q <= 8'd0;
    end else if (step_valid && lane_enable && operand_valid_in) begin
      local_sfu_phase_q <= local_sfu_phase_q + 3'd1;
      local_sfu_window_q <= operand_in + norm_bias_in + reduction_in + {7'd0, arbitration_grant} + {5'd0, local_sfu_phase_q};
    end
  end
endmodule
