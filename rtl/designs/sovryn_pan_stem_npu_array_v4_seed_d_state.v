module sovryn_pan_stem_npu_array_v4_seed_d_state(
  input wire clk,
  input wire rst_n,
  input wire apply_valid,
  input wire [1:0] opcode,
  input wire [1:0] local_addr,
  input wire [15:0] local_data,
  output reg observe_valid,
  output reg observe_payload
);
  localparam [1:0] OP_WRITE = 2'd0;
  localparam [1:0] OP_OBSERVE = 2'd3;

  reg [15:0] state0;
  reg [15:0] state1;
  reg [15:0] state2;
  reg [15:0] state3;
  reg observe_event_phase_q;
  reg observe_sample_valid_q;
  reg observe_sample_bit_q;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      state0 <= 16'd0;
      state1 <= 16'd0;
      state2 <= 16'd0;
      state3 <= 16'd0;
      observe_event_phase_q <= 1'b0;
      observe_sample_valid_q <= 1'b0;
      observe_sample_bit_q <= 1'b0;
      observe_valid <= 1'b0;
      observe_payload <= 1'b0;
    end else begin
      observe_valid <= observe_sample_valid_q;
      observe_payload <= observe_sample_valid_q ? observe_sample_bit_q : 1'b0;
      observe_sample_valid_q <= 1'b0;

      if (apply_valid) begin
        case (opcode)
          OP_WRITE: begin
            case (local_addr)
              2'd0: state0 <= local_data;
              2'd1: state1 <= local_data;
              2'd2: state2 <= local_data;
              default: state3 <= local_data;
            endcase
            observe_event_phase_q <= ~observe_event_phase_q;
          end
          OP_OBSERVE: begin
            observe_sample_valid_q <= 1'b1;
            observe_sample_bit_q <= observe_event_phase_q;
          end
          default: begin
          end
        endcase
      end
    end
  end
endmodule
