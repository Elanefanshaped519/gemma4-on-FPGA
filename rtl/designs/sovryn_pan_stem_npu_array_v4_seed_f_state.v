module sovryn_pan_stem_npu_array_v4_seed_f_state(
  input wire clk,
  input wire rst_n,
  input wire pending_valid,
  input wire [1:0] pending_kind,
  input wire [1:0] pending_addr,
  input wire [15:0] pending_data,
  input wire pending_phase
);
  localparam [1:0] TOKEN_KIND_WRITE = 2'd0;

  reg [15:0] state0;
  reg [15:0] state1;
  reg [15:0] state2;
  reg [15:0] state3;
  reg commit_phase_q;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      state0 <= 16'd0;
      state1 <= 16'd0;
      state2 <= 16'd0;
      state3 <= 16'd0;
      commit_phase_q <= 1'b0;
    end else if (pending_valid) begin
      if (pending_kind == TOKEN_KIND_WRITE) begin
        case (pending_addr)
          2'd0: state0 <= pending_data;
          2'd1: state1 <= pending_data;
          2'd2: state2 <= pending_data;
          default: state3 <= pending_data;
        endcase
        commit_phase_q <= pending_phase;
      end
    end
  end
endmodule
