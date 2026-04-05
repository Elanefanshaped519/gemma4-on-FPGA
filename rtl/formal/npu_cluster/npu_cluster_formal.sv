module sovryn_pan_stem_npu_cluster_formal;
  (* anyseq *) reg clk;
  (* anyseq *) reg rst_n;
  (* anyseq *) reg dispatch_valid;
  (* anyseq *) reg [2:0] dispatch_opcode;
  (* anyseq *) reg dispatch_dest_node;
  (* anyseq *) reg [3:0] dispatch_addr;
  (* anyseq *) reg [15:0] dispatch_data;
  (* anyseq *) reg read_valid;
  (* anyseq *) reg read_node;
  (* anyseq *) reg [3:0] read_addr;

  wire out_valid;
  wire [2:0] route_port;
  wire [31:0] read_data;

  sovryn_pan_stem_npu_cluster dut (
    .clk(clk),
    .rst_n(rst_n),
    .dispatch_valid(dispatch_valid),
    .dispatch_opcode(dispatch_opcode),
    .dispatch_dest_node(dispatch_dest_node),
    .dispatch_addr(dispatch_addr),
    .dispatch_data(dispatch_data),
    .read_valid(read_valid),
    .read_node(read_node),
    .read_addr(read_addr),
    .out_valid(out_valid),
    .route_port(route_port),
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
      assume(!read_valid);
    end

    if (!rst_n) begin
      assert(!out_valid);
      assert(route_port == 3'd0);
      assert(read_data == 32'd0);
    end

    if (f_past_valid && rst_n && $past(rst_n && dispatch_valid)) begin
      assert(out_valid);
      assert(route_port == ($past(dispatch_dest_node) ? 3'd1 : 3'd0));
    end
  end
endmodule
