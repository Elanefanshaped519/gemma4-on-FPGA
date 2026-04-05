module sovryn_pan_stem_systolic_array_4x4_formal;
  (* anyseq *) reg clk;
  (* anyseq *) reg rst_n;
  (* anyseq *) reg in_valid;
  (* anyseq *) reg [7:0] a00; (* anyseq *) reg [7:0] a01; (* anyseq *) reg [7:0] a02; (* anyseq *) reg [7:0] a03;
  (* anyseq *) reg [7:0] a10; (* anyseq *) reg [7:0] a11; (* anyseq *) reg [7:0] a12; (* anyseq *) reg [7:0] a13;
  (* anyseq *) reg [7:0] a20; (* anyseq *) reg [7:0] a21; (* anyseq *) reg [7:0] a22; (* anyseq *) reg [7:0] a23;
  (* anyseq *) reg [7:0] a30; (* anyseq *) reg [7:0] a31; (* anyseq *) reg [7:0] a32; (* anyseq *) reg [7:0] a33;
  (* anyseq *) reg [7:0] b00; (* anyseq *) reg [7:0] b01; (* anyseq *) reg [7:0] b02; (* anyseq *) reg [7:0] b03;
  (* anyseq *) reg [7:0] b10; (* anyseq *) reg [7:0] b11; (* anyseq *) reg [7:0] b12; (* anyseq *) reg [7:0] b13;
  (* anyseq *) reg [7:0] b20; (* anyseq *) reg [7:0] b21; (* anyseq *) reg [7:0] b22; (* anyseq *) reg [7:0] b23;
  (* anyseq *) reg [7:0] b30; (* anyseq *) reg [7:0] b31; (* anyseq *) reg [7:0] b32; (* anyseq *) reg [7:0] b33;

  wire out_valid;
  wire [17:0] c00; wire [17:0] c01; wire [17:0] c02; wire [17:0] c03;
  wire [17:0] c10; wire [17:0] c11; wire [17:0] c12; wire [17:0] c13;
  wire [17:0] c20; wire [17:0] c21; wire [17:0] c22; wire [17:0] c23;
  wire [17:0] c30; wire [17:0] c31; wire [17:0] c32; wire [17:0] c33;

  sovryn_pan_stem_systolic_array_4x4 dut (
    .clk(clk), .rst_n(rst_n), .in_valid(in_valid),
    .a00(a00), .a01(a01), .a02(a02), .a03(a03),
    .a10(a10), .a11(a11), .a12(a12), .a13(a13),
    .a20(a20), .a21(a21), .a22(a22), .a23(a23),
    .a30(a30), .a31(a31), .a32(a32), .a33(a33),
    .b00(b00), .b01(b01), .b02(b02), .b03(b03),
    .b10(b10), .b11(b11), .b12(b12), .b13(b13),
    .b20(b20), .b21(b21), .b22(b22), .b23(b23),
    .b30(b30), .b31(b31), .b32(b32), .b33(b33),
    .out_valid(out_valid),
    .c00(c00), .c01(c01), .c02(c02), .c03(c03),
    .c10(c10), .c11(c11), .c12(c12), .c13(c13),
    .c20(c20), .c21(c21), .c22(c22), .c23(c23),
    .c30(c30), .c31(c31), .c32(c32), .c33(c33)
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
      assert(c00 == 18'd0); assert(c01 == 18'd0); assert(c02 == 18'd0); assert(c03 == 18'd0);
      assert(c10 == 18'd0); assert(c11 == 18'd0); assert(c12 == 18'd0); assert(c13 == 18'd0);
      assert(c20 == 18'd0); assert(c21 == 18'd0); assert(c22 == 18'd0); assert(c23 == 18'd0);
      assert(c30 == 18'd0); assert(c31 == 18'd0); assert(c32 == 18'd0); assert(c33 == 18'd0);
    end

    if (f_past_valid && rst_n && $past(rst_n && in_valid)) begin
      assert(out_valid);
      assert(c00 == (({10'd0, $past(a00)} * {10'd0, $past(b00)}) + ({10'd0, $past(a01)} * {10'd0, $past(b10)}) + ({10'd0, $past(a02)} * {10'd0, $past(b20)}) + ({10'd0, $past(a03)} * {10'd0, $past(b30)})));
      assert(c01 == (({10'd0, $past(a00)} * {10'd0, $past(b01)}) + ({10'd0, $past(a01)} * {10'd0, $past(b11)}) + ({10'd0, $past(a02)} * {10'd0, $past(b21)}) + ({10'd0, $past(a03)} * {10'd0, $past(b31)})));
      assert(c10 == (({10'd0, $past(a10)} * {10'd0, $past(b00)}) + ({10'd0, $past(a11)} * {10'd0, $past(b10)}) + ({10'd0, $past(a12)} * {10'd0, $past(b20)}) + ({10'd0, $past(a13)} * {10'd0, $past(b30)})));
      assert(c11 == (({10'd0, $past(a10)} * {10'd0, $past(b01)}) + ({10'd0, $past(a11)} * {10'd0, $past(b11)}) + ({10'd0, $past(a12)} * {10'd0, $past(b21)}) + ({10'd0, $past(a13)} * {10'd0, $past(b31)})));
      assert(c22 == (({10'd0, $past(a20)} * {10'd0, $past(b02)}) + ({10'd0, $past(a21)} * {10'd0, $past(b12)}) + ({10'd0, $past(a22)} * {10'd0, $past(b22)}) + ({10'd0, $past(a23)} * {10'd0, $past(b32)})));
      assert(c33 == (({10'd0, $past(a30)} * {10'd0, $past(b03)}) + ({10'd0, $past(a31)} * {10'd0, $past(b13)}) + ({10'd0, $past(a32)} * {10'd0, $past(b23)}) + ({10'd0, $past(a33)} * {10'd0, $past(b33)})));
    end

    if (f_past_valid && rst_n && $past(rst_n && !in_valid)) begin
      assert(!out_valid);
    end
  end
endmodule
