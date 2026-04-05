module sovryn_pan_stem_mini_systolic_tile(
  input wire clk,
  input wire rst_n,
  input wire in_valid,
  input wire [7:0] a00,
  input wire [7:0] a01,
  input wire [7:0] a10,
  input wire [7:0] a11,
  input wire [7:0] b00,
  input wire [7:0] b01,
  input wire [7:0] b10,
  input wire [7:0] b11,
  output reg out_valid,
  output reg [16:0] c00,
  output reg [16:0] c01,
  output reg [16:0] c10,
  output reg [16:0] c11
);
  reg [7:0] a00_pipe;
  reg [7:0] a01_pipe;
  reg [7:0] a10_pipe;
  reg [7:0] a11_pipe;
  reg [7:0] b00_pipe;
  reg [7:0] b01_pipe;
  reg [7:0] b10_pipe;
  reg [7:0] b11_pipe;
  reg valid_pipe;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      a00_pipe <= 8'd0;
      a01_pipe <= 8'd0;
      a10_pipe <= 8'd0;
      a11_pipe <= 8'd0;
      b00_pipe <= 8'd0;
      b01_pipe <= 8'd0;
      b10_pipe <= 8'd0;
      b11_pipe <= 8'd0;
      valid_pipe <= 1'b0;
      out_valid <= 1'b0;
      c00 <= 17'd0;
      c01 <= 17'd0;
      c10 <= 17'd0;
      c11 <= 17'd0;
    end else begin
      a00_pipe <= a00;
      a01_pipe <= a01;
      a10_pipe <= a10;
      a11_pipe <= a11;
      b00_pipe <= b00;
      b01_pipe <= b01;
      b10_pipe <= b10;
      b11_pipe <= b11;
      valid_pipe <= in_valid;
      out_valid <= valid_pipe;
      c00 <= ({9'd0, a00_pipe} * {9'd0, b00_pipe}) + ({9'd0, a01_pipe} * {9'd0, b10_pipe});
      c01 <= ({9'd0, a00_pipe} * {9'd0, b01_pipe}) + ({9'd0, a01_pipe} * {9'd0, b11_pipe});
      c10 <= ({9'd0, a10_pipe} * {9'd0, b00_pipe}) + ({9'd0, a11_pipe} * {9'd0, b10_pipe});
      c11 <= ({9'd0, a10_pipe} * {9'd0, b01_pipe}) + ({9'd0, a11_pipe} * {9'd0, b11_pipe});
    end
  end
endmodule
