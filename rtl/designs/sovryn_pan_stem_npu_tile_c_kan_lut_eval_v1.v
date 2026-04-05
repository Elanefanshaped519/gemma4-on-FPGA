module sovryn_pan_stem_npu_tile_c_kan_lut_eval_v1 #(
  parameter integer DOMAIN_MIN = -1024,
  parameter integer DOMAIN_MAX = 1024,
  parameter integer SAMPLE_COUNT = 9,
  parameter LUT_INIT_FILE = "hardware/fixtures/kan/kan_v1_lut_fixture.mem"
) (
  input wire clk,
  input wire rst_n,
  input wire advance_tick,
  input wire input_valid,
  input wire signed [15:0] input_value,
  output reg output_valid,
  output reg signed [15:0] output_value
);
  reg signed [15:0] lut_mem [0:255];
  integer init_index;
  integer clamped_input;
  integer scaled_index;
  integer lut_index;

  initial begin
    for (init_index = 0; init_index < 256; init_index = init_index + 1) begin
      lut_mem[init_index] = 16'sd0;
    end
    $readmemh(LUT_INIT_FILE, lut_mem);
  end

  always @(*) begin
    clamped_input = $signed({{16{input_value[15]}}, input_value});
    if (clamped_input < DOMAIN_MIN) begin
      clamped_input = DOMAIN_MIN;
    end else if (clamped_input > DOMAIN_MAX) begin
      clamped_input = DOMAIN_MAX;
    end

    if (SAMPLE_COUNT <= 1 || DOMAIN_MAX <= DOMAIN_MIN) begin
      lut_index = 0;
    end else begin
      scaled_index = ((clamped_input - DOMAIN_MIN) * (SAMPLE_COUNT - 1)) + ((DOMAIN_MAX - DOMAIN_MIN) / 2);
      lut_index = scaled_index / (DOMAIN_MAX - DOMAIN_MIN);
      if (lut_index < 0) begin
        lut_index = 0;
      end else if (lut_index > (SAMPLE_COUNT - 1)) begin
        lut_index = SAMPLE_COUNT - 1;
      end
    end
  end

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      output_valid <= 1'b0;
      output_value <= 16'sd0;
    end else if (advance_tick && input_valid) begin
      output_valid <= 1'b1;
      output_value <= lut_mem[lut_index];
    end else begin
      output_valid <= 1'b0;
    end
  end
endmodule
