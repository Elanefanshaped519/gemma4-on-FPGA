module sovryn_pan_stem_npu_kan_l1_sram_bank_ihp_sg13g2_1p_256x16 #(
  parameter LUT_INIT_FILE = "hardware/fixtures/kan/kan_v1_lut_fixture.mem"
) (
  input wire clk,
  input wire rst_n,
  input wire [7:0] read_addr,
  output reg signed [15:0] read_data
);
`ifndef SYNTHESIS
  reg signed [15:0] lut_mem [0:255];
  integer init_index;

  initial begin
    for (init_index = 0; init_index < 256; init_index = init_index + 1) begin
      lut_mem[init_index] = 16'sd0;
    end
    $readmemh(LUT_INIT_FILE, lut_mem);
  end

  always @(*) begin
    read_data = lut_mem[read_addr];
  end
`else
  wire [15:0] macro_read_data;

  RM_IHPSG13_1P_256x16_c2_bm_bist kan_l1_sram_macro (
    .A_CLK(clk),
    .A_MEN(1'b1),
    .A_WEN(1'b0),
    .A_REN(1'b1),
    .A_ADDR(read_addr),
    .A_DIN(16'h0000),
    .A_DLY(1'b0),
    .A_DOUT(macro_read_data),
    .A_BM(16'hFFFF),
    .A_BIST_CLK(1'b0),
    .A_BIST_EN(1'b0),
    .A_BIST_MEN(1'b0),
    .A_BIST_WEN(1'b0),
    .A_BIST_REN(1'b0),
    .A_BIST_ADDR(8'h00),
    .A_BIST_DIN(16'h0000),
    .A_BIST_BM(16'h0000)
  );

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      read_data <= 16'sd0;
    end else begin
      read_data <= $signed(macro_read_data);
    end
  end
`endif
endmodule
