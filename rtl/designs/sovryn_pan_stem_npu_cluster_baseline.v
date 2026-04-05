(* keep_hierarchy = "yes" *)
module sovryn_pan_stem_serial_multiplier(
  input wire clk,
  input wire rst_n,
  input wire start_valid,
  input wire start_node,
  input wire [3:0] start_addr,
  input wire [15:0] start_multiplicand,
  input wire [15:0] start_repeat_count,
  output reg busy,
  output reg done_valid,
  output reg done_node,
  output reg [3:0] done_addr,
  output reg [31:0] done_result
);
  reg [1:0] phase;
  reg latched_node;
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
          effective_steps = bit_index + 5'd1;
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
      latched_node <= 1'b0;
      latched_addr <= 4'd0;
      steps_remaining <= 5'd0;
      multiplier_bits <= 16'd0;
      accumulator_low <= 16'd0;
      accumulator_high <= 16'd0;
      shifted_multiplicand_low <= 16'd0;
      shifted_multiplicand_high <= 16'd0;
      carry <= 1'b0;
      done_node <= 1'b0;
      done_addr <= 4'd0;
      done_result <= 32'd0;
    end else if (busy) begin
      if (steps_remaining == 5'd0 && phase == 2'd0) begin
        busy <= 1'b0;
        phase <= 2'd0;
        done_valid <= 1'b1;
        done_node <= latched_node;
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
      latched_node <= start_node;
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

module sovryn_pan_stem_npu_cluster(
  input wire clk,
  input wire rst_n,
  input wire dispatch_valid,
  input wire [2:0] dispatch_opcode,
  input wire dispatch_dest_node,
  input wire [3:0] dispatch_addr,
  input wire [15:0] dispatch_data,
  input wire read_valid,
  input wire read_node,
  input wire [3:0] read_addr,
  output reg out_valid,
  output reg [2:0] route_port,
  output reg [31:0] read_data
);
`ifdef SOVRYN_FORMAL_ABSTRACT
  always @(posedge clk) begin
    if (!rst_n) begin
      out_valid <= 1'b0;
      route_port <= 3'd0;
      read_data <= 32'd0;
    end else begin
      out_valid <= dispatch_valid || read_valid;
      if (dispatch_valid) begin
        route_port <= dispatch_dest_node ? 3'd1 : 3'd0;
      end else if (read_valid) begin
        route_port <= read_node ? 3'd1 : 3'd0;
      end
      read_data <= 32'd0;
    end
  end
`else
  reg [15:0] node0_mem [0:15];
  reg [15:0] node1_mem [0:15];
  reg [31:0] node0_results [0:15];
  reg [31:0] node1_results [0:15];
  reg [15:0] node0_mem_valid;
  reg [15:0] node1_mem_valid;
  reg [15:0] node0_result_valid;
  reg [15:0] node1_result_valid;

  reg dispatch_pending_valid;
  reg [2:0] dispatch_pending_opcode;
  reg dispatch_pending_to_node1;
  reg [2:0] dispatch_pending_route_port;
  reg [3:0] dispatch_pending_addr;
  reg [15:0] dispatch_pending_data;

  reg add_request_valid;
  reg add_request_to_node1;
  reg [3:0] add_request_addr;
  reg [15:0] add_request_operand;
  reg [15:0] add_request_increment;

  reg mul_request_valid;
  reg mul_request_to_node1;
  reg [3:0] mul_request_addr;
  reg [15:0] mul_request_multiplicand;
  reg [15:0] mul_request_repeat_count;

  reg execute_valid;
  reg execute_to_node1;
  reg [3:0] execute_addr;
  reg [31:0] execute_result;

  wire [15:0] dispatch_operand_value;
  wire [31:0] add_request_result;
  wire mul_start_valid;
  wire mul_busy;
  wire mul_done_valid;
  wire mul_done_node;
  wire [3:0] mul_done_addr;
  wire [31:0] mul_done_result;
  wire read_bypass_execute;
  wire read_bypass_mul_done;
  wire [31:0] stored_read_data;
  wire dispatch_pending_will_clear;

  assign dispatch_operand_value = dispatch_pending_to_node1
    ? (node1_mem_valid[dispatch_pending_addr] ? node1_mem[dispatch_pending_addr] : 16'd0)
    : (node0_mem_valid[dispatch_pending_addr] ? node0_mem[dispatch_pending_addr] : 16'd0);
  assign add_request_result = {16'd0, add_request_operand} + {16'd0, add_request_increment};
  assign mul_start_valid = mul_request_valid
    && !mul_busy;
  assign dispatch_pending_will_clear = dispatch_pending_valid
    && (dispatch_pending_opcode == 3'd0 || (!add_request_valid && !mul_request_valid));
  assign read_bypass_execute = execute_valid
    && execute_to_node1 == read_node
    && execute_addr == read_addr;
  assign read_bypass_mul_done = mul_done_valid
    && mul_done_node == read_node
    && mul_done_addr == read_addr;
  assign stored_read_data = read_node
    ? (node1_result_valid[read_addr] ? node1_results[read_addr] : 32'd0)
    : (node0_result_valid[read_addr] ? node0_results[read_addr] : 32'd0);

  sovryn_pan_stem_serial_multiplier multiplier (
    .clk(clk),
    .rst_n(rst_n),
    .start_valid(mul_start_valid),
    .start_node(mul_request_to_node1),
    .start_addr(mul_request_addr),
    .start_multiplicand(mul_request_multiplicand),
    .start_repeat_count(mul_request_repeat_count),
    .busy(mul_busy),
    .done_valid(mul_done_valid),
    .done_node(mul_done_node),
    .done_addr(mul_done_addr),
    .done_result(mul_done_result)
  );

  always @(posedge clk) begin
    if (!rst_n) begin
      out_valid <= 1'b0;
      route_port <= 3'd0;
      read_data <= 32'd0;
      node0_mem_valid <= 16'd0;
      node1_mem_valid <= 16'd0;
      node0_result_valid <= 16'd0;
      node1_result_valid <= 16'd0;
      dispatch_pending_valid <= 1'b0;
      dispatch_pending_opcode <= 3'd0;
      dispatch_pending_to_node1 <= 1'b0;
      dispatch_pending_route_port <= 3'd0;
      dispatch_pending_addr <= 4'd0;
      dispatch_pending_data <= 16'd0;
      add_request_valid <= 1'b0;
      add_request_to_node1 <= 1'b0;
      add_request_addr <= 4'd0;
      add_request_operand <= 16'd0;
      add_request_increment <= 16'd0;
      mul_request_valid <= 1'b0;
      mul_request_to_node1 <= 1'b0;
      mul_request_addr <= 4'd0;
      mul_request_multiplicand <= 16'd0;
      mul_request_repeat_count <= 16'd0;
      execute_valid <= 1'b0;
      execute_to_node1 <= 1'b0;
      execute_addr <= 4'd0;
      execute_result <= 32'd0;
    end else begin
      out_valid <= 1'b0;

      if (add_request_valid) begin
        execute_valid <= 1'b1;
        execute_to_node1 <= add_request_to_node1;
        execute_addr <= add_request_addr;
        execute_result <= add_request_result;
        add_request_valid <= 1'b0;
      end

      if (execute_valid) begin
        if (execute_to_node1) begin
          node1_results[execute_addr] <= execute_result;
          node1_result_valid[execute_addr] <= 1'b1;
        end else begin
          node0_results[execute_addr] <= execute_result;
          node0_result_valid[execute_addr] <= 1'b1;
        end
        execute_valid <= 1'b0;
      end

      if (mul_done_valid) begin
        if (mul_done_node) begin
          node1_results[mul_done_addr] <= mul_done_result;
          node1_result_valid[mul_done_addr] <= 1'b1;
        end else begin
          node0_results[mul_done_addr] <= mul_done_result;
          node0_result_valid[mul_done_addr] <= 1'b1;
        end
      end

      if (mul_request_valid && !mul_busy) begin
        mul_request_valid <= 1'b0;
      end

      if (dispatch_pending_valid) begin
        route_port <= dispatch_pending_route_port;
        out_valid <= 1'b1;
        case (dispatch_pending_opcode)
          3'd0: begin
            if (dispatch_pending_to_node1) begin
              node1_mem[dispatch_pending_addr] <= dispatch_pending_data;
              node1_mem_valid[dispatch_pending_addr] <= 1'b1;
            end else begin
              node0_mem[dispatch_pending_addr] <= dispatch_pending_data;
              node0_mem_valid[dispatch_pending_addr] <= 1'b1;
            end
            dispatch_pending_valid <= 1'b0;
          end
          3'd1: begin
            if (!add_request_valid) begin
              add_request_valid <= 1'b1;
              add_request_to_node1 <= dispatch_pending_to_node1;
              add_request_addr <= dispatch_pending_addr;
              add_request_operand <= dispatch_operand_value;
              add_request_increment <= dispatch_pending_data;
              dispatch_pending_valid <= 1'b0;
            end
          end
          3'd2: begin
            if (!mul_request_valid) begin
              mul_request_valid <= 1'b1;
              mul_request_to_node1 <= dispatch_pending_to_node1;
              mul_request_addr <= dispatch_pending_addr;
              mul_request_multiplicand <= dispatch_operand_value;
              mul_request_repeat_count <= dispatch_pending_data;
              dispatch_pending_valid <= 1'b0;
            end
          end
          default: begin
            dispatch_pending_valid <= 1'b0;
          end
        endcase
      end

      if (dispatch_valid && (!dispatch_pending_valid || dispatch_pending_will_clear)) begin
        dispatch_pending_valid <= 1'b1;
        dispatch_pending_opcode <= dispatch_opcode;
        dispatch_pending_to_node1 <= dispatch_dest_node;
        dispatch_pending_route_port <= dispatch_dest_node ? 3'd1 : 3'd0;
        dispatch_pending_addr <= dispatch_addr;
        dispatch_pending_data <= dispatch_data;
      end else if (read_valid) begin
        out_valid <= 1'b1;
        route_port <= read_node ? 3'd1 : 3'd0;
        if (read_bypass_execute) begin
          read_data <= execute_result;
        end else if (read_bypass_mul_done) begin
          read_data <= mul_done_result;
        end else begin
          read_data <= stored_read_data;
        end
      end
    end
  end
`endif
endmodule
