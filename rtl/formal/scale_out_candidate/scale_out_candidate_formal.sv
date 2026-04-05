module sovryn_pan_stem_scale_out_candidate_formal;
  (* anyseq *) reg clk;
  (* anyseq *) reg rst_n;
  (* anyseq *) reg load_valid;
  (* anyseq *) reg load_matrix_sel;
  (* anyseq *) reg [7:0] load_addr;
  (* anyseq *) reg [7:0] load_data;
  (* anyseq *) reg compute_valid;
  (* anyseq *) reg read_valid;
  (* anyseq *) reg [7:0] read_addr;

  wire out_valid;
  wire [23:0] read_data;

  sovryn_pan_stem_systolic_array_16x16 dut (
    .clk(clk),
    .rst_n(rst_n),
    .load_valid(load_valid),
    .load_matrix_sel(load_matrix_sel),
    .load_addr(load_addr),
    .load_data(load_data),
    .compute_valid(compute_valid),
    .read_valid(read_valid),
    .read_addr(read_addr),
    .out_valid(out_valid),
    .read_data(read_data)
  );

  reg f_past_valid;
  initial f_past_valid = 1'b0;

  always @(posedge clk) begin
    f_past_valid <= 1'b1;

    if (!f_past_valid) begin
      assume(!rst_n);
    end

    if (rst_n) begin
      assume(!load_valid);
      assume(!(compute_valid && read_valid));
    end

    if (!rst_n) begin
      assert(!out_valid);
      assert(read_data == 24'd0);
    end

    if (rst_n && !dut.computed && read_valid) begin
      assert(!out_valid);
      assert(read_data == 24'd0);
    end

    if (f_past_valid && rst_n && $past(rst_n && compute_valid)) begin
      assert(dut.computed);
    end

    if (rst_n && dut.computed && read_valid) begin
      assert(out_valid);
    end
  end
endmodule
