(* keep_hierarchy = "yes" *)
module sovryn_pan_stem_npu_observe_readback(
  input wire clk,
  input wire rst_n,
  input wire read_valid,
  input wire read_tile,
  input wire [31:0] tile0_read_data,
  input wire [31:0] tile1_read_data,
  output reg observe_valid,
  output reg [2:0] observe_route_port,
  output reg [31:0] observe_read_data
);
  always @(posedge clk) begin
    if (!rst_n) begin
      observe_valid <= 1'b0;
      observe_route_port <= 3'd0;
      observe_read_data <= 32'd0;
    end else begin
      observe_valid <= read_valid;
      if (read_valid) begin
        observe_route_port <= read_tile ? 3'd1 : 3'd0;
        observe_read_data <= read_tile ? tile1_read_data : tile0_read_data;
      end
    end
  end
endmodule
