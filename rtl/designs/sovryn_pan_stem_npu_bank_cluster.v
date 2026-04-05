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
