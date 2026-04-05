module sovryn_pan_stem_npu_array_neighbor_link #(
  parameter WIDTH = 24
)(
  input wire clk,
  input wire rst_n,
  input wire in_valid,
  input wire [WIDTH-1:0] in_payload,
  output reg out_valid,
  output reg [WIDTH-1:0] out_payload
);
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      out_valid <= 1'b0;
      out_payload <= {WIDTH{1'b0}};
    end else begin
      out_valid <= in_valid;
      out_payload <= in_payload;
    end
  end
endmodule
