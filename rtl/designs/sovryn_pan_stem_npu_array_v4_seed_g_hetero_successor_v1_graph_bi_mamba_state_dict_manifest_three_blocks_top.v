`include "sovryn_pan_stem_npu_array_v4_seed_g_issue.v"
`include "sovryn_pan_stem_npu_array_v4_seed_g_hetero_successor_projection_tile_stub.v"
`include "sovryn_pan_stem_npu_array_v4_seed_g_hetero_successor_state_tile_stub.v"
`include "sovryn_pan_stem_npu_array_v4_seed_g_hetero_successor_sfu_tile_stub.v"

module sovryn_pan_stem_npu_array_v4_seed_g_hetero_successor_v1_graph_bi_mamba_state_dict_manifest_three_blocks_top(
  input wire clk,
  input wire rst_n,
  input wire advance_tick,
  output wire read_valid,
  output wire [2:0] read_row,
  output wire [2:0] read_col,
  output wire [3:0] read_addr,
  output wire [15:0] read_data,
  output wire [2:0] array_rows,
  output wire [2:0] array_cols,
  output wire [2:0] lane_live_mask,
  output wire [2:0] max_allowed_hops,
  output wire [1:0] seed_hop_headroom,
  output wire fanin_arbiter_required
);
  localparam integer ARRAY_ROWS = 3;
  localparam integer ARRAY_COLS = 6;
  localparam integer TOTAL_TILE_SLOTS = 18;
  localparam integer PROJECTION_ROW = 0;
  localparam integer STATE_ROW = 1;
  localparam integer SFU_ROW = 2;
  localparam integer MAX_ALLOWED_HOPS = 3;
  localparam integer SEED_HOP_HEADROOM = 0;

  wire [TOTAL_TILE_SLOTS-1:0] tile_boundary_live;
  wire [7:0] projection_lane_outputs [0:ARRAY_COLS-1];
  wire [7:0] projection_lane_partial_sums [0:ARRAY_COLS-1];
  wire [15:0] state_lane_outputs [0:ARRAY_COLS-1];
  wire [15:0] state_lane_reuse [0:ARRAY_COLS-1];
  wire [7:0] sfu_lane_outputs [0:ARRAY_COLS-1];
  wire [7:0] sfu_lane_reduction [0:ARRAY_COLS-1];
  wire projection_lane_live;
  wire state_lane_live;
  wire sfu_lane_live;
  wire array_boundary_live;
  wire [2:0] selected_read_row;

  assign projection_lane_live = |tile_boundary_live[ARRAY_COLS-1:0];
  assign state_lane_live = |tile_boundary_live[(2 * ARRAY_COLS) - 1:ARRAY_COLS];
  assign sfu_lane_live = |tile_boundary_live[(3 * ARRAY_COLS) - 1:(2 * ARRAY_COLS)];
  assign lane_live_mask = {sfu_lane_live, state_lane_live, projection_lane_live};
  assign array_boundary_live = |lane_live_mask;
  assign selected_read_row = sfu_lane_live ? 3'd2 : state_lane_live ? 3'd1 : 3'd0;

  assign array_rows = ARRAY_ROWS[2:0];
  assign array_cols = ARRAY_COLS[2:0];
  assign max_allowed_hops = MAX_ALLOWED_HOPS[2:0];
  assign seed_hop_headroom = SEED_HOP_HEADROOM[1:0];
  assign fanin_arbiter_required = 1'b0;

  genvar projection_col_idx;
  generate
    for (projection_col_idx = 0; projection_col_idx < ARRAY_COLS; projection_col_idx = projection_col_idx + 1) begin: projection_lane
      sovryn_pan_stem_npu_array_v4_seed_g_hetero_successor_projection_tile_stub projection_tile_inst (
        .clk(clk),
        .rst_n(rst_n),
        .advance_tick(advance_tick),
        .lane_enable(1'b1),
        .arbitration_grant(1'b1),
        .activation_in({5'd0, projection_col_idx[2:0]}),
        .weight_in({4'd0, projection_col_idx[3:0]}),
        .partial_sum_in({7'd0, projection_col_idx[0]}),
        .projection_out(projection_lane_outputs[projection_col_idx]),
        .partial_sum_out(projection_lane_partial_sums[projection_col_idx]),
        .boundary_live(tile_boundary_live[projection_col_idx])
      );
    end
  endgenerate

  genvar state_col_idx;
  generate
    for (state_col_idx = 0; state_col_idx < ARRAY_COLS; state_col_idx = state_col_idx + 1) begin: state_lane
      sovryn_pan_stem_npu_array_v4_seed_g_hetero_successor_state_tile_stub state_tile_inst (
        .clk(clk),
        .rst_n(rst_n),
        .advance_tick(advance_tick),
        .lane_enable(1'b1),
        .arbitration_grant(1'b1),
        .state_valid_in(1'b1),
        .state_in({12'd0, state_col_idx[3:0]}),
        .delta_in({11'd0, state_col_idx[3:0], 1'b1}),
        .state_reuse_in({8'd0, projection_lane_partial_sums[state_col_idx]}),
        .state_out(state_lane_outputs[state_col_idx]),
        .state_reuse_out(state_lane_reuse[state_col_idx]),
        .boundary_live(tile_boundary_live[ARRAY_COLS + state_col_idx])
      );
    end
  endgenerate

  genvar sfu_col_idx;
  generate
    for (sfu_col_idx = 0; sfu_col_idx < ARRAY_COLS; sfu_col_idx = sfu_col_idx + 1) begin: sfu_lane
      sovryn_pan_stem_npu_array_v4_seed_g_hetero_successor_sfu_tile_stub sfu_tile_inst (
        .clk(clk),
        .rst_n(rst_n),
        .advance_tick(advance_tick),
        .lane_enable(1'b1),
        .arbitration_grant(fanin_arbiter_required),
        .operand_valid_in(1'b1),
        .operand_in({5'd0, sfu_col_idx[2:0]}),
        .norm_bias_in({5'd1, sfu_col_idx[2:0]}),
        .reduction_in(state_lane_reuse[sfu_col_idx][7:0]),
        .sfu_out(sfu_lane_outputs[sfu_col_idx]),
        .reduction_out(sfu_lane_reduction[sfu_col_idx]),
        .boundary_live(tile_boundary_live[(2 * ARRAY_COLS) + sfu_col_idx])
      );
    end
  endgenerate

  (* keep = "true" *) reg cts_anchor_reg;
  (* keep = "true" *) reg cts_shadow_reg;
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      cts_anchor_reg <= 1'b0;
      cts_shadow_reg <= 1'b0;
    end else if (advance_tick) begin
      cts_anchor_reg <= ~cts_anchor_reg;
      cts_shadow_reg <= cts_anchor_reg ^ array_boundary_live;
    end
  end

  assign read_valid = cts_anchor_reg;
  assign read_row = selected_read_row;
  assign read_col = 3'd0;
  assign read_addr = 4'd0;
  assign read_data = {sfu_lane_outputs[0], projection_lane_outputs[0]};
endmodule
