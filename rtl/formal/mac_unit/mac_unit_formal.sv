module sovryn_pan_stem_mac_unit_formal;
  (* anyseq *) reg clk;
  (* anyseq *) reg rst_n;
  (* anyseq *) reg in_valid;
  (* anyseq *) reg [7:0] lhs;
  (* anyseq *) reg [7:0] rhs;

  wire out_valid;
  wire [15:0] product;

  sovryn_pan_stem_mac_unit dut (
    .clk(clk),
    .rst_n(rst_n),
    .in_valid(in_valid),
    .lhs(lhs),
    .rhs(rhs),
    .out_valid(out_valid),
    .product(product)
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
      assert(product == 16'd0);
    end

    if (f_past_valid && rst_n && $past(rst_n && in_valid)) begin
      assert(out_valid);
      assert(product == ($past(lhs) * $past(rhs)));
    end

    if (f_past_valid && rst_n && $past(rst_n && !in_valid)) begin
      assert(!out_valid);
    end
  end
endmodule
