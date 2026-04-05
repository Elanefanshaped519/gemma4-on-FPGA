module sovryn_pan_stem_pe_cell_formal;
  (* anyseq *) reg clk;
  (* anyseq *) reg rst_n;
  (* anyseq *) reg in_valid;
  (* anyseq *) reg [7:0] lhs;
  (* anyseq *) reg [7:0] rhs;
  (* anyseq *) reg [15:0] acc_in;

  wire out_valid;
  wire [16:0] acc_out;

  sovryn_pan_stem_pe_cell dut (
    .clk(clk),
    .rst_n(rst_n),
    .in_valid(in_valid),
    .lhs(lhs),
    .rhs(rhs),
    .acc_in(acc_in),
    .out_valid(out_valid),
    .acc_out(acc_out)
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
      assert(acc_out == 17'd0);
    end

    if (f_past_valid && rst_n && $past(rst_n && in_valid)) begin
      assert(out_valid);
      assert(acc_out == ({1'b0, $past(acc_in)} + ({9'd0, $past(lhs)} * {9'd0, $past(rhs)})));
    end

    if (f_past_valid && rst_n && $past(rst_n && !in_valid)) begin
      assert(!out_valid);
    end
  end
endmodule
