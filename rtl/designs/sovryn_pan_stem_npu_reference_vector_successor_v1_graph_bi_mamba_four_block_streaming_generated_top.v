`include "sovryn_pan_stem_npu_reference_vector_projection_engine_stub.v"
`include "sovryn_pan_stem_npu_reference_vector_persistent_state_engine_stub.v"
`include "sovryn_pan_stem_npu_reference_vector_reduction_sfu_engine_stub.v"
`include "sovryn_pan_stem_npu_reference_vector_multicast_fabric_stub.v"

module sovryn_pan_stem_npu_reference_vector_successor_v1_graph_bi_mamba_four_block_streaming_generated_top(
  input wire clk,
  input wire rst_n,
  input wire advance_tick,
  output wire read_valid,
  output wire [15:0] read_data,
  output wire [1:0] selected_engine,
  output wire [3:0] engine_live_mask,
  output wire [5:0] projection_lane_width,
  output wire [5:0] persistent_state_banks,
  output wire [5:0] reduction_lane_width,
  output wire [5:0] max_projection_comm_pressure,
  output wire [5:0] max_effective_ii,
  output wire [7:0] debug_projection_vector,
  output wire [7:0] debug_projection_shadow,
  output wire [15:0] debug_state_vector,
  output wire [7:0] debug_state_window,
  output wire [1:0] debug_active_bank,
  output wire [7:0] debug_reduction_vector,
  output wire [7:0] debug_activation_vector,
  output wire [7:0] debug_multicast_vector,
  output wire reduction_fused_required,
  output wire multicast_fabric_required
);
  localparam integer PROJECTION_LANE_WIDTH = 12;
  localparam integer PERSISTENT_STATE_BANKS = 8;
  localparam integer REDUCTION_LANE_WIDTH = 16;
  localparam integer LOCAL_SCRATCH_DEPTH = 22;
  localparam integer MAX_PROJECTION_COMM_PRESSURE = 5;
  localparam integer MAX_EFFECTIVE_II = 12;

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

  assign reduction_fused_required = 1'b1;
  assign multicast_fabric_required = 1'b1;
  assign projection_lane_width = PROJECTION_LANE_WIDTH[5:0];
  assign persistent_state_banks = PERSISTENT_STATE_BANKS[5:0];
  assign reduction_lane_width = REDUCTION_LANE_WIDTH[5:0];
  assign max_projection_comm_pressure = MAX_PROJECTION_COMM_PRESSURE[5:0];
  assign max_effective_ii = MAX_EFFECTIVE_II[5:0];
  assign debug_projection_vector = projection_vector;
  assign debug_projection_shadow = projection_shadow;
  assign debug_state_vector = state_vector;
  assign debug_state_window = state_window;
  assign debug_active_bank = active_bank;
  assign debug_reduction_vector = reduction_vector;
  assign debug_activation_vector = activation_vector;
  assign debug_multicast_vector = multicast_vector;
  assign read_data = {activation_vector, projection_vector};
  assign engine_live_mask = {multicast_live, reduction_live, state_live, projection_live};
  assign selected_engine = reduction_live ? 2'd2 : state_live ? 2'd1 : 2'd0;

  sovryn_pan_stem_npu_reference_vector_projection_engine_stub projection_engine_inst (
    .clk(clk),
    .rst_n(rst_n),
    .advance_tick(advance_tick),
    .engine_enable(1'b1),
    .multicast_ready(multicast_live),
    .multicast_feedback(multicast_vector),
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
    .reduction_fused_required(reduction_fused_required),
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

  reg boundary_valid_reg;
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      boundary_valid_reg <= 1'b0;
    end else if (advance_tick) begin
      boundary_valid_reg <= projection_live | state_live | reduction_live | multicast_live;
    end
  end

  assign read_valid = boundary_valid_reg;
endmodule
