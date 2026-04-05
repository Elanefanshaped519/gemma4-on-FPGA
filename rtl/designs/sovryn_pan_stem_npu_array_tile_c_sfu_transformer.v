module sovryn_pan_stem_npu_array_tile_c_sfu_transformer (
  input  wire clk,
  input  wire rst_n,
  input  wire [15:0] ingress_data,
  output reg  [15:0] egress_data
);
  // Standard Attention Feedforward / QKV MAC Engine
  // Multiplies the input by a trained linear weight slice.
  reg signed [15:0] weight_cache [0:3];
  reg [1:0] cache_idx;
  reg signed [31:0] accumulator;
  
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      egress_data <= 16'd0;
      accumulator <= 32'd0;
      cache_idx <= 2'd0;
      weight_cache[0] <= 16'h0100;
      weight_cache[1] <= -16'h0080;
      weight_cache[2] <= 16'h0200;
      weight_cache[3] <= -16'h0150;
    end else begin
      accumulator <= accumulator + ($signed(ingress_data) * weight_cache[cache_idx]);
      cache_idx <= cache_idx + 1;
      
      // Output slice (Scaled pseudo-softmax)
      egress_data <= accumulator[23:8]; 
    end
  end
endmodule