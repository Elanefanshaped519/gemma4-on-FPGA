`timescale 1ns/1ps

`include "sovryn_pan_stem_npu_array_tile_a_projection.v"
`include "sovryn_pan_stem_npu_array_tile_b_state.v"
`include "sovryn_pan_stem_npu_array_tile_c_sfu_transformer.v"
`include "sovryn_pan_stem_npu_array_tile_c_sfu_kan.v"
`include "sovryn_pan_stem_npu_array_tile_d_photonic.v"

module sovryn_pan_stem_npu_array_v5_omni_top (
  input  wire clk,
  input  wire rst_n,
  input  wire advance_tick,
  input  wire [15:0] ext_ingress_data,
  output wire [15:0] ext_egress_data,
  // Quantum Photonic Interfaces
  input  wire [63:0] opt_rx_payload,
  output wire [63:0] opt_tx_payload,
  output wire opt_phase_lock_err
);

  // Grid Generated from Omni-5 Mapping (Columns: 1)

  // Network-on-Chip (NoC) Cascading Wires // 
  wire [15:0] link_row1_to_2;
  wire [15:0] link_row2_to_3;
  wire [15:0] link_row3_to_4;
  wire [15:0] link_row4_to_5;
  wire [15:0] optical_egress_classic;

  assign ext_egress_data = optical_egress_classic;

  // Row 1: Sensory & Embeddings (HDC_V3)
  sovryn_pan_stem_npu_array_tile_a_projection title_a_lane (
    .clk(clk), .rst_n(rst_n),
    .ingress_data(ext_ingress_data),
    .egress_data(link_row1_to_2)
  );

  // Row 2: Mamba / State Space
  sovryn_pan_stem_npu_array_tile_b_state title_b_lane (
    .clk(clk), .rst_n(rst_n),
    .ingress_data(link_row1_to_2),
    .egress_data(link_row2_to_3)
  );

  // Row 3: Transformer Logic
  sovryn_pan_stem_npu_array_tile_c_sfu_transformer title_c_transformer_lane (
    .clk(clk), .rst_n(rst_n),
    .ingress_data(link_row2_to_3),
    .egress_data(link_row3_to_4)
  );

  // Row 4: KAN / Spline Logic
  sovryn_pan_stem_npu_array_tile_c_sfu_kan title_c_kan_lane (
    .clk(clk), .rst_n(rst_n),
    .ingress_data(link_row3_to_4),
    .egress_data(link_row4_to_5)
  );

  // Row 5: Photonic Interconnect
  sovryn_pan_stem_npu_array_tile_d_photonic title_d_photonic_lane (
    .clk(clk), .rst_n(rst_n),
    .ingress_data(link_row4_to_5),
    .egress_data(optical_egress_classic),
    .opt_rx(opt_rx_payload),
    .opt_tx(opt_tx_payload),
    .phase_err(opt_phase_lock_err)
  );

endmodule
