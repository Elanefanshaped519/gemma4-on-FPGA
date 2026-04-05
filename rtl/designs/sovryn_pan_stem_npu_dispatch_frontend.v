(* keep_hierarchy = "yes" *)
module sovryn_pan_stem_npu_dispatch_frontend(
  input wire clk,
  input wire rst_n,
  input wire dispatch_valid,
  input wire [2:0] dispatch_opcode,
  input wire dispatch_dest_tile,
  input wire [3:0] dispatch_addr,
  input wire [15:0] dispatch_data,
  output reg tile0_cmd_valid,
  output reg tile1_cmd_valid,
  output reg [2:0] tile0_cmd_opcode,
  output reg [2:0] tile1_cmd_opcode,
  output reg [3:0] tile0_cmd_addr,
  output reg [3:0] tile1_cmd_addr,
  output reg [15:0] tile0_cmd_data,
  output reg [15:0] tile1_cmd_data
);
  always @(posedge clk) begin
    if (!rst_n) begin
      tile0_cmd_valid <= 1'b0;
      tile1_cmd_valid <= 1'b0;
      tile0_cmd_opcode <= 3'd0;
      tile1_cmd_opcode <= 3'd0;
      tile0_cmd_addr <= 4'd0;
      tile1_cmd_addr <= 4'd0;
      tile0_cmd_data <= 16'd0;
      tile1_cmd_data <= 16'd0;
    end else begin
      tile0_cmd_valid <= dispatch_valid && !dispatch_dest_tile;
      tile1_cmd_valid <= dispatch_valid && dispatch_dest_tile;

      if (dispatch_valid && !dispatch_dest_tile) begin
        tile0_cmd_opcode <= dispatch_opcode;
        tile0_cmd_addr <= dispatch_addr;
        tile0_cmd_data <= dispatch_data;
      end

      if (dispatch_valid && dispatch_dest_tile) begin
        tile1_cmd_opcode <= dispatch_opcode;
        tile1_cmd_addr <= dispatch_addr;
        tile1_cmd_data <= dispatch_data;
      end
    end
  end
endmodule
