module sovryn_pan_stem_npu_array_tile_commit(
  input wire clk,
  input wire rst_n,
  input wire apply_valid,
  input wire [1:0] opcode,
  input wire [1:0] local_row,
  input wire [1:0] local_col,
  input wire [1:0] local_addr,
  input wire [15:0] local_data,
  input wire [15:0] computed_result,
  output wire [15:0] operand_a,
  output wire [15:0] operand_b,
  output reg observe_valid,
  output reg [21:0] observe_payload
);
  reg [15:0] operand0;
  reg [15:0] operand1;
  reg [15:0] result0;
  reg [15:0] result1;
  reg pending_result_valid;
  reg [1:0] pending_result_addr;
  reg [15:0] pending_result_data;
  reg observe_pending_valid;
  reg [21:0] observe_pending_payload;
  reg [15:0] selected_read_data;

  assign operand_a = operand0;
  assign operand_b = operand1;

  always @* begin
    case (local_addr)
      2'd0: selected_read_data = operand0;
      2'd1: selected_read_data = operand1;
      2'd2: begin
        if (pending_result_valid && pending_result_addr == 2'd2) begin
          selected_read_data = pending_result_data;
        end else begin
          selected_read_data = result0;
        end
      end
      default: begin
        if (pending_result_valid && pending_result_addr == 2'd3) begin
          selected_read_data = pending_result_data;
        end else begin
          selected_read_data = result1;
        end
      end
    endcase
  end

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      operand0 <= 16'd0;
      operand1 <= 16'd0;
      result0 <= 16'd0;
      result1 <= 16'd0;
      pending_result_valid <= 1'b0;
      pending_result_addr <= 2'd0;
      pending_result_data <= 16'd0;
      observe_pending_valid <= 1'b0;
      observe_pending_payload <= 22'd0;
      observe_valid <= 1'b0;
      observe_payload <= 22'd0;
    end else begin
      observe_valid <= observe_pending_valid;
      if (observe_pending_valid) begin
        observe_payload <= observe_pending_payload;
      end else begin
        observe_payload <= 22'd0;
      end

      if (observe_pending_valid) begin
        observe_pending_valid <= 1'b0;
      end

      if (pending_result_valid) begin
        if (pending_result_addr[0] == 1'b0) begin
          result0 <= pending_result_data;
        end else begin
          result1 <= pending_result_data;
        end
        pending_result_valid <= 1'b0;
      end

      if (apply_valid) begin
        case (opcode)
          2'b00: begin
            case (local_addr)
              2'd0: operand0 <= local_data;
              2'd1: operand1 <= local_data;
              2'd2: result0 <= local_data;
              default: result1 <= local_data;
            endcase
          end
          2'b01,
          2'b10: begin
            pending_result_valid <= 1'b1;
            pending_result_addr <= local_addr;
            pending_result_data <= computed_result;
          end
          2'b11: begin
            observe_pending_valid <= 1'b1;
            observe_pending_payload <= {
              local_row,
              local_col,
              local_addr,
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
