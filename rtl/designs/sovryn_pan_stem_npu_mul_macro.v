(* keep_hierarchy = "yes" *)
module sovryn_pan_stem_npu_mul_macro(
  input wire clk,
  input wire rst_n,
  input wire start_valid,
  input wire [3:0] start_addr,
  input wire [15:0] start_multiplicand,
  input wire [15:0] start_repeat_count,
  output reg busy,
  output reg done_valid,
  output reg [3:0] done_addr,
  output reg [31:0] done_result
);
  reg [1:0] phase;
  reg [3:0] latched_addr;
  reg [4:0] steps_remaining;
  reg [15:0] multiplier_bits;
  reg [15:0] accumulator_low;
  reg [15:0] accumulator_high;
  reg [15:0] shifted_multiplicand_low;
  reg [15:0] shifted_multiplicand_high;
  reg carry;

  wire [16:0] low_sum;
  wire [16:0] high_sum;

  function [4:0] effective_steps;
    input [15:0] value;
    integer bit_index;
    begin
      effective_steps = 5'd0;
      for (bit_index = 0; bit_index < 16; bit_index = bit_index + 1) begin
        if (value[bit_index]) begin
          effective_steps = bit_index[4:0] + 5'd1;
        end
      end
    end
  endfunction

  assign low_sum = {1'b0, accumulator_low} + {1'b0, shifted_multiplicand_low};
  assign high_sum = {1'b0, accumulator_high}
    + {1'b0, shifted_multiplicand_high}
    + {16'd0, carry};

  always @(posedge clk) begin
    done_valid <= 1'b0;
    if (!rst_n) begin
      busy <= 1'b0;
      phase <= 2'd0;
      latched_addr <= 4'd0;
      steps_remaining <= 5'd0;
      multiplier_bits <= 16'd0;
      accumulator_low <= 16'd0;
      accumulator_high <= 16'd0;
      shifted_multiplicand_low <= 16'd0;
      shifted_multiplicand_high <= 16'd0;
      carry <= 1'b0;
      done_addr <= 4'd0;
      done_result <= 32'd0;
    end else if (busy) begin
      if (steps_remaining == 5'd0 && phase == 2'd0) begin
        busy <= 1'b0;
        done_valid <= 1'b1;
        done_addr <= latched_addr;
        done_result <= {accumulator_high, accumulator_low};
      end else begin
        case (phase)
          2'd0: begin
            if (multiplier_bits[0]) begin
              accumulator_low <= low_sum[15:0];
              carry <= low_sum[16];
              phase <= 2'd1;
            end else begin
              carry <= 1'b0;
              phase <= 2'd2;
            end
          end
          2'd1: begin
            accumulator_high <= high_sum[15:0];
            phase <= 2'd2;
          end
          default: begin
            shifted_multiplicand_low <= {shifted_multiplicand_low[14:0], 1'b0};
            shifted_multiplicand_high <= {
              shifted_multiplicand_high[14:0],
              shifted_multiplicand_low[15]
            };
            multiplier_bits <= {1'b0, multiplier_bits[15:1]};
            if (steps_remaining != 5'd0) begin
              steps_remaining <= steps_remaining - 5'd1;
            end
            carry <= 1'b0;
            phase <= 2'd0;
          end
        endcase
      end
    end else if (start_valid) begin
      busy <= 1'b1;
      phase <= 2'd0;
      latched_addr <= start_addr;
      steps_remaining <= effective_steps(start_repeat_count);
      multiplier_bits <= start_repeat_count;
      accumulator_low <= 16'd0;
      accumulator_high <= 16'd0;
      shifted_multiplicand_low <= start_multiplicand;
      shifted_multiplicand_high <= 16'd0;
      carry <= 1'b0;
    end
  end
endmodule
