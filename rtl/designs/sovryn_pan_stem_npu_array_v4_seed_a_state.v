module sovryn_pan_stem_npu_array_v4_seed_a_state #(
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
  output reg [21:0] observe_payload
);
  localparam [1:0] OP_WRITE = 2'd0;
  localparam [1:0] OP_OBSERVE = 2'd3;

  reg [15:0] state0;
  reg [15:0] state1;
  reg [15:0] state2;
  reg [15:0] state3;
  reg observe_mailbox_valid_q;
  reg [1:0] observe_mailbox_addr_q;
  reg [15:0] observe_mailbox_q;
  reg [15:0] observe_snapshot_word;

  always @* begin
    case (local_addr)
      2'd0: observe_snapshot_word = state0;
      2'd1: observe_snapshot_word = state1;
      2'd2: observe_snapshot_word = state2;
      default: observe_snapshot_word = state3;
    endcase
  end

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      state0 <= 16'd0;
      state1 <= 16'd0;
      state2 <= 16'd0;
      state3 <= 16'd0;
      observe_mailbox_valid_q <= 1'b0;
      observe_mailbox_addr_q <= 2'd0;
      observe_mailbox_q <= 16'd0;
      observe_valid <= 1'b0;
      observe_payload <= 22'd0;
    end else begin
      observe_valid <= observe_mailbox_valid_q;
      observe_payload <= observe_mailbox_valid_q
        ? {
            LOCAL_ROW[1:0],
            LOCAL_COL[1:0],
            observe_mailbox_addr_q,
            observe_mailbox_q
          }
        : 22'd0;
      observe_mailbox_valid_q <= 1'b0;

      if (apply_valid) begin
        case (opcode)
          OP_WRITE: begin
            case (local_addr)
              2'd0: state0 <= local_data;
              2'd1: state1 <= local_data;
              2'd2: state2 <= local_data;
              default: state3 <= local_data;
            endcase
          end
          OP_OBSERVE: begin
            observe_mailbox_valid_q <= 1'b1;
            observe_mailbox_addr_q <= local_addr;
            observe_mailbox_q <= observe_snapshot_word;
          end
          default: begin
          end
        endcase
      end
    end
  end
endmodule
