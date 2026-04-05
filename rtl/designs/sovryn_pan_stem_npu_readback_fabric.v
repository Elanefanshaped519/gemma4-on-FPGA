(* keep_hierarchy = "yes" *)
module sovryn_pan_stem_npu_readback_fabric(
  input wire clk,
  input wire rst_n,
  input wire read_valid,
  input wire read_tile,
  input wire [31:0] tile0_read_data,
  input wire [31:0] tile1_read_data,
  output reg fabric_valid,
  output reg [2:0] fabric_route_port,
  output reg [31:0] fabric_read_data
);
  always @(posedge clk) begin
    if (!rst_n) begin
      fabric_valid <= 1'b0;
      fabric_route_port <= 3'd0;
      fabric_read_data <= 32'd0;
    end else begin
      fabric_valid <= read_valid;
      if (read_valid) begin
        fabric_route_port <= read_tile ? 3'd1 : 3'd0;
        fabric_read_data <= read_tile ? tile1_read_data : tile0_read_data;
      end
    end
  end
endmodule
