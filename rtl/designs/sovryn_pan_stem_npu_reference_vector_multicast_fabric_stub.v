module sovryn_pan_stem_npu_reference_vector_multicast_fabric_stub(
  inout wire VPWR,
  inout wire VGND,
  input wire clk,
  input wire rst_n,
  input wire advance_tick,
  input wire fabric_enable,
  input wire [7:0] source_vector,
  input wire [7:0] projection_vector,
  input wire [7:0] activation_vector,
  output wire [7:0] multicast_vector,
  output wire fabric_live
);
  reg [7:0] multicast_reg;
  reg live_reg;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      multicast_reg <= 8'd0;
      live_reg <= 1'b0;
    end else if (advance_tick && fabric_enable) begin
      multicast_reg <= source_vector ^ projection_vector ^ activation_vector ^ 8'hA5;
      live_reg <= |(source_vector | projection_vector | activation_vector);
    end
  end

  assign multicast_vector = multicast_reg;
  assign fabric_live = live_reg;
endmodule
