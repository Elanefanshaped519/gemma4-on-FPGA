module sovryn_pan_stem_pe_node_formal;
  (* anyseq *) reg clk;
  (* anyseq *) reg rst_n;
  (* anyseq *) reg prefetch_valid;
  (* anyseq *) reg prefetch_bank;
  (* anyseq *) reg prefetch_matrix_sel;
  (* anyseq *) reg [3:0] prefetch_addr;
  (* anyseq *) reg [7:0] prefetch_data;
  (* anyseq *) reg swap_banks;
  (* anyseq *) reg compute_valid;
  (* anyseq *) reg read_valid;
  (* anyseq *) reg [3:0] read_addr;

  wire out_valid;
  wire [23:0] read_data;
  wire active_bank;

  sovryn_pan_stem_pe_node dut (
    .clk(clk),
    .rst_n(rst_n),
    .prefetch_valid(prefetch_valid),
    .prefetch_bank(prefetch_bank),
    .prefetch_matrix_sel(prefetch_matrix_sel),
    .prefetch_addr(prefetch_addr),
    .prefetch_data(prefetch_data),
    .swap_banks(swap_banks),
    .compute_valid(compute_valid),
    .read_valid(read_valid),
    .read_addr(read_addr),
    .out_valid(out_valid),
    .read_data(read_data),
    .active_bank(active_bank)
  );

  reg f_past_valid;
  initial f_past_valid = 1'b0;

  always @(posedge clk) begin
    f_past_valid <= 1'b1;

    if (!f_past_valid) begin
      assume(!rst_n);
    end

    if (rst_n) begin
      assume(!prefetch_valid);
      assume(!compute_valid);
      assume(!read_valid);
    end

    if (!rst_n) begin
      assert(!out_valid);
      assert(!active_bank);
      assert(read_data == 24'd0);
    end

    if (f_past_valid && rst_n && $past(rst_n && swap_banks)) begin
      assert(active_bank == !$past(active_bank));
    end
  end
endmodule
