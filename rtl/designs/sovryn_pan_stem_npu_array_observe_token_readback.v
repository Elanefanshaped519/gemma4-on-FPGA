module sovryn_pan_stem_npu_array_observe_token_readback #(
  parameter MAX_COLS = 4,
  parameter TOKEN_PACKET_WIDTH = 8
)(
  input wire [2:0] active_cols,
  input wire [MAX_COLS-1:0] north_valids,
  input wire [(MAX_COLS*TOKEN_PACKET_WIDTH)-1:0] north_payloads,
  output reg read_valid,
  output reg [1:0] read_row,
  output reg [1:0] read_col,
  output reg [1:0] read_addr,
  output reg [15:0] read_data
);
  integer col_index;
  reg found_read;
  reg [TOKEN_PACKET_WIDTH-1:0] selected_payload;

  always @* begin
    found_read = 1'b0;
    selected_payload = {TOKEN_PACKET_WIDTH{1'b0}};
    for (col_index = 0; col_index < MAX_COLS; col_index = col_index + 1) begin
      if (!found_read && north_valids[col_index] && (col_index < active_cols)) begin
        found_read = 1'b1;
        selected_payload = north_payloads[(col_index * TOKEN_PACKET_WIDTH) +: TOKEN_PACKET_WIDTH];
      end
    end

    read_valid = found_read;
    read_row = selected_payload[7:6];
    read_col = selected_payload[5:4];
    read_addr = selected_payload[3:2];
    read_data = {14'd0, selected_payload[1:0]};
  end
endmodule
