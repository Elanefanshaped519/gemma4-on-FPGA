module sovryn_pan_stem_npu_array_v1_formal;
  (* gclk *) reg clk;
  (* anyseq *) reg rst_n;
  (* anyseq *) reg cmd_valid;
  (* anyseq *) reg [1:0] cmd_opcode;
  (* anyseq *) reg [1:0] cmd_row;
  (* anyseq *) reg [1:0] cmd_col;
  (* anyseq *) reg [1:0] cmd_addr;
  (* anyseq *) reg [15:0] cmd_data;

  wire read_valid;
  wire [1:0] read_row;
  wire [1:0] read_col;
  wire [1:0] read_addr;
  wire [15:0] read_data;
  wire [2:0] array_rows;
  wire [2:0] array_cols;
  wire single_tile_array = (array_rows == 3'd1) && (array_cols == 3'd1);
  reg f_past_valid;

  sovryn_pan_stem_npu_array_top dut (
    .clk(clk),
    .rst_n(rst_n),
    .cmd_valid(cmd_valid),
    .cmd_opcode(cmd_opcode),
    .cmd_row(cmd_row),
    .cmd_col(cmd_col),
    .cmd_addr(cmd_addr),
    .cmd_data(cmd_data),
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

    if (!rst_n) begin
      assert(!read_valid);
    end

    if (cmd_valid) begin
      assume(rst_n);
      assume(cmd_row < array_rows[1:0]);
      assume(cmd_col < array_cols[1:0]);
    end

    if (single_tile_array && cmd_valid) begin
      assume(cmd_row == 2'b00);
      assume(cmd_col == 2'b00);
    end

    assert(array_rows >= 1 && array_rows <= 4);
    assert(array_cols >= 1 && array_cols <= 4);

    if (f_past_valid && !$past(rst_n)) begin
      assert(!read_valid);
    end

    if (read_valid) begin
      assert(read_row < array_rows[1:0]);
      assert(read_col < array_cols[1:0]);
    end

    if (array_rows == 3'd1 && array_cols == 3'd1 && read_valid) begin
      assert(read_row == 2'b00);
      assert(read_col == 2'b00);
    end
  end
endmodule
