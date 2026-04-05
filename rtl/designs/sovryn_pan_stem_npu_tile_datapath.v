(* keep_hierarchy = "yes" *)
module sovryn_pan_stem_npu_tile_datapath(
  input wire clk,
  input wire rst_n,
  input wire issue_valid,
  input wire [2:0] issue_opcode,
  input wire [3:0] issue_addr,
  input wire [15:0] issue_data,
  output reg commit_valid,
  output reg [3:0] commit_addr,
  output reg [31:0] commit_result
);
  reg [15:0] operand_mem [0:15];
  reg [15:0] operand_valid;

  reg mul_start_valid;
  reg [3:0] mul_start_addr;
  reg [15:0] mul_start_multiplicand;
  reg [15:0] mul_start_repeat_count;

  wire [15:0] operand_value;
  wire [31:0] add_result;
  wire mul_busy;
  wire mul_done_valid;
  wire [3:0] mul_done_addr;
  wire [31:0] mul_done_result;

  assign operand_value = operand_valid[issue_addr] ? operand_mem[issue_addr] : 16'd0;
  assign add_result = {16'd0, operand_value} + {16'd0, issue_data};

  sovryn_pan_stem_npu_mul_macro_v4 multiplier (
    .clk(clk),
    .rst_n(rst_n),
    .start_valid(mul_start_valid),
    .start_addr(mul_start_addr),
    .start_multiplicand(mul_start_multiplicand),
    .start_repeat_count(mul_start_repeat_count),
    .busy(mul_busy),
    .done_valid(mul_done_valid),
    .done_addr(mul_done_addr),
    .done_result(mul_done_result)
  );

  always @(posedge clk) begin
    if (!rst_n) begin
      operand_valid <= 16'd0;
      mul_start_valid <= 1'b0;
      mul_start_addr <= 4'd0;
      mul_start_multiplicand <= 16'd0;
      mul_start_repeat_count <= 16'd0;
      commit_valid <= 1'b0;
      commit_addr <= 4'd0;
      commit_result <= 32'd0;
    end else begin
      commit_valid <= 1'b0;

      if (mul_start_valid) begin
        mul_start_valid <= 1'b0;
      end

      if (issue_valid) begin
        case (issue_opcode)
          3'd0: begin
            operand_mem[issue_addr] <= issue_data;
            operand_valid[issue_addr] <= 1'b1;
          end
          3'd1: begin
            commit_valid <= 1'b1;
            commit_addr <= issue_addr;
            commit_result <= add_result;
          end
          3'd2: begin
            if (!mul_busy && !mul_start_valid) begin
              mul_start_valid <= 1'b1;
              mul_start_addr <= issue_addr;
              mul_start_multiplicand <= operand_value;
              mul_start_repeat_count <= issue_data;
            end
          end
          default: begin
          end
        endcase
      end

      if (mul_done_valid) begin
        commit_valid <= 1'b1;
        commit_addr <= mul_done_addr;
        commit_result <= mul_done_result;
      end
    end
  end
endmodule
