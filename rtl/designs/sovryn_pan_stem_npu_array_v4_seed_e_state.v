module sovryn_pan_stem_npu_array_v4_seed_e_state(
  input wire clk,
  input wire rst_n,
  input wire apply_valid,
  input wire [1:0] opcode,
  input wire [1:0] local_addr,
  input wire [15:0] local_data
);
  localparam [1:0] OP_WRITE = 2'd0;
  localparam [1:0] OP_OBSERVE = 2'd3;

  reg [15:0] state0;
  reg [15:0] state1;
  reg [15:0] state2;
  reg [15:0] state3;
  reg observe_seen_q;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      state0 <= 16'd0;
      state1 <= 16'd0;
      state2 <= 16'd0;
      state3 <= 16'd0;
      observe_seen_q <= 1'b0;
    end else if (apply_valid) begin
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
          observe_seen_q <= ~observe_seen_q;
        end
        default: begin
        end
      endcase
    end
  end
endmodule
