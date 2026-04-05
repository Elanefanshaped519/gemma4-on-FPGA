module sovryn_pan_stem_npu_array_v4_seed_f_formal;
  (* gclk *) reg clk;
  (* anyseq *) reg rst_n;
  (* anyseq *) reg cmd_token_valid;
  (* anyseq *) reg [1:0] cmd_token_kind;
  (* anyseq *) reg [1:0] cmd_token_addr;
  (* anyseq *) reg [15:0] cmd_token_data;
  (* anyseq *) reg cmd_token_phase;

  wire read_valid;
  wire [1:0] read_row;
  wire [1:0] read_col;
  wire [1:0] read_addr;
  wire [15:0] read_data;
  wire [2:0] array_rows;
  wire [2:0] array_cols;
  reg f_past_valid;

  sovryn_pan_stem_npu_array_v4_seed_f_top dut (
    .clk(clk),
    .rst_n(rst_n),
    .cmd_token_valid(cmd_token_valid),
    .cmd_token_kind(cmd_token_kind),
    .cmd_token_addr(cmd_token_addr),
    .cmd_token_data(cmd_token_data),
    .cmd_token_phase(cmd_token_phase),
    .read_valid(read_valid),
    .read_row(read_row),
    .read_col(read_col),
    .read_addr(read_addr),
    .read_data(read_data),
    .array_rows(array_rows),
    .array_cols(array_cols)
  );

  initial begin
    f_past_valid = 1'b0;
  end

  always @(posedge clk) begin
    f_past_valid <= 1'b1;

    if (!f_past_valid) begin
      assume(!rst_n);
    end

    if (cmd_token_valid) begin
      assume(rst_n);
      assume(cmd_token_kind <= 2'd1);
    end

    assert(array_rows == 3'd1);
    assert(array_cols == 3'd1);
    assert(!read_valid);
    assert(read_row == 2'd0);
    assert(read_col == 2'd0);
    assert(read_addr == 2'd0);
    assert(read_data == 16'd0);
  end
endmodule
