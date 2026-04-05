module sovryn_pan_stem_npu_array_v2_innercore_a_retire(
  input wire clk,
  input wire rst_n,
  input wire execute_valid,
  input wire [1:0] execute_opcode,
  input wire [1:0] execute_addr,
  input wire [15:0] execute_data,
  input wire [15:0] execute_result,
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
    case (execute_addr)
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
      if (execute_valid) begin
        case (execute_opcode)
          2'b00: begin
            case (execute_addr)
              2'd0: operand0 <= execute_data;
              2'd1: operand1 <= execute_data;
              2'd2: result0 <= execute_data;
              default: result1 <= execute_data;
            endcase
          end
          2'b01,
          2'b10: begin
            if (execute_addr[0] == 1'b0) begin
              result0 <= execute_result;
            end else begin
              result1 <= execute_result;
            end
          end
          2'b11: begin
            local_observe_valid <= 1'b1;
            local_observe_payload <= {
              local_row,
              local_col,
              execute_addr,
              selected_read_data
            };
          end
          default: begin
          end
        endcase
      end
    end
  end
endmodule
