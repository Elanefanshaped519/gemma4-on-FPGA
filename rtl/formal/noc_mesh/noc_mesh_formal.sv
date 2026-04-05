module sovryn_pan_stem_noc_mesh_formal;
  (* anyseq *) reg clk;
  (* anyseq *) reg rst_n;
  (* anyseq *) reg in_valid;
  (* anyseq *) reg credit_ready;
  (* anyseq *) reg [1:0] current_x;
  (* anyseq *) reg [1:0] current_y;
  (* anyseq *) reg [1:0] dest_x;
  (* anyseq *) reg [1:0] dest_y;
  (* anyseq *) reg [31:0] data_in;

  wire out_valid;
  wire delivered;
  wire blocked;
  wire [2:0] next_port;
  wire [31:0] data_out;

  sovryn_pan_stem_noc_mesh dut (
    .clk(clk),
    .rst_n(rst_n),
    .in_valid(in_valid),
    .credit_ready(credit_ready),
    .current_x(current_x),
    .current_y(current_y),
    .dest_x(dest_x),
    .dest_y(dest_y),
    .data_in(data_in),
    .out_valid(out_valid),
    .delivered(delivered),
    .blocked(blocked),
    .next_port(next_port),
    .data_out(data_out)
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
      assert(!delivered);
      assert(!blocked);
      assert(next_port == 3'd0);
    end

    if (f_past_valid && rst_n && $past(rst_n && in_valid && !credit_ready)) begin
      assert(blocked);
      assert(!out_valid);
      assert(next_port == 3'd0);
    end

    if (f_past_valid && rst_n && $past(rst_n && in_valid && credit_ready && current_x == dest_x && current_y == dest_y)) begin
      assert(out_valid);
      assert(delivered);
      assert(next_port == 3'd0);
    end
  end
endmodule
