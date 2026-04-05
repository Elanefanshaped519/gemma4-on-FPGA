module sovryn_pan_stem_npu_array_v4_seed_f_issue(
  input wire clk,
  input wire rst_n,
  input wire cmd_token_valid,
  input wire [1:0] cmd_token_kind,
  input wire [1:0] cmd_token_addr,
  input wire [15:0] cmd_token_data,
  input wire cmd_token_phase,
  input wire consume_ready,
  output wire pending_valid,
  output wire [1:0] pending_kind,
  output wire [1:0] pending_addr,
  output wire [15:0] pending_data,
  output wire pending_phase
);
  reg pending_valid_q;
  reg [1:0] pending_kind_q;
  reg [1:0] pending_addr_q;
  reg [15:0] pending_data_q;
  reg pending_phase_q;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      pending_valid_q <= 1'b0;
      pending_kind_q <= 2'd0;
      pending_addr_q <= 2'd0;
      pending_data_q <= 16'd0;
      pending_phase_q <= 1'b0;
    end else begin
      if (consume_ready && pending_valid_q) begin
        pending_valid_q <= 1'b0;
      end

      if (cmd_token_valid && !pending_valid_q) begin
        pending_valid_q <= 1'b1;
        pending_kind_q <= cmd_token_kind;
        pending_addr_q <= cmd_token_addr;
        pending_data_q <= cmd_token_data;
        pending_phase_q <= cmd_token_phase;
      end
    end
  end

  assign pending_valid = pending_valid_q;
  assign pending_kind = pending_kind_q;
  assign pending_addr = pending_addr_q;
  assign pending_data = pending_data_q;
  assign pending_phase = pending_phase_q;
endmodule
