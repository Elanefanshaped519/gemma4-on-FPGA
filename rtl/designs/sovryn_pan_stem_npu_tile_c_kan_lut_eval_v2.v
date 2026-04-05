module sovryn_pan_stem_npu_tile_c_kan_lut_eval_v2 #(
  parameter integer DOMAIN_MIN = -1024,
  parameter integer DOMAIN_MAX = 1024,
  parameter integer SAMPLE_COUNT = 9
) (
  input wire clk,
  input wire rst_n,
  input wire advance_tick,
  input wire input_valid,
  input wire signed [15:0] input_value,
  input wire signed [15:0] lut_read_data,
  output wire [7:0] lut_read_addr,
  output reg output_valid,
  output reg signed [15:0] output_value
);
  reg stage_active;
  reg signed [15:0] stage_input_value;
  integer clamped_input;
  integer scaled_index;
  integer lut_index;

  always @(*) begin
    clamped_input = $signed({{16{stage_input_value[15]}}, stage_input_value});
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

  assign lut_read_addr = lut_index[7:0];

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      stage_active <= 1'b0;
      stage_input_value <= 16'sd0;
      output_valid <= 1'b0;
      output_value <= 16'sd0;
    end else begin
      output_valid <= stage_active;
      if (stage_active) begin
        output_value <= lut_read_data;
      end

      stage_active <= advance_tick && input_valid;
      if (advance_tick && input_valid) begin
        stage_input_value <= input_value;
      end
    end
  end
endmodule
