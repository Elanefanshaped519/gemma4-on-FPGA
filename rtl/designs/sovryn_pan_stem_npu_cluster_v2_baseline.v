(* keep_hierarchy = "yes" *)
module sovryn_pan_stem_npu_mul_unit(
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

(* keep_hierarchy = "yes" *)
module sovryn_pan_stem_npu_dispatch_router(
  input wire dispatch_valid,
  input wire [2:0] dispatch_opcode,
  input wire dispatch_dest_node,
  input wire [3:0] dispatch_addr,
  input wire [15:0] dispatch_data,
  output wire node0_request_valid,
  output wire node1_request_valid,
  output wire [2:0] node0_request_opcode,
  output wire [2:0] node1_request_opcode,
  output wire [3:0] node0_request_addr,
  output wire [3:0] node1_request_addr,
  output wire [15:0] node0_request_data,
  output wire [15:0] node1_request_data,
  output wire [2:0] dispatch_route_port
);
  assign node0_request_valid = dispatch_valid && !dispatch_dest_node;
  assign node1_request_valid = dispatch_valid && dispatch_dest_node;
  assign node0_request_opcode = dispatch_opcode;
  assign node1_request_opcode = dispatch_opcode;
  assign node0_request_addr = dispatch_addr;
  assign node1_request_addr = dispatch_addr;
  assign node0_request_data = dispatch_data;
  assign node1_request_data = dispatch_data;
  assign dispatch_route_port = dispatch_dest_node ? 3'd1 : 3'd0;
endmodule

(* keep_hierarchy = "yes" *)
module sovryn_pan_stem_npu_readback_mux(
  input wire read_node,
  input wire [31:0] node0_read_data,
  input wire [31:0] node1_read_data,
  output wire [31:0] selected_read_data
);
  assign selected_read_data = read_node ? node1_read_data : node0_read_data;
endmodule

(* keep_hierarchy = "yes" *)
module sovryn_pan_stem_npu_bank_cluster(
  input wire clk,
  input wire rst_n,
  input wire request_valid,
  input wire [2:0] request_opcode,
  input wire [3:0] request_addr,
  input wire [15:0] request_data,
  input wire read_valid,
  input wire [3:0] read_addr,
  output wire [31:0] read_data
);
  reg [15:0] operand_mem [0:15];
  reg [31:0] result_mem [0:15];
  reg [15:0] operand_valid;
  reg [15:0] result_valid;

  reg mul_request_valid;
  reg [3:0] mul_request_addr;
  reg [15:0] mul_request_multiplicand;
  reg [15:0] mul_request_repeat_count;

  wire [15:0] operand_value;
  wire [31:0] add_result;
  wire mul_busy;
  wire mul_done_valid;
  wire [3:0] mul_done_addr;
  wire [31:0] mul_done_result;

  assign operand_value = operand_valid[request_addr] ? operand_mem[request_addr] : 16'd0;
  assign add_result = {16'd0, operand_value} + {16'd0, request_data};
  assign read_data = result_valid[read_addr] ? result_mem[read_addr] : 32'd0;

  sovryn_pan_stem_npu_mul_unit multiplier (
    .clk(clk),
    .rst_n(rst_n),
    .start_valid(mul_request_valid && !mul_busy),
    .start_addr(mul_request_addr),
    .start_multiplicand(mul_request_multiplicand),
    .start_repeat_count(mul_request_repeat_count),
    .busy(mul_busy),
    .done_valid(mul_done_valid),
    .done_addr(mul_done_addr),
    .done_result(mul_done_result)
  );

  always @(posedge clk) begin
    if (!rst_n) begin
      operand_valid <= 16'd0;
      result_valid <= 16'd0;
      mul_request_valid <= 1'b0;
      mul_request_addr <= 4'd0;
      mul_request_multiplicand <= 16'd0;
      mul_request_repeat_count <= 16'd0;
    end else begin
      if (request_valid) begin
        case (request_opcode)
          3'd0: begin
            operand_mem[request_addr] <= request_data;
            operand_valid[request_addr] <= 1'b1;
          end
          3'd1: begin
            result_mem[request_addr] <= add_result;
            result_valid[request_addr] <= 1'b1;
          end
          3'd2: begin
            if (!mul_request_valid && !mul_busy) begin
              mul_request_valid <= 1'b1;
              mul_request_addr <= request_addr;
              mul_request_multiplicand <= operand_value;
              mul_request_repeat_count <= request_data;
            end
          end
          default: begin
          end
        endcase
      end

      if (mul_request_valid && !mul_busy) begin
        mul_request_valid <= 1'b0;
      end

      if (mul_done_valid) begin
        result_mem[mul_done_addr] <= mul_done_result;
        result_valid[mul_done_addr] <= 1'b1;
      end
    end
  end
endmodule

(* keep_hierarchy = "yes" *)
module sovryn_pan_stem_npu_cluster_v2_top(
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
  wire node0_request_valid;
  wire node1_request_valid;
  wire [2:0] node0_request_opcode;
  wire [2:0] node1_request_opcode;
  wire [3:0] node0_request_addr;
  wire [3:0] node1_request_addr;
  wire [15:0] node0_request_data;
  wire [15:0] node1_request_data;
  wire [2:0] dispatch_route_port;
  wire [31:0] node0_read_data;
  wire [31:0] node1_read_data;
  wire [31:0] selected_read_data;

  sovryn_pan_stem_npu_dispatch_router dispatch_router (
    .dispatch_valid(dispatch_valid),
    .dispatch_opcode(dispatch_opcode),
    .dispatch_dest_node(dispatch_dest_node),
    .dispatch_addr(dispatch_addr),
    .dispatch_data(dispatch_data),
    .node0_request_valid(node0_request_valid),
    .node1_request_valid(node1_request_valid),
    .node0_request_opcode(node0_request_opcode),
    .node1_request_opcode(node1_request_opcode),
    .node0_request_addr(node0_request_addr),
    .node1_request_addr(node1_request_addr),
    .node0_request_data(node0_request_data),
    .node1_request_data(node1_request_data),
    .dispatch_route_port(dispatch_route_port)
  );

  sovryn_pan_stem_npu_bank_cluster node0_cluster (
    .clk(clk),
    .rst_n(rst_n),
    .request_valid(node0_request_valid),
    .request_opcode(node0_request_opcode),
    .request_addr(node0_request_addr),
    .request_data(node0_request_data),
    .read_valid(read_valid && !read_node),
    .read_addr(read_addr),
    .read_data(node0_read_data)
  );

  sovryn_pan_stem_npu_bank_cluster node1_cluster (
    .clk(clk),
    .rst_n(rst_n),
    .request_valid(node1_request_valid),
    .request_opcode(node1_request_opcode),
    .request_addr(node1_request_addr),
    .request_data(node1_request_data),
    .read_valid(read_valid && read_node),
    .read_addr(read_addr),
    .read_data(node1_read_data)
  );

  sovryn_pan_stem_npu_readback_mux readback_mux (
    .read_node(read_node),
    .node0_read_data(node0_read_data),
    .node1_read_data(node1_read_data),
    .selected_read_data(selected_read_data)
  );

  always @(posedge clk) begin
    if (!rst_n) begin
      out_valid <= 1'b0;
      route_port <= 3'd0;
      read_data <= 32'd0;
    end else begin
      out_valid <= dispatch_valid || read_valid;
      if (dispatch_valid) begin
        route_port <= dispatch_route_port;
      end else if (read_valid) begin
        route_port <= read_node ? 3'd1 : 3'd0;
      end

      if (read_valid) begin
        read_data <= selected_read_data;
      end
    end
  end
`endif
endmodule
