`include "sovryn_pan_stem_npu_array_v4_seed_g_baseline.v"
`include "sovryn_pan_stem_npu_reference_vector_projection_engine_stub.v"
`include "sovryn_pan_stem_npu_reference_vector_persistent_state_engine_stub.v"
`include "sovryn_pan_stem_npu_reference_vector_reduction_sfu_engine_stub.v"
`include "sovryn_pan_stem_npu_reference_vector_multicast_fabric_stub.v"

module sovryn_pan_stem_npu_seed_g_derived_reference_vector_successor_v3_graph_bi_mamba_json_ssm_hotpath_streaming_fixture_top(
`ifdef USE_POWER_PINS
  inout wire VPWR,
  inout wire VGND,
`endif
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
  output wire derived_state_write_valid,
  output wire [2:0] derived_active_bank,
  output wire [15:0] derived_projection_window,
  output wire [15:0] derived_window_sum,
  output wire [15:0] derived_reduction_pipeline,
  output wire [15:0] derived_norm_activation,
  output wire [15:0] derived_parent_mix_data,
  output wire derived_parent_anchor_seen,
  output wire [7:0] debug_parent_feedback,
  output wire [7:0] debug_projection_vector,
  output wire [7:0] debug_activation_vector,
  output wire derived_path_selected
);
  localparam integer PROJECTION_LANE_WIDTH = 8;
  localparam integer PERSISTENT_STATE_BANKS = 5;
  localparam integer REDUCTION_LANE_WIDTH = 8;
  localparam integer LOCAL_SCRATCH_DEPTH = 16;
  localparam integer MAX_PROJECTION_COMM_PRESSURE = 3;
  localparam integer MAX_EFFECTIVE_II = 13;

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
`ifndef USE_POWER_PINS
  supply1 VPWR;
  supply0 VGND;
`endif

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
    .VPWR(VPWR),
    .VGND(VGND),
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
    .VPWR(VPWR),
    .VGND(VGND),
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
    .VPWR(VPWR),
    .VGND(VGND),
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
    .VPWR(VPWR),
    .VGND(VGND),
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

  localparam integer ACTIVE_BANK_WIDTH = (PERSISTENT_STATE_BANKS <= 1) ? 1 : $clog2(PERSISTENT_STATE_BANKS);
  localparam integer SCRATCH_PTR_WIDTH = (LOCAL_SCRATCH_DEPTH <= 1) ? 1 : $clog2(LOCAL_SCRATCH_DEPTH);
  localparam integer ACTIVE_BANK_LAST_INT = PERSISTENT_STATE_BANKS - 1;
  localparam integer SCRATCH_PTR_LAST_INT = LOCAL_SCRATCH_DEPTH - 1;
  integer derived_index;
  reg [15:0] state_bank_regs [0:PERSISTENT_STATE_BANKS-1];
  reg [15:0] scratchpad_regs [0:LOCAL_SCRATCH_DEPTH-1];
  reg derived_boundary_valid_reg;
  reg derived_state_write_valid_reg;
  reg [ACTIVE_BANK_WIDTH-1:0] derived_active_bank_reg;
  reg [SCRATCH_PTR_WIDTH-1:0] scratch_write_ptr_reg;
  reg [15:0] parent_mix_reg;
  reg [15:0] projection_window_reg;
  reg [15:0] window_sum_reg;
  reg [15:0] reduction_accumulator_reg;
  reg [15:0] reduction_pipeline_reg;
  reg [15:0] norm_activation_reg;
  reg parent_anchor_seen_reg;
  wire [15:0] current_state_bank_value;
  wire [15:0] current_scratchpad_value;

  assign current_state_bank_value = state_bank_regs[derived_active_bank_reg];
  assign current_scratchpad_value = scratchpad_regs[scratch_write_ptr_reg];

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      derived_boundary_valid_reg <= 1'b0;
      derived_state_write_valid_reg <= 1'b0;
      derived_active_bank_reg <= {ACTIVE_BANK_WIDTH{1'b0}};
      scratch_write_ptr_reg <= {SCRATCH_PTR_WIDTH{1'b0}};
      parent_mix_reg <= 16'd0;
      projection_window_reg <= 16'd0;
      window_sum_reg <= 16'd0;
      reduction_accumulator_reg <= 16'd0;
      reduction_pipeline_reg <= 16'd0;
      norm_activation_reg <= 16'd0;
      parent_anchor_seen_reg <= 1'b0;
      for (derived_index = 0; derived_index < PERSISTENT_STATE_BANKS; derived_index = derived_index + 1) begin
        state_bank_regs[derived_index] <= 16'd0;
      end
      for (derived_index = 0; derived_index < LOCAL_SCRATCH_DEPTH; derived_index = derived_index + 1) begin
        scratchpad_regs[derived_index] <= 16'd0;
      end
    end else if (advance_tick) begin
      projection_window_reg <= {projection_shadow, projection_vector};
      parent_mix_reg <= {8'd0, parent_read_data[7:0]} ^ {8'd0, multicast_vector};
      window_sum_reg <= state_vector + {8'd0, projection_vector} + {8'd0, reduction_vector};
      reduction_accumulator_reg <= current_state_bank_value + {8'd0, activation_vector} + {8'd0, projection_shadow} + {8'd0, debug_parent_feedback};
      reduction_pipeline_reg <= reduction_accumulator_reg + window_sum_reg + {8'd0, multicast_vector};
      norm_activation_reg <= reduction_pipeline_reg + current_scratchpad_value + {8'd0, activation_vector};
      state_bank_regs[derived_active_bank_reg] <= reduction_accumulator_reg + window_sum_reg + parent_mix_reg;
      scratchpad_regs[scratch_write_ptr_reg] <= {8'd0, projection_shadow} + parent_mix_reg + {8'd0, multicast_vector};
      derived_boundary_valid_reg <= projection_live | state_live | reduction_live | multicast_live;
      derived_state_write_valid_reg <= state_live | reduction_live;
      parent_anchor_seen_reg <= parent_anchor_seen_reg | parent_read_valid;
      if (derived_active_bank_reg == ACTIVE_BANK_LAST_INT[ACTIVE_BANK_WIDTH-1:0]) begin
        derived_active_bank_reg <= {ACTIVE_BANK_WIDTH{1'b0}};
      end else begin
        derived_active_bank_reg <= derived_active_bank_reg + 1'b1;
      end
      if (scratch_write_ptr_reg == SCRATCH_PTR_LAST_INT[SCRATCH_PTR_WIDTH-1:0]) begin
        scratch_write_ptr_reg <= {SCRATCH_PTR_WIDTH{1'b0}};
      end else begin
        scratch_write_ptr_reg <= scratch_write_ptr_reg + 1'b1;
      end
    end
  end

  assign derived_state_write_valid = derived_state_write_valid_reg;
  assign derived_active_bank = derived_active_bank_reg;
  assign derived_projection_window = projection_window_reg;
  assign derived_window_sum = window_sum_reg;
  assign derived_reduction_pipeline = reduction_pipeline_reg;
  assign derived_norm_activation = norm_activation_reg;
  assign derived_parent_mix_data = parent_mix_reg;
  assign derived_parent_anchor_seen = parent_anchor_seen_reg;
  assign debug_parent_feedback = parent_read_data[7:0];
  assign debug_projection_vector = projection_vector;
  assign debug_activation_vector = activation_vector;
  assign projection_lane_width = PROJECTION_LANE_WIDTH[7:0];
  assign persistent_state_banks = PERSISTENT_STATE_BANKS[7:0];
  assign reduction_lane_width = REDUCTION_LANE_WIDTH[7:0];
  assign max_projection_comm_pressure = MAX_PROJECTION_COMM_PRESSURE[7:0];
  assign max_effective_ii = MAX_EFFECTIVE_II[7:0];
  assign derived_engine_live_mask = {multicast_live, reduction_live, state_live, projection_live};
  assign derived_read_data = reduction_pipeline_reg ^ norm_activation_reg ^ current_state_bank_value;
  assign derived_path_selected = |derived_engine_live_mask | derived_state_write_valid_reg;
  assign read_valid = parent_read_valid | derived_boundary_valid_reg;
  assign read_data = derived_read_data ^ parent_read_data;
endmodule
