module sovryn_pan_stem_mac_unit(
  input wire clk,
  input wire rst_n,
  input wire in_valid,
  input wire [7:0] lhs,
  input wire [7:0] rhs,
  output reg out_valid,
  output reg [15:0] product
);
  reg [7:0] lhs_pipe;
  reg [7:0] rhs_pipe;
  reg valid_pipe;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      lhs_pipe <= 8'd0;
      rhs_pipe <= 8'd0;
      valid_pipe <= 1'b0;
      out_valid <= 1'b0;
      product <= 16'd0;
    end else begin
      lhs_pipe <= lhs;
      rhs_pipe <= rhs;
      valid_pipe <= in_valid;
      out_valid <= valid_pipe;
      product <= lhs_pipe * rhs_pipe;
    end
  end
endmodule
