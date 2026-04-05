(* keep_hierarchy = "yes" *)
module sovryn_pan_stem_npu_dispatch_ingress(
  input wire clk,
  input wire rst_n,
  input wire dispatch_valid,
  input wire [2:0] dispatch_opcode,
  input wire dispatch_dest_tile,
  input wire [3:0] dispatch_addr,
  input wire [15:0] dispatch_data,
  output reg tile0_request_valid,
  output reg tile1_request_valid,
  output reg [2:0] tile0_request_opcode,
  output reg [2:0] tile1_request_opcode,
  output reg [3:0] tile0_request_addr,
  output reg [3:0] tile1_request_addr,
  output reg [15:0] tile0_request_data,
  output reg [15:0] tile1_request_data
);
  always @(posedge clk) begin
    if (!rst_n) begin
      tile0_request_valid <= 1'b0;
      tile1_request_valid <= 1'b0;
      tile0_request_opcode <= 3'd0;
      tile1_request_opcode <= 3'd0;
      tile0_request_addr <= 4'd0;
      tile1_request_addr <= 4'd0;
      tile0_request_data <= 16'd0;
      tile1_request_data <= 16'd0;
    end else begin
      tile0_request_valid <= dispatch_valid && !dispatch_dest_tile;
      tile1_request_valid <= dispatch_valid && dispatch_dest_tile;

      if (dispatch_valid && !dispatch_dest_tile) begin
        tile0_request_opcode <= dispatch_opcode;
        tile0_request_addr <= dispatch_addr;
        tile0_request_data <= dispatch_data;
      end

      if (dispatch_valid && dispatch_dest_tile) begin
        tile1_request_opcode <= dispatch_opcode;
        tile1_request_addr <= dispatch_addr;
        tile1_request_data <= dispatch_data;
      end
    end
  end
endmodule
