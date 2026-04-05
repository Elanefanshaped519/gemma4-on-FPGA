`include "sovryn_pan_stem_npu_array_observe_token_readback.v"
`include "sovryn_pan_stem_npu_array_v4_seed_c_issue.v"
`include "sovryn_pan_stem_npu_array_v4_seed_c_state.v"
`include "sovryn_pan_stem_npu_array_v4_seed_c_tile.v"

module sovryn_pan_stem_npu_array_v4_seed_c_top(
  input wire clk,
  input wire rst_n,
  input wire cmd_valid,
  input wire [1:0] cmd_opcode,
  input wire [1:0] cmd_row,
  input wire [1:0] cmd_col,
  input wire [1:0] cmd_addr,
  input wire [15:0] cmd_data,
  output wire read_valid,
  output wire [1:0] read_row,
  output wire [1:0] read_col,
  output wire [1:0] read_addr,
  output wire [15:0] read_data,
  output wire [2:0] array_rows,
  output wire [2:0] array_cols
);
  localparam integer ARRAY_ROWS = 1;
  localparam integer ARRAY_COLS = 1;
  localparam integer TOKEN_PACKET_WIDTH = 8;

  wire tile_observe_valid;
  wire [TOKEN_PACKET_WIDTH-1:0] tile_observe_payload;

  assign array_rows = ARRAY_ROWS[2:0];
  assign array_cols = ARRAY_COLS[2:0];

  sovryn_pan_stem_npu_array_v4_seed_c_tile #(
    .LOCAL_ROW(0),
    .LOCAL_COL(0)
  ) tile_inst (
    .clk(clk),
    .rst_n(rst_n),
    .cmd_in_valid(cmd_valid && (cmd_row == 2'd0) && (cmd_col == 2'd0)),
    .cmd_in_payload({
      cmd_opcode,
      cmd_row,
      cmd_col,
      cmd_addr,
      cmd_data
    }),
    .observe_out_valid(tile_observe_valid),
    .observe_out_payload(tile_observe_payload)
  );

  sovryn_pan_stem_npu_array_observe_token_readback #(
    .MAX_COLS(1),
    .TOKEN_PACKET_WIDTH(TOKEN_PACKET_WIDTH)
  ) observe_token_readback_inst (
    .active_cols(array_cols),
    .north_valids(tile_observe_valid),
    .north_payloads(tile_observe_payload),
    .read_valid(read_valid),
    .read_row(read_row),
    .read_col(read_col),
    .read_addr(read_addr),
    .read_data(read_data)
  );
endmodule
