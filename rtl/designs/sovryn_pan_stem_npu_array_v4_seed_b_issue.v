module sovryn_pan_stem_npu_array_v4_seed_b_issue #(
  parameter LOCAL_ROW = 0,
  parameter LOCAL_COL = 0,
  parameter CMD_PACKET_WIDTH = 24
)(
  input wire clk,
  input wire rst_n,
  input wire cmd_in_valid,
  input wire [CMD_PACKET_WIDTH-1:0] cmd_in_payload,
  output reg issue_valid,
  output reg [1:0] issue_opcode,
  output reg [1:0] issue_addr,
  output reg [15:0] issue_data
);
  localparam [1:0] ROW_ID = LOCAL_ROW[1:0];
  localparam [1:0] COL_ID = LOCAL_COL[1:0];

  wire [1:0] cmd_target_row = cmd_in_payload[21:20];
  wire [1:0] cmd_target_col = cmd_in_payload[19:18];
  wire cmd_matches = cmd_in_valid && (cmd_target_row == ROW_ID) && (cmd_target_col == COL_ID);

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      issue_valid <= 1'b0;
      issue_opcode <= 2'd0;
      issue_addr <= 2'd0;
      issue_data <= 16'd0;
    end else begin
      issue_valid <= cmd_matches;
      if (cmd_matches) begin
        issue_opcode <= cmd_in_payload[23:22];
        issue_addr <= cmd_in_payload[17:16];
        issue_data <= cmd_in_payload[15:0];
      end
    end
  end
endmodule
