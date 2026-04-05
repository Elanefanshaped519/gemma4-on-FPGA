module sovryn_pan_stem_npu_reference_vector_reduction_sfu_engine_stub(
  inout wire VPWR,
  inout wire VGND,
  input wire clk,
  input wire rst_n,
  input wire advance_tick,
  input wire engine_enable,
  input wire reduction_fused_required,
  input wire [7:0] projection_shadow,
  input wire [5:0] reduction_width,
  input wire [15:0] state_in,
  output wire [7:0] reduction_out,
  output wire [7:0] activation_out,
  output wire engine_live
);
  reg [7:0] reduction_reg;
  reg [7:0] activation_reg;
  reg live_reg;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      reduction_reg <= 8'd0;
      activation_reg <= 8'd0;
      live_reg <= 1'b0;
    end else if (advance_tick && engine_enable) begin
      reduction_reg <= state_in[15:8] + state_in[7:0] + projection_shadow + {2'd0, reduction_width} + {7'd0, reduction_fused_required};
      activation_reg <= (state_in[15:8] + state_in[7:0] + projection_shadow + {2'd0, reduction_width} + {7'd0, reduction_fused_required})
        + ((state_in[15:8] + state_in[7:0] + projection_shadow + {2'd0, reduction_width} + {7'd0, reduction_fused_required}) >> 1)
        + {7'd0, reduction_fused_required};
      live_reg <= 1'b1;
    end
  end

  assign reduction_out = reduction_reg;
  assign activation_out = activation_reg;
  assign engine_live = live_reg;
endmodule
