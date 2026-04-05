`include "sovryn_pan_stem_npu_array_v4_seed_g_baseline.v"
`include "sovryn_pan_stem_npu_reference_vector_projection_engine_stub.v"
`include "sovryn_pan_stem_npu_reference_vector_persistent_state_engine_stub.v"
`include "sovryn_pan_stem_npu_reference_vector_reduction_sfu_engine_stub.v"
`include "sovryn_pan_stem_npu_reference_vector_multicast_fabric_stub.v"

module sovryn_pan_stem_npu_seed_g_derived_reference_vector_successor_v1_graph_bi_mamba_json_dual_branch_streaming_fixture_top(
  input wire clk,
  input wire rst_n,
  input wire advance_tick,
  output wire read_valid,
  output wire [15:0] read_data,
  output wire parent_read_valid,
  output wire [15:0] parent_read_data,
  output wire [2:0] parent_array_rows,
  output wire [2:0] parent_array_cols,
  output wire [3:0] derived_engine_live_mask,
  output wire [7:0] projection_lane_width,
  output wire [7:0] persistent_state_banks,
  output wire [7:0] reduction_lane_width,
  output wire [7:0] max_projection_comm_pressure,
  output wire [7:0] max_effective_ii,
  output wire [7:0] debug_parent_feedback,
  output wire [7:0] debug_projection_vector,
  output wire [7:0] debug_activation_vector,
  output wire derived_path_selected
);
  localparam integer PROJECTION_LANE_WIDTH = 10;
  localparam integer PERSISTENT_STATE_BANKS = 4;
  localparam integer REDUCTION_LANE_WIDTH = 8;
  localparam integer LOCAL_SCRATCH_DEPTH = 16;
  localparam integer MAX_PROJECTION_COMM_PRESSURE = 3;
  localparam integer MAX_EFFECTIVE_II = 5;

  wire [1:0] parent_read_row_unused;
  wire [1:0] parent_read_col_unused;
  wire [1:0] parent_read_addr_unused;
  wire projection_live;
  wire state_live;
  wire reduction_live;
  wire multicast_live;
  wire [7:0] projection_vector;
  wire [7:0] projection_shadow;
  wire [15:0] state_vector;
  wire [7:0] state_window;
  wire [1:0] active_bank;
  wire [7:0] reduction_vector;
  wire [7:0] activation_vector;
  wire [7:0] multicast_vector;
  wire [15:0] derived_read_data;

  sovryn_pan_stem_npu_array_v4_seed_g_top parent_seed_g_top_inst (
    .clk(clk),
    .rst_n(rst_n),
    .advance_tick(advance_tick),
    .read_valid(parent_read_valid),
    .read_row(parent_read_row_unused),
    .read_col(parent_read_col_unused),
    .read_addr(parent_read_addr_unused),
    .read_data(parent_read_data),
    .array_rows(parent_array_rows),
    .array_cols(parent_array_cols)
  );

  sovryn_pan_stem_npu_reference_vector_projection_engine_stub projection_engine_inst (
    .clk(clk),
    .rst_n(rst_n),
    .advance_tick(advance_tick),
    .engine_enable(1'b1),
    .multicast_ready(parent_read_valid),
    .multicast_feedback(parent_read_data[7:0]),
    .projection_width(PROJECTION_LANE_WIDTH[5:0]),
    .projection_out(projection_vector),
    .projection_shadow(projection_shadow),
    .engine_live(projection_live)
  );

  sovryn_pan_stem_npu_reference_vector_persistent_state_engine_stub persistent_state_engine_inst (
    .clk(clk),
    .rst_n(rst_n),
    .advance_tick(advance_tick),
    .engine_enable(1'b1),
    .state_bank_count(PERSISTENT_STATE_BANKS[5:0]),
    .projection_in(projection_vector),
    .reduction_feedback(reduction_vector),
    .state_out(state_vector),
    .state_window(state_window),
    .active_bank(active_bank),
    .engine_live(state_live)
  );

  sovryn_pan_stem_npu_reference_vector_reduction_sfu_engine_stub reduction_sfu_engine_inst (
    .clk(clk),
    .rst_n(rst_n),
    .advance_tick(advance_tick),
    .engine_enable(1'b1),
    .reduction_fused_required(1'b1),
    .projection_shadow(projection_shadow),
    .reduction_width(REDUCTION_LANE_WIDTH[5:0]),
    .state_in(state_vector),
    .reduction_out(reduction_vector),
    .activation_out(activation_vector),
    .engine_live(reduction_live)
  );

  sovryn_pan_stem_npu_reference_vector_multicast_fabric_stub multicast_fabric_inst (
    .clk(clk),
    .rst_n(rst_n),
    .advance_tick(advance_tick),
    .fabric_enable(1'b1),
    .source_vector(reduction_vector),
    .projection_vector(projection_vector),
    .activation_vector(activation_vector),
    .multicast_vector(multicast_vector),
    .fabric_live(multicast_live)
  );

  reg derived_boundary_valid_reg;
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      derived_boundary_valid_reg <= 1'b0;
    end else if (advance_tick) begin
      derived_boundary_valid_reg <= projection_live | state_live | reduction_live | multicast_live;
    end
  end

  assign debug_parent_feedback = parent_read_data[7:0];
  assign debug_projection_vector = projection_vector;
  assign debug_activation_vector = activation_vector;
  assign projection_lane_width = PROJECTION_LANE_WIDTH[7:0];
  assign persistent_state_banks = PERSISTENT_STATE_BANKS[7:0];
  assign reduction_lane_width = REDUCTION_LANE_WIDTH[7:0];
  assign max_projection_comm_pressure = MAX_PROJECTION_COMM_PRESSURE[7:0];
  assign max_effective_ii = MAX_EFFECTIVE_II[7:0];
  assign derived_engine_live_mask = {multicast_live, reduction_live, state_live, projection_live};
  assign derived_read_data = {activation_vector, projection_vector};
  assign derived_path_selected = |derived_engine_live_mask;
  assign read_valid = parent_read_valid | derived_boundary_valid_reg;
  assign read_data = derived_read_data ^ parent_read_data;
endmodule
