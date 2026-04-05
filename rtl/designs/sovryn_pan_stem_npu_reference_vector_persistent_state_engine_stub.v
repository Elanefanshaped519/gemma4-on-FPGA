module sovryn_pan_stem_npu_reference_vector_persistent_state_engine_stub(
  inout wire VPWR,
  inout wire VGND,
  input wire clk,
  input wire rst_n,
  input wire advance_tick,
  input wire engine_enable,
  input wire [5:0] state_bank_count,
  input wire [7:0] projection_in,
  input wire [7:0] reduction_feedback,
  output wire [15:0] state_out,
  output wire [7:0] state_window,
  output wire [1:0] active_bank,
  output wire engine_live
);
  reg [15:0] state_reg;
  reg [7:0] state_window_reg;
  reg [1:0] active_bank_reg;
  reg live_reg;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      state_reg <= 16'd0;
      state_window_reg <= 8'd0;
      active_bank_reg <= 2'd0;
      live_reg <= 1'b0;
    end else if (advance_tick && engine_enable) begin
      state_window_reg <= projection_in ^ reduction_feedback ^ {2'd0, state_bank_count};
      state_reg <= state_reg + {8'd0, projection_in} + {8'd0, reduction_feedback} + {10'd0, state_bank_count} + {14'd0, active_bank_reg};
      active_bank_reg <= active_bank_reg + 2'd1;
      live_reg <= 1'b1;
    end
  end

  assign state_out = state_reg;
  assign state_window = state_window_reg;
  assign active_bank = active_bank_reg;
  assign engine_live = live_reg;
endmodule
