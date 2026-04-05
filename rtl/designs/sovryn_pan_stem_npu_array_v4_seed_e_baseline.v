`include "sovryn_pan_stem_npu_array_v4_seed_e_issue.v"
`include "sovryn_pan_stem_npu_array_v4_seed_e_state.v"
`include "sovryn_pan_stem_npu_array_v4_seed_e_tile.v"

module sovryn_pan_stem_npu_array_v4_seed_e_top(
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

  assign array_rows = ARRAY_ROWS[2:0];
  assign array_cols = ARRAY_COLS[2:0];

  sovryn_pan_stem_npu_array_v4_seed_e_tile #(
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
    })
  );

  assign read_valid = 1'b0;
  assign read_row = 2'd0;
  assign read_col = 2'd0;
  assign read_addr = 2'd0;
  assign read_data = 16'd0;
endmodule
