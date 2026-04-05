`include "sovryn_pan_stem_npu_array_neighbor_link.v"
`include "sovryn_pan_stem_npu_array_observe_readback.v"
`include "sovryn_pan_stem_npu_array_v3_seed_a_issue.v"
`include "sovryn_pan_stem_npu_array_v3_seed_a_execute_alu.v"
`include "sovryn_pan_stem_npu_array_v3_seed_a_execute_mul.v"
`include "sovryn_pan_stem_npu_array_v3_seed_a_retire_writeback.v"
`include "sovryn_pan_stem_npu_array_v3_seed_a_observe_debug.v"
`include "sovryn_pan_stem_npu_array_v3_seed_a_tile.v"

module sovryn_pan_stem_npu_array_v3_seed_a_top(
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
  localparam integer MAX_ROWS = ARRAY_ROWS;
  localparam integer MAX_COLS = ARRAY_COLS;
  localparam integer CMD_PACKET_WIDTH = 24;
  localparam integer OBS_PACKET_WIDTH = 22;

  wire [CMD_PACKET_WIDTH-1:0] cmd_packet;
  assign cmd_packet = {
    cmd_opcode,
    cmd_row,
    cmd_col,
    cmd_addr,
    cmd_data
  };

  assign array_rows = ARRAY_ROWS[2:0];
  assign array_cols = ARRAY_COLS[2:0];

  wire [(MAX_ROWS*MAX_COLS)-1:0] tile_cmd_forward_valids;
  wire [((MAX_ROWS*MAX_COLS)*CMD_PACKET_WIDTH)-1:0] tile_cmd_forward_payloads;
  wire [(MAX_ROWS*MAX_COLS)-1:0] link_cmd_valids;
  wire [((MAX_ROWS*MAX_COLS)*CMD_PACKET_WIDTH)-1:0] link_cmd_payloads;
  wire [(MAX_ROWS*MAX_COLS)-1:0] tile_observe_valids;
  wire [((MAX_ROWS*MAX_COLS)*OBS_PACKET_WIDTH)-1:0] tile_observe_payloads;
  wire [(MAX_COLS)-1:0] north_observe_valids;
  wire [((MAX_COLS)*OBS_PACKET_WIDTH)-1:0] north_observe_payloads;

  genvar row_index;
  genvar col_index;
  generate
    for (row_index = 0; row_index < MAX_ROWS; row_index = row_index + 1) begin : row_gen
      for (col_index = 0; col_index < MAX_COLS; col_index = col_index + 1) begin : col_gen
        localparam integer TILE_INDEX = (row_index * MAX_COLS) + col_index;
        localparam integer SOUTH_INDEX = ((row_index + 1) * MAX_COLS) + col_index;

        wire tile_cmd_in_valid;
        wire [CMD_PACKET_WIDTH-1:0] tile_cmd_in_payload;
        wire tile_observe_in_valid;
        wire [OBS_PACKET_WIDTH-1:0] tile_observe_in_payload;
        wire cmd_col_in_range;

        assign cmd_col_in_range = (ARRAY_COLS >= 4) ? 1'b1 : (cmd_col < ARRAY_COLS[1:0]);

        if (col_index == 0) begin : first_col
          assign tile_cmd_in_valid = cmd_valid && (cmd_row == row_index[1:0]) && (row_index < ARRAY_ROWS) && cmd_col_in_range;
          assign tile_cmd_in_payload = cmd_packet;
        end else begin : chained_col
          assign tile_cmd_in_valid = link_cmd_valids[TILE_INDEX];
          assign tile_cmd_in_payload = link_cmd_payloads[(TILE_INDEX * CMD_PACKET_WIDTH) +: CMD_PACKET_WIDTH];
        end

        if (row_index == MAX_ROWS - 1) begin : bottom_row
          assign tile_observe_in_valid = 1'b0;
          assign tile_observe_in_payload = {OBS_PACKET_WIDTH{1'b0}};
        end else begin : chained_row
          assign tile_observe_in_valid = tile_observe_valids[SOUTH_INDEX];
          assign tile_observe_in_payload = tile_observe_payloads[(SOUTH_INDEX * OBS_PACKET_WIDTH) +: OBS_PACKET_WIDTH];
        end

        sovryn_pan_stem_npu_array_v3_seed_a_tile #(
          .LOCAL_ROW(row_index),
          .LOCAL_COL(col_index),
          .CMD_PACKET_WIDTH(CMD_PACKET_WIDTH),
          .OBS_PACKET_WIDTH(OBS_PACKET_WIDTH)
        ) tile_inst (
          .clk(clk),
          .rst_n(rst_n),
          .cmd_in_valid(tile_cmd_in_valid),
          .cmd_in_payload(tile_cmd_in_payload),
          .cmd_out_valid(tile_cmd_forward_valids[TILE_INDEX]),
          .cmd_out_payload(tile_cmd_forward_payloads[(TILE_INDEX * CMD_PACKET_WIDTH) +: CMD_PACKET_WIDTH]),
          .observe_in_valid(tile_observe_in_valid),
          .observe_in_payload(tile_observe_in_payload),
          .observe_out_valid(tile_observe_valids[TILE_INDEX]),
          .observe_out_payload(tile_observe_payloads[(TILE_INDEX * OBS_PACKET_WIDTH) +: OBS_PACKET_WIDTH])
        );

        if (col_index < (MAX_COLS - 1)) begin : east_link
          sovryn_pan_stem_npu_array_neighbor_link #(
            .WIDTH(CMD_PACKET_WIDTH)
          ) east_link_inst (
            .clk(clk),
            .rst_n(rst_n),
            .in_valid(tile_cmd_forward_valids[TILE_INDEX]),
            .in_payload(tile_cmd_forward_payloads[(TILE_INDEX * CMD_PACKET_WIDTH) +: CMD_PACKET_WIDTH]),
            .out_valid(link_cmd_valids[TILE_INDEX + 1]),
            .out_payload(link_cmd_payloads[((TILE_INDEX + 1) * CMD_PACKET_WIDTH) +: CMD_PACKET_WIDTH])
          );
        end

        if (row_index == 0) begin : north_tap
          assign north_observe_valids[col_index] = tile_observe_valids[TILE_INDEX];
          assign north_observe_payloads[(col_index * OBS_PACKET_WIDTH) +: OBS_PACKET_WIDTH] =
            tile_observe_payloads[(TILE_INDEX * OBS_PACKET_WIDTH) +: OBS_PACKET_WIDTH];
        end
      end
    end
  endgenerate

  sovryn_pan_stem_npu_array_observe_readback #(
    .MAX_COLS(MAX_COLS),
    .OBS_PACKET_WIDTH(OBS_PACKET_WIDTH)
  ) observe_readback_inst (
    .active_cols(ARRAY_COLS[2:0]),
    .north_valids(north_observe_valids),
    .north_payloads(north_observe_payloads),
    .read_valid(read_valid),
    .read_row(read_row),
    .read_col(read_col),
    .read_addr(read_addr),
    .read_data(read_data)
  );
endmodule
