module sovryn_llm_accel_reference(
  input wire clk,
  input wire rst_n,
  input wire [15:0] token_in,
  input wire token_valid,
  output reg [15:0] token_out,
  output reg token_ready
);
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      token_out <= 16'd0;
      token_ready <= 1'b0;
    end else begin
      token_out <= token_in;
      token_ready <= token_valid;
    end
  end
endmodule
