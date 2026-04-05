module sovryn_pan_stem_npu_array_v4_seed_c_state #(
  parameter LOCAL_ROW = 0,
  parameter LOCAL_COL = 0
)(
  input wire clk,
  input wire rst_n,
  input wire apply_valid,
  input wire [1:0] opcode,
  input wire [1:0] local_addr,
  input wire [15:0] local_data,
  output reg observe_valid,
  output reg [7:0] observe_payload
);
  localparam [1:0] OP_WRITE = 2'd0;
  localparam [1:0] OP_OBSERVE = 2'd3;
  localparam [1:0] TOKEN_KIND_COMMIT = 2'd1;

  reg [15:0] state0;
  reg [15:0] state1;
  reg [15:0] state2;
  reg [15:0] state3;
  reg last_commit_valid_q;
  reg [1:0] last_commit_token_kind_q;
  reg [1:0] last_commit_token_seq_q;
  reg observe_token_valid_q;
  reg [1:0] observe_token_kind_q;
  reg [1:0] observe_token_seq_q;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      state0 <= 16'd0;
      state1 <= 16'd0;
      state2 <= 16'd0;
      state3 <= 16'd0;
      last_commit_valid_q <= 1'b0;
      last_commit_token_kind_q <= 2'd0;
      last_commit_token_seq_q <= 2'd0;
      observe_token_valid_q <= 1'b0;
      observe_token_kind_q <= 2'd0;
      observe_token_seq_q <= 2'd0;
      observe_valid <= 1'b0;
      observe_payload <= 8'd0;
    end else begin
      observe_valid <= observe_token_valid_q;
      observe_payload <= observe_token_valid_q
        ? {
            LOCAL_ROW[1:0],
            LOCAL_COL[1:0],
            observe_token_seq_q,
            observe_token_kind_q
          }
        : 8'd0;
      observe_token_valid_q <= 1'b0;

      if (apply_valid) begin
        case (opcode)
          OP_WRITE: begin
            case (local_addr)
              2'd0: state0 <= local_data;
              2'd1: state1 <= local_data;
              2'd2: state2 <= local_data;
              default: state3 <= local_data;
            endcase
            last_commit_valid_q <= 1'b1;
            last_commit_token_kind_q <= TOKEN_KIND_COMMIT;
            last_commit_token_seq_q <= last_commit_token_seq_q + 2'd1;
          end
          OP_OBSERVE: begin
            if (last_commit_valid_q) begin
              observe_token_valid_q <= 1'b1;
              observe_token_kind_q <= last_commit_token_kind_q;
              observe_token_seq_q <= last_commit_token_seq_q;
            end
          end
          default: begin
          end
        endcase
      end
    end
  end
endmodule
