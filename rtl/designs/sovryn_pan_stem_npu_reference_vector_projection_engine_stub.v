module sovryn_pan_stem_npu_reference_vector_projection_engine_stub(
  inout wire VPWR,
  inout wire VGND,
  input wire clk,
  input wire rst_n,
  input wire advance_tick,
  input wire engine_enable,
  input wire multicast_ready,
  input wire [7:0] multicast_feedback,
  input wire [5:0] projection_width,
  output wire [7:0] projection_out,
  output wire [7:0] projection_shadow,
  output wire engine_live
);
  reg [7:0] projection_reg;
  reg [7:0] projection_shadow_reg;
  reg [7:0] token_counter_reg;
  reg live_reg;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      projection_reg <= 8'd0;
      projection_shadow_reg <= 8'd0;
      token_counter_reg <= 8'd0;
      live_reg <= 1'b0;
    end else if (advance_tick && engine_enable) begin
      projection_shadow_reg <= projection_reg ^ multicast_feedback ^ {2'd0, projection_width};
      token_counter_reg <= token_counter_reg + 8'd1;
      projection_reg <= projection_reg + {2'd0, projection_width} + token_counter_reg + multicast_feedback + {7'd0, multicast_ready};
      live_reg <= 1'b1;
    end
  end

  assign projection_out = projection_reg;
  assign projection_shadow = projection_shadow_reg;
  assign engine_live = live_reg;
endmodule
