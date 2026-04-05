module sovryn_pan_stem_npu_kan_l1_lut_bank_stub #(
  parameter LUT_INIT_FILE = "hardware/fixtures/kan/kan_v1_lut_fixture.mem"
) (
  input wire [7:0] read_addr,
  output wire signed [15:0] read_data
);
  reg signed [15:0] lut_mem [0:255];
  integer init_index;

  initial begin
    for (init_index = 0; init_index < 256; init_index = init_index + 1) begin
      lut_mem[init_index] = 16'sd0;
    end
    $readmemh(LUT_INIT_FILE, lut_mem);
  end

  assign read_data = lut_mem[read_addr];
endmodule
