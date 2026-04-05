module sovryn_pan_stem_mini_systolic_tile_formal;
  (* anyseq *) reg clk;
  (* anyseq *) reg rst_n;
  (* anyseq *) reg in_valid;
  (* anyseq *) reg [7:0] a00;
  (* anyseq *) reg [7:0] a01;
  (* anyseq *) reg [7:0] a10;
  (* anyseq *) reg [7:0] a11;
  (* anyseq *) reg [7:0] b00;
  (* anyseq *) reg [7:0] b01;
  (* anyseq *) reg [7:0] b10;
  (* anyseq *) reg [7:0] b11;

  wire out_valid;
  wire [16:0] c00;
  wire [16:0] c01;
  wire [16:0] c10;
  wire [16:0] c11;

  sovryn_pan_stem_mini_systolic_tile dut (
    .clk(clk),
    .rst_n(rst_n),
    .in_valid(in_valid),
    .a00(a00),
    .a01(a01),
    .a10(a10),
    .a11(a11),
    .b00(b00),
    .b01(b01),
    .b10(b10),
    .b11(b11),
    .out_valid(out_valid),
    .c00(c00),
    .c01(c01),
    .c10(c10),
    .c11(c11)
  );

  reg f_past_valid;
  initial f_past_valid = 1'b0;

  always @(posedge clk) begin
    f_past_valid <= 1'b1;

    if (!f_past_valid) begin
      assume(!rst_n);
    end

    if (!rst_n) begin
      assert(!out_valid);
      assert(c00 == 17'd0);
      assert(c01 == 17'd0);
      assert(c10 == 17'd0);
      assert(c11 == 17'd0);
    end

    if (f_past_valid && rst_n && $past(rst_n && in_valid)) begin
      assert(out_valid);
      assert(c00 == (({9'd0, $past(a00)} * {9'd0, $past(b00)}) + ({9'd0, $past(a01)} * {9'd0, $past(b10)})));
      assert(c01 == (({9'd0, $past(a00)} * {9'd0, $past(b01)}) + ({9'd0, $past(a01)} * {9'd0, $past(b11)})));
      assert(c10 == (({9'd0, $past(a10)} * {9'd0, $past(b00)}) + ({9'd0, $past(a11)} * {9'd0, $past(b10)})));
      assert(c11 == (({9'd0, $past(a10)} * {9'd0, $past(b01)}) + ({9'd0, $past(a11)} * {9'd0, $past(b11)})));
    end

    if (f_past_valid && rst_n && $past(rst_n && !in_valid)) begin
      assert(!out_valid);
    end
  end
endmodule
