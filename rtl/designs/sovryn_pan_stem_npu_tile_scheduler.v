(* keep_hierarchy = "yes" *)
module sovryn_pan_stem_npu_tile_scheduler(
  input wire clk,
  input wire rst_n,
  input wire cmd_valid,
  input wire [2:0] cmd_opcode,
  input wire [3:0] cmd_addr,
  input wire [15:0] cmd_data,
  output reg issue_valid,
  output reg [2:0] issue_opcode,
  output reg [3:0] issue_addr,
  output reg [15:0] issue_data
);
  always @(posedge clk) begin
    if (!rst_n) begin
      issue_valid <= 1'b0;
      issue_opcode <= 3'd0;
      issue_addr <= 4'd0;
      issue_data <= 16'd0;
    end else begin
      issue_valid <= cmd_valid;
      if (cmd_valid) begin
        issue_opcode <= cmd_opcode;
        issue_addr <= cmd_addr;
        issue_data <= cmd_data;
      end
    end
  end
endmodule
