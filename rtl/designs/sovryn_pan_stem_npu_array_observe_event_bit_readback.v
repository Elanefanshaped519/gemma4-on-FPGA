module sovryn_pan_stem_npu_array_observe_event_bit_readback #(
  parameter integer MAX_COLS = 1
)(
  input wire [2:0] active_cols,
  input wire [MAX_COLS-1:0] north_valids,
  input wire [MAX_COLS-1:0] north_payloads,
  output wire read_valid,
  output wire [1:0] read_row,
  output wire [1:0] read_col,
  output wire [1:0] read_addr,
  output wire [15:0] read_data
);
  integer idx;
  reg selected_valid;
  reg [1:0] selected_col;
  reg selected_bit;

  always @(*) begin
    selected_valid = 1'b0;
    selected_col = 2'd0;
    selected_bit = 1'b0;
    for (idx = 0; idx < MAX_COLS; idx = idx + 1) begin
      if (!selected_valid && idx < active_cols && north_valids[idx]) begin
        selected_valid = 1'b1;
        selected_col = idx[1:0];
        selected_bit = north_payloads[idx];
      end
    end
  end

  assign read_valid = selected_valid;
  assign read_row = 2'd0;
  assign read_col = selected_col;
  assign read_addr = 2'd0;
  assign read_data = selected_valid ? {15'd0, selected_bit} : 16'd0;
endmodule
