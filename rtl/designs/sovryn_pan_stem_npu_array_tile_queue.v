module sovryn_pan_stem_npu_array_tile_queue #(
  parameter WIDTH = 24
)(
  input wire clk,
  input wire rst_n,
  input wire enqueue_valid,
  input wire [WIDTH-1:0] enqueue_payload,
  input wire consume,
  output reg queued_valid,
  output reg [WIDTH-1:0] queued_payload
);
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      queued_valid <= 1'b0;
      queued_payload <= {WIDTH{1'b0}};
    end else begin
      if (consume) begin
        queued_valid <= 1'b0;
      end
      if (enqueue_valid) begin
        queued_valid <= 1'b1;
        queued_payload <= enqueue_payload;
      end
    end
  end
endmodule
