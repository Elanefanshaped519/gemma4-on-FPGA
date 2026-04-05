module sovryn_pan_stem_npu_array_v3_seed_a_retire_writeback(
  input wire clk,
  input wire rst_n,
  input wire alu_valid,
  input wire [1:0] alu_opcode,
  input wire [1:0] alu_addr,
  input wire [15:0] alu_data,
  input wire [15:0] alu_result,
  input wire mul_valid,
  input wire [1:0] mul_addr,
  input wire [15:0] mul_result,
  input wire [1:0] local_row,
  input wire [1:0] local_col,
  output wire [15:0] operand_a,
  output wire [15:0] operand_b,
  output reg local_observe_valid,
  output reg [21:0] local_observe_payload
);
  reg [15:0] operand0;
  reg [15:0] operand1;
  reg [15:0] result0;
  reg [15:0] result1;
  reg [15:0] selected_read_data;

  assign operand_a = operand0;
  assign operand_b = operand1;

  always @* begin
    case (alu_addr)
      2'd0: selected_read_data = operand0;
      2'd1: selected_read_data = operand1;
      2'd2: selected_read_data = result0;
      default: selected_read_data = result1;
    endcase
  end

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      operand0 <= 16'd0;
      operand1 <= 16'd0;
      result0 <= 16'd0;
      result1 <= 16'd0;
      local_observe_valid <= 1'b0;
      local_observe_payload <= 22'd0;
    end else begin
      local_observe_valid <= 1'b0;
      if (alu_valid) begin
        case (alu_opcode)
          2'b00: begin
            case (alu_addr)
              2'd0: operand0 <= alu_data;
              2'd1: operand1 <= alu_data;
              2'd2: result0 <= alu_data;
              default: result1 <= alu_data;
            endcase
          end
          2'b01: begin
            if (alu_addr[0] == 1'b0) begin
              result0 <= alu_result;
            end else begin
              result1 <= alu_result;
            end
          end
          2'b11: begin
            local_observe_valid <= 1'b1;
            local_observe_payload <= {
              local_row,
              local_col,
              alu_addr,
              selected_read_data
            };
          end
          default: begin
          end
        endcase
      end

      if (mul_valid) begin
        if (mul_addr[0] == 1'b0) begin
          result0 <= mul_result;
        end else begin
          result1 <= mul_result;
        end
      end
    end
  end
endmodule
