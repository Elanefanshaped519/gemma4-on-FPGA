module sovryn_pan_stem_pe_node(
  input wire clk,
  input wire rst_n,
  input wire prefetch_valid,
  input wire prefetch_bank,
  input wire prefetch_matrix_sel,
  input wire [3:0] prefetch_addr,
  input wire [7:0] prefetch_data,
  input wire swap_banks,
  input wire compute_valid,
  input wire read_valid,
  input wire [3:0] read_addr,
  output reg out_valid,
  output reg [23:0] read_data,
  output reg active_bank
);
  integer row;
  integer col;
  integer k;
  integer idx;
  reg [7:0] a_bank0 [0:15];
  reg [7:0] a_bank1 [0:15];
  reg [7:0] b_bank0 [0:15];
  reg [7:0] b_bank1 [0:15];
  reg [23:0] c_mem [0:15];
  reg [31:0] sum_acc;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      out_valid <= 1'b0;
      read_data <= 24'd0;
      active_bank <= 1'b0;
      for (idx = 0; idx < 16; idx = idx + 1) begin
        a_bank0[idx] <= 8'd0;
        a_bank1[idx] <= 8'd0;
        b_bank0[idx] <= 8'd0;
        b_bank1[idx] <= 8'd0;
        c_mem[idx] <= 24'd0;
      end
    end else begin
      out_valid <= 1'b0;
      if (prefetch_valid) begin
        if (!prefetch_matrix_sel) begin
          if (prefetch_bank) begin
            a_bank1[prefetch_addr] <= prefetch_data;
          end else begin
            a_bank0[prefetch_addr] <= prefetch_data;
          end
        end else if (prefetch_bank) begin
          b_bank1[prefetch_addr] <= prefetch_data;
        end else begin
          b_bank0[prefetch_addr] <= prefetch_data;
        end
      end
      if (swap_banks) begin
        active_bank <= ~active_bank;
      end
      if (compute_valid) begin
        for (row = 0; row < 4; row = row + 1) begin
          for (col = 0; col < 4; col = col + 1) begin
            sum_acc = 32'd0;
            for (k = 0; k < 4; k = k + 1) begin
              sum_acc = sum_acc + (
                active_bank
                  ? ({24'd0, a_bank1[(row * 4) + k]} * {24'd0, b_bank1[(k * 4) + col]})
                  : ({24'd0, a_bank0[(row * 4) + k]} * {24'd0, b_bank0[(k * 4) + col]})
              );
            end
            c_mem[(row * 4) + col] <= sum_acc[23:0];
          end
        end
        out_valid <= 1'b1;
      end else if (read_valid) begin
        out_valid <= 1'b1;
        read_data <= c_mem[read_addr];
      end
    end
  end
endmodule
