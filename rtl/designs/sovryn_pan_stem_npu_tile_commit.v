(* keep_hierarchy = "yes" *)
module sovryn_pan_stem_npu_tile_commit(
  input wire clk,
  input wire rst_n,
  input wire commit_valid,
  input wire [3:0] commit_addr,
  input wire [31:0] commit_result,
  input wire [3:0] read_addr,
  output wire [31:0] read_data
);
  reg [31:0] result_mem [0:15];
  reg [15:0] result_valid;

  assign read_data = result_valid[read_addr] ? result_mem[read_addr] : 32'd0;

  always @(posedge clk) begin
    if (!rst_n) begin
      result_valid <= 16'd0;
    end else if (commit_valid) begin
      result_mem[commit_addr] <= commit_result;
      result_valid[commit_addr] <= 1'b1;
    end
  end
endmodule
