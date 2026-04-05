module sovryn_pan_stem_npu_array_pd_wrapper(
  input wire clk,
  input wire rst_n,
  input wire scan_in,
  output wire scan_out
);
  localparam integer INPUT_PACKET_WIDTH = 25;
  localparam integer OUTPUT_PACKET_WIDTH = 23;
  localparam [5:0] INPUT_PACKET_LAST = INPUT_PACKET_WIDTH - 1;

  reg [INPUT_PACKET_WIDTH-1:0] input_shift_reg;
  reg [5:0] input_shift_count;
  reg cmd_valid_reg;
  reg [1:0] cmd_opcode_reg;
  reg [1:0] cmd_row_reg;
  reg [1:0] cmd_col_reg;
  reg [1:0] cmd_addr_reg;
  reg [15:0] cmd_data_reg;

  reg [OUTPUT_PACKET_WIDTH-1:0] output_shift_reg;
  reg [5:0] output_bits_remaining;

  wire [INPUT_PACKET_WIDTH-1:0] next_input_shift = {
    input_shift_reg[INPUT_PACKET_WIDTH-2:0],
    scan_in
  };

  wire inner_read_valid;
  wire [1:0] inner_read_row;
  wire [1:0] inner_read_col;
  wire [1:0] inner_read_addr;
  wire [15:0] inner_read_data;
  assign scan_out = (output_bits_remaining != 0) ? output_shift_reg[OUTPUT_PACKET_WIDTH-1] : 1'b0;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      input_shift_reg <= {INPUT_PACKET_WIDTH{1'b0}};
      input_shift_count <= 6'd0;
      cmd_valid_reg <= 1'b0;
      cmd_opcode_reg <= 2'b00;
      cmd_row_reg <= 2'b00;
      cmd_col_reg <= 2'b00;
      cmd_addr_reg <= 2'b00;
      cmd_data_reg <= 16'h0000;
      output_shift_reg <= {OUTPUT_PACKET_WIDTH{1'b0}};
      output_bits_remaining <= 6'd0;
    end else begin
      input_shift_reg <= next_input_shift;
      cmd_valid_reg <= 1'b0;

      if (input_shift_count == INPUT_PACKET_LAST) begin
        input_shift_count <= 6'd0;
        cmd_valid_reg <= next_input_shift[24];
        cmd_opcode_reg <= next_input_shift[23:22];
        cmd_row_reg <= next_input_shift[21:20];
        cmd_col_reg <= next_input_shift[19:18];
        cmd_addr_reg <= next_input_shift[17:16];
        cmd_data_reg <= next_input_shift[15:0];
      end else begin
        input_shift_count <= input_shift_count + 6'd1;
      end

      if (inner_read_valid) begin
        output_shift_reg <= {
          1'b1,
          inner_read_row,
          inner_read_col,
          inner_read_addr,
          inner_read_data
        };
        output_bits_remaining <= OUTPUT_PACKET_WIDTH[5:0];
      end else if (output_bits_remaining != 0) begin
        output_shift_reg <= {
          output_shift_reg[OUTPUT_PACKET_WIDTH-2:0],
          1'b0
        };
        output_bits_remaining <= output_bits_remaining - 6'd1;
      end
    end
  end

  sovryn_pan_stem_npu_array_top inner_array_inst (
    .clk(clk),
    .rst_n(rst_n),
    .cmd_valid(cmd_valid_reg),
    .cmd_opcode(cmd_opcode_reg),
    .cmd_row(cmd_row_reg),
    .cmd_col(cmd_col_reg),
    .cmd_addr(cmd_addr_reg),
    .cmd_data(cmd_data_reg),
    .read_valid(inner_read_valid),
    .read_row(inner_read_row),
    .read_col(inner_read_col),
    .read_addr(inner_read_addr),
    .read_data(inner_read_data),
    .array_rows(),
    .array_cols()
  );
endmodule
