module sovryn_pan_stem_pe_cell(
  input wire clk,
  input wire rst_n,
  input wire in_valid,
  input wire [7:0] lhs,
  input wire [7:0] rhs,
  input wire [15:0] acc_in,
  output reg out_valid,
  output reg [16:0] acc_out
);
  reg [7:0] lhs_pipe;
  reg [7:0] rhs_pipe;
  reg [15:0] acc_pipe;
  reg valid_pipe;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      lhs_pipe <= 8'd0;
      rhs_pipe <= 8'd0;
      acc_pipe <= 16'd0;
      valid_pipe <= 1'b0;
      out_valid <= 1'b0;
      acc_out <= 17'd0;
    end else begin
      lhs_pipe <= lhs;
      rhs_pipe <= rhs;
      acc_pipe <= acc_in;
      valid_pipe <= in_valid;
      out_valid <= valid_pipe;
      acc_out <= {1'b0, acc_pipe} + ({9'd0, lhs_pipe} * {9'd0, rhs_pipe});
    end
  end
endmodule
