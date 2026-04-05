`timescale 1ns/1ps

module sovryn_npu_omni_titan_64_top (
  input wire clk,
  input wire rst_n,
  input  wire [15:0] io_north_in_0,
  output wire [15:0] io_north_out_0,
  input  wire [15:0] io_south_in_0,
  output wire [15:0] io_south_out_0,
  input  wire [15:0] io_east_in_0,
  output wire [15:0] io_east_out_0,
  input  wire [15:0] io_west_in_0,
  output wire [15:0] io_west_out_0,
  input  wire [15:0] io_north_in_1,
  output wire [15:0] io_north_out_1,
  input  wire [15:0] io_south_in_1,
  output wire [15:0] io_south_out_1,
  input  wire [15:0] io_east_in_1,
  output wire [15:0] io_east_out_1,
  input  wire [15:0] io_west_in_1,
  output wire [15:0] io_west_out_1,
  input  wire [15:0] io_north_in_2,
  output wire [15:0] io_north_out_2,
  input  wire [15:0] io_south_in_2,
  output wire [15:0] io_south_out_2,
  input  wire [15:0] io_east_in_2,
  output wire [15:0] io_east_out_2,
  input  wire [15:0] io_west_in_2,
  output wire [15:0] io_west_out_2,
  input  wire [15:0] io_north_in_3,
  output wire [15:0] io_north_out_3,
  input  wire [15:0] io_south_in_3,
  output wire [15:0] io_south_out_3,
  input  wire [15:0] io_east_in_3,
  output wire [15:0] io_east_out_3,
  input  wire [15:0] io_west_in_3,
  output wire [15:0] io_west_out_3,
  input  wire [15:0] io_north_in_4,
  output wire [15:0] io_north_out_4,
  input  wire [15:0] io_south_in_4,
  output wire [15:0] io_south_out_4,
  input  wire [15:0] io_east_in_4,
  output wire [15:0] io_east_out_4,
  input  wire [15:0] io_west_in_4,
  output wire [15:0] io_west_out_4,
  input  wire [15:0] io_north_in_5,
  output wire [15:0] io_north_out_5,
  input  wire [15:0] io_south_in_5,
  output wire [15:0] io_south_out_5,
  input  wire [15:0] io_east_in_5,
  output wire [15:0] io_east_out_5,
  input  wire [15:0] io_west_in_5,
  output wire [15:0] io_west_out_5,
  input  wire [15:0] io_north_in_6,
  output wire [15:0] io_north_out_6,
  input  wire [15:0] io_south_in_6,
  output wire [15:0] io_south_out_6,
  input  wire [15:0] io_east_in_6,
  output wire [15:0] io_east_out_6,
  input  wire [15:0] io_west_in_6,
  output wire [15:0] io_west_out_6,
  input  wire [15:0] io_north_in_7,
  output wire [15:0] io_north_out_7,
  input  wire [15:0] io_south_in_7,
  output wire [15:0] io_south_out_7,
  input  wire [15:0] io_east_in_7,
  output wire [15:0] io_east_out_7,
  input  wire [15:0] io_west_in_7,
  output wire [15:0] io_west_out_7
);

  // --- INTERNAL NoC WIRES ---
  wire [15:0] t_0_0_n_out, t_0_0_n_in;
  wire [15:0] t_0_0_e_out, t_0_0_e_in;
  wire [15:0] t_0_0_s_out, t_0_0_s_in;
  wire [15:0] t_0_0_w_out, t_0_0_w_in;
  wire [15:0] t_0_1_n_out, t_0_1_n_in;
  wire [15:0] t_0_1_e_out, t_0_1_e_in;
  wire [15:0] t_0_1_s_out, t_0_1_s_in;
  wire [15:0] t_0_1_w_out, t_0_1_w_in;
  wire [15:0] t_0_2_n_out, t_0_2_n_in;
  wire [15:0] t_0_2_e_out, t_0_2_e_in;
  wire [15:0] t_0_2_s_out, t_0_2_s_in;
  wire [15:0] t_0_2_w_out, t_0_2_w_in;
  wire [15:0] t_0_3_n_out, t_0_3_n_in;
  wire [15:0] t_0_3_e_out, t_0_3_e_in;
  wire [15:0] t_0_3_s_out, t_0_3_s_in;
  wire [15:0] t_0_3_w_out, t_0_3_w_in;
  wire [15:0] t_0_4_n_out, t_0_4_n_in;
  wire [15:0] t_0_4_e_out, t_0_4_e_in;
  wire [15:0] t_0_4_s_out, t_0_4_s_in;
  wire [15:0] t_0_4_w_out, t_0_4_w_in;
  wire [15:0] t_0_5_n_out, t_0_5_n_in;
  wire [15:0] t_0_5_e_out, t_0_5_e_in;
  wire [15:0] t_0_5_s_out, t_0_5_s_in;
  wire [15:0] t_0_5_w_out, t_0_5_w_in;
  wire [15:0] t_0_6_n_out, t_0_6_n_in;
  wire [15:0] t_0_6_e_out, t_0_6_e_in;
  wire [15:0] t_0_6_s_out, t_0_6_s_in;
  wire [15:0] t_0_6_w_out, t_0_6_w_in;
  wire [15:0] t_0_7_n_out, t_0_7_n_in;
  wire [15:0] t_0_7_e_out, t_0_7_e_in;
  wire [15:0] t_0_7_s_out, t_0_7_s_in;
  wire [15:0] t_0_7_w_out, t_0_7_w_in;
  wire [15:0] t_1_0_n_out, t_1_0_n_in;
  wire [15:0] t_1_0_e_out, t_1_0_e_in;
  wire [15:0] t_1_0_s_out, t_1_0_s_in;
  wire [15:0] t_1_0_w_out, t_1_0_w_in;
  wire [15:0] t_1_1_n_out, t_1_1_n_in;
  wire [15:0] t_1_1_e_out, t_1_1_e_in;
  wire [15:0] t_1_1_s_out, t_1_1_s_in;
  wire [15:0] t_1_1_w_out, t_1_1_w_in;
  wire [15:0] t_1_2_n_out, t_1_2_n_in;
  wire [15:0] t_1_2_e_out, t_1_2_e_in;
  wire [15:0] t_1_2_s_out, t_1_2_s_in;
  wire [15:0] t_1_2_w_out, t_1_2_w_in;
  wire [15:0] t_1_3_n_out, t_1_3_n_in;
  wire [15:0] t_1_3_e_out, t_1_3_e_in;
  wire [15:0] t_1_3_s_out, t_1_3_s_in;
  wire [15:0] t_1_3_w_out, t_1_3_w_in;
  wire [15:0] t_1_4_n_out, t_1_4_n_in;
  wire [15:0] t_1_4_e_out, t_1_4_e_in;
  wire [15:0] t_1_4_s_out, t_1_4_s_in;
  wire [15:0] t_1_4_w_out, t_1_4_w_in;
  wire [15:0] t_1_5_n_out, t_1_5_n_in;
  wire [15:0] t_1_5_e_out, t_1_5_e_in;
  wire [15:0] t_1_5_s_out, t_1_5_s_in;
  wire [15:0] t_1_5_w_out, t_1_5_w_in;
  wire [15:0] t_1_6_n_out, t_1_6_n_in;
  wire [15:0] t_1_6_e_out, t_1_6_e_in;
  wire [15:0] t_1_6_s_out, t_1_6_s_in;
  wire [15:0] t_1_6_w_out, t_1_6_w_in;
  wire [15:0] t_1_7_n_out, t_1_7_n_in;
  wire [15:0] t_1_7_e_out, t_1_7_e_in;
  wire [15:0] t_1_7_s_out, t_1_7_s_in;
  wire [15:0] t_1_7_w_out, t_1_7_w_in;
  wire [15:0] t_2_0_n_out, t_2_0_n_in;
  wire [15:0] t_2_0_e_out, t_2_0_e_in;
  wire [15:0] t_2_0_s_out, t_2_0_s_in;
  wire [15:0] t_2_0_w_out, t_2_0_w_in;
  wire [15:0] t_2_1_n_out, t_2_1_n_in;
  wire [15:0] t_2_1_e_out, t_2_1_e_in;
  wire [15:0] t_2_1_s_out, t_2_1_s_in;
  wire [15:0] t_2_1_w_out, t_2_1_w_in;
  wire [15:0] t_2_2_n_out, t_2_2_n_in;
  wire [15:0] t_2_2_e_out, t_2_2_e_in;
  wire [15:0] t_2_2_s_out, t_2_2_s_in;
  wire [15:0] t_2_2_w_out, t_2_2_w_in;
  wire [15:0] t_2_3_n_out, t_2_3_n_in;
  wire [15:0] t_2_3_e_out, t_2_3_e_in;
  wire [15:0] t_2_3_s_out, t_2_3_s_in;
  wire [15:0] t_2_3_w_out, t_2_3_w_in;
  wire [15:0] t_2_4_n_out, t_2_4_n_in;
  wire [15:0] t_2_4_e_out, t_2_4_e_in;
  wire [15:0] t_2_4_s_out, t_2_4_s_in;
  wire [15:0] t_2_4_w_out, t_2_4_w_in;
  wire [15:0] t_2_5_n_out, t_2_5_n_in;
  wire [15:0] t_2_5_e_out, t_2_5_e_in;
  wire [15:0] t_2_5_s_out, t_2_5_s_in;
  wire [15:0] t_2_5_w_out, t_2_5_w_in;
  wire [15:0] t_2_6_n_out, t_2_6_n_in;
  wire [15:0] t_2_6_e_out, t_2_6_e_in;
  wire [15:0] t_2_6_s_out, t_2_6_s_in;
  wire [15:0] t_2_6_w_out, t_2_6_w_in;
  wire [15:0] t_2_7_n_out, t_2_7_n_in;
  wire [15:0] t_2_7_e_out, t_2_7_e_in;
  wire [15:0] t_2_7_s_out, t_2_7_s_in;
  wire [15:0] t_2_7_w_out, t_2_7_w_in;
  wire [15:0] t_3_0_n_out, t_3_0_n_in;
  wire [15:0] t_3_0_e_out, t_3_0_e_in;
  wire [15:0] t_3_0_s_out, t_3_0_s_in;
  wire [15:0] t_3_0_w_out, t_3_0_w_in;
  wire [15:0] t_3_1_n_out, t_3_1_n_in;
  wire [15:0] t_3_1_e_out, t_3_1_e_in;
  wire [15:0] t_3_1_s_out, t_3_1_s_in;
  wire [15:0] t_3_1_w_out, t_3_1_w_in;
  wire [15:0] t_3_2_n_out, t_3_2_n_in;
  wire [15:0] t_3_2_e_out, t_3_2_e_in;
  wire [15:0] t_3_2_s_out, t_3_2_s_in;
  wire [15:0] t_3_2_w_out, t_3_2_w_in;
  wire [15:0] t_3_3_n_out, t_3_3_n_in;
  wire [15:0] t_3_3_e_out, t_3_3_e_in;
  wire [15:0] t_3_3_s_out, t_3_3_s_in;
  wire [15:0] t_3_3_w_out, t_3_3_w_in;
  wire [15:0] t_3_4_n_out, t_3_4_n_in;
  wire [15:0] t_3_4_e_out, t_3_4_e_in;
  wire [15:0] t_3_4_s_out, t_3_4_s_in;
  wire [15:0] t_3_4_w_out, t_3_4_w_in;
  wire [15:0] t_3_5_n_out, t_3_5_n_in;
  wire [15:0] t_3_5_e_out, t_3_5_e_in;
  wire [15:0] t_3_5_s_out, t_3_5_s_in;
  wire [15:0] t_3_5_w_out, t_3_5_w_in;
  wire [15:0] t_3_6_n_out, t_3_6_n_in;
  wire [15:0] t_3_6_e_out, t_3_6_e_in;
  wire [15:0] t_3_6_s_out, t_3_6_s_in;
  wire [15:0] t_3_6_w_out, t_3_6_w_in;
  wire [15:0] t_3_7_n_out, t_3_7_n_in;
  wire [15:0] t_3_7_e_out, t_3_7_e_in;
  wire [15:0] t_3_7_s_out, t_3_7_s_in;
  wire [15:0] t_3_7_w_out, t_3_7_w_in;
  wire [15:0] t_4_0_n_out, t_4_0_n_in;
  wire [15:0] t_4_0_e_out, t_4_0_e_in;
  wire [15:0] t_4_0_s_out, t_4_0_s_in;
  wire [15:0] t_4_0_w_out, t_4_0_w_in;
  wire [15:0] t_4_1_n_out, t_4_1_n_in;
  wire [15:0] t_4_1_e_out, t_4_1_e_in;
  wire [15:0] t_4_1_s_out, t_4_1_s_in;
  wire [15:0] t_4_1_w_out, t_4_1_w_in;
  wire [15:0] t_4_2_n_out, t_4_2_n_in;
  wire [15:0] t_4_2_e_out, t_4_2_e_in;
  wire [15:0] t_4_2_s_out, t_4_2_s_in;
  wire [15:0] t_4_2_w_out, t_4_2_w_in;
  wire [15:0] t_4_3_n_out, t_4_3_n_in;
  wire [15:0] t_4_3_e_out, t_4_3_e_in;
  wire [15:0] t_4_3_s_out, t_4_3_s_in;
  wire [15:0] t_4_3_w_out, t_4_3_w_in;
  wire [15:0] t_4_4_n_out, t_4_4_n_in;
  wire [15:0] t_4_4_e_out, t_4_4_e_in;
  wire [15:0] t_4_4_s_out, t_4_4_s_in;
  wire [15:0] t_4_4_w_out, t_4_4_w_in;
  wire [15:0] t_4_5_n_out, t_4_5_n_in;
  wire [15:0] t_4_5_e_out, t_4_5_e_in;
  wire [15:0] t_4_5_s_out, t_4_5_s_in;
  wire [15:0] t_4_5_w_out, t_4_5_w_in;
  wire [15:0] t_4_6_n_out, t_4_6_n_in;
  wire [15:0] t_4_6_e_out, t_4_6_e_in;
  wire [15:0] t_4_6_s_out, t_4_6_s_in;
  wire [15:0] t_4_6_w_out, t_4_6_w_in;
  wire [15:0] t_4_7_n_out, t_4_7_n_in;
  wire [15:0] t_4_7_e_out, t_4_7_e_in;
  wire [15:0] t_4_7_s_out, t_4_7_s_in;
  wire [15:0] t_4_7_w_out, t_4_7_w_in;
  wire [15:0] t_5_0_n_out, t_5_0_n_in;
  wire [15:0] t_5_0_e_out, t_5_0_e_in;
  wire [15:0] t_5_0_s_out, t_5_0_s_in;
  wire [15:0] t_5_0_w_out, t_5_0_w_in;
  wire [15:0] t_5_1_n_out, t_5_1_n_in;
  wire [15:0] t_5_1_e_out, t_5_1_e_in;
  wire [15:0] t_5_1_s_out, t_5_1_s_in;
  wire [15:0] t_5_1_w_out, t_5_1_w_in;
  wire [15:0] t_5_2_n_out, t_5_2_n_in;
  wire [15:0] t_5_2_e_out, t_5_2_e_in;
  wire [15:0] t_5_2_s_out, t_5_2_s_in;
  wire [15:0] t_5_2_w_out, t_5_2_w_in;
  wire [15:0] t_5_3_n_out, t_5_3_n_in;
  wire [15:0] t_5_3_e_out, t_5_3_e_in;
  wire [15:0] t_5_3_s_out, t_5_3_s_in;
  wire [15:0] t_5_3_w_out, t_5_3_w_in;
  wire [15:0] t_5_4_n_out, t_5_4_n_in;
  wire [15:0] t_5_4_e_out, t_5_4_e_in;
  wire [15:0] t_5_4_s_out, t_5_4_s_in;
  wire [15:0] t_5_4_w_out, t_5_4_w_in;
  wire [15:0] t_5_5_n_out, t_5_5_n_in;
  wire [15:0] t_5_5_e_out, t_5_5_e_in;
  wire [15:0] t_5_5_s_out, t_5_5_s_in;
  wire [15:0] t_5_5_w_out, t_5_5_w_in;
  wire [15:0] t_5_6_n_out, t_5_6_n_in;
  wire [15:0] t_5_6_e_out, t_5_6_e_in;
  wire [15:0] t_5_6_s_out, t_5_6_s_in;
  wire [15:0] t_5_6_w_out, t_5_6_w_in;
  wire [15:0] t_5_7_n_out, t_5_7_n_in;
  wire [15:0] t_5_7_e_out, t_5_7_e_in;
  wire [15:0] t_5_7_s_out, t_5_7_s_in;
  wire [15:0] t_5_7_w_out, t_5_7_w_in;
  wire [15:0] t_6_0_n_out, t_6_0_n_in;
  wire [15:0] t_6_0_e_out, t_6_0_e_in;
  wire [15:0] t_6_0_s_out, t_6_0_s_in;
  wire [15:0] t_6_0_w_out, t_6_0_w_in;
  wire [15:0] t_6_1_n_out, t_6_1_n_in;
  wire [15:0] t_6_1_e_out, t_6_1_e_in;
  wire [15:0] t_6_1_s_out, t_6_1_s_in;
  wire [15:0] t_6_1_w_out, t_6_1_w_in;
  wire [15:0] t_6_2_n_out, t_6_2_n_in;
  wire [15:0] t_6_2_e_out, t_6_2_e_in;
  wire [15:0] t_6_2_s_out, t_6_2_s_in;
  wire [15:0] t_6_2_w_out, t_6_2_w_in;
  wire [15:0] t_6_3_n_out, t_6_3_n_in;
  wire [15:0] t_6_3_e_out, t_6_3_e_in;
  wire [15:0] t_6_3_s_out, t_6_3_s_in;
  wire [15:0] t_6_3_w_out, t_6_3_w_in;
  wire [15:0] t_6_4_n_out, t_6_4_n_in;
  wire [15:0] t_6_4_e_out, t_6_4_e_in;
  wire [15:0] t_6_4_s_out, t_6_4_s_in;
  wire [15:0] t_6_4_w_out, t_6_4_w_in;
  wire [15:0] t_6_5_n_out, t_6_5_n_in;
  wire [15:0] t_6_5_e_out, t_6_5_e_in;
  wire [15:0] t_6_5_s_out, t_6_5_s_in;
  wire [15:0] t_6_5_w_out, t_6_5_w_in;
  wire [15:0] t_6_6_n_out, t_6_6_n_in;
  wire [15:0] t_6_6_e_out, t_6_6_e_in;
  wire [15:0] t_6_6_s_out, t_6_6_s_in;
  wire [15:0] t_6_6_w_out, t_6_6_w_in;
  wire [15:0] t_6_7_n_out, t_6_7_n_in;
  wire [15:0] t_6_7_e_out, t_6_7_e_in;
  wire [15:0] t_6_7_s_out, t_6_7_s_in;
  wire [15:0] t_6_7_w_out, t_6_7_w_in;
  wire [15:0] t_7_0_n_out, t_7_0_n_in;
  wire [15:0] t_7_0_e_out, t_7_0_e_in;
  wire [15:0] t_7_0_s_out, t_7_0_s_in;
  wire [15:0] t_7_0_w_out, t_7_0_w_in;
  wire [15:0] t_7_1_n_out, t_7_1_n_in;
  wire [15:0] t_7_1_e_out, t_7_1_e_in;
  wire [15:0] t_7_1_s_out, t_7_1_s_in;
  wire [15:0] t_7_1_w_out, t_7_1_w_in;
  wire [15:0] t_7_2_n_out, t_7_2_n_in;
  wire [15:0] t_7_2_e_out, t_7_2_e_in;
  wire [15:0] t_7_2_s_out, t_7_2_s_in;
  wire [15:0] t_7_2_w_out, t_7_2_w_in;
  wire [15:0] t_7_3_n_out, t_7_3_n_in;
  wire [15:0] t_7_3_e_out, t_7_3_e_in;
  wire [15:0] t_7_3_s_out, t_7_3_s_in;
  wire [15:0] t_7_3_w_out, t_7_3_w_in;
  wire [15:0] t_7_4_n_out, t_7_4_n_in;
  wire [15:0] t_7_4_e_out, t_7_4_e_in;
  wire [15:0] t_7_4_s_out, t_7_4_s_in;
  wire [15:0] t_7_4_w_out, t_7_4_w_in;
  wire [15:0] t_7_5_n_out, t_7_5_n_in;
  wire [15:0] t_7_5_e_out, t_7_5_e_in;
  wire [15:0] t_7_5_s_out, t_7_5_s_in;
  wire [15:0] t_7_5_w_out, t_7_5_w_in;
  wire [15:0] t_7_6_n_out, t_7_6_n_in;
  wire [15:0] t_7_6_e_out, t_7_6_e_in;
  wire [15:0] t_7_6_s_out, t_7_6_s_in;
  wire [15:0] t_7_6_w_out, t_7_6_w_in;
  wire [15:0] t_7_7_n_out, t_7_7_n_in;
  wire [15:0] t_7_7_e_out, t_7_7_e_in;
  wire [15:0] t_7_7_s_out, t_7_7_s_in;
  wire [15:0] t_7_7_w_out, t_7_7_w_in;

  // --- MESH LINKAGE & EDGE PINS ---
  assign t_0_0_e_in = t_0_1_w_out;
  assign t_0_1_w_in = t_0_0_e_out;
  assign t_0_0_w_in = io_west_in_0;
  assign io_west_out_0 = t_0_0_w_out;
  assign t_0_0_s_in = t_1_0_n_out;
  assign t_1_0_n_in = t_0_0_s_out;
  assign t_0_0_n_in = io_north_in_0;
  assign io_north_out_0 = t_0_0_n_out;
  assign t_0_1_e_in = t_0_2_w_out;
  assign t_0_2_w_in = t_0_1_e_out;
  assign t_0_1_s_in = t_1_1_n_out;
  assign t_1_1_n_in = t_0_1_s_out;
  assign t_0_1_n_in = io_north_in_1;
  assign io_north_out_1 = t_0_1_n_out;
  assign t_0_2_e_in = t_0_3_w_out;
  assign t_0_3_w_in = t_0_2_e_out;
  assign t_0_2_s_in = t_1_2_n_out;
  assign t_1_2_n_in = t_0_2_s_out;
  assign t_0_2_n_in = io_north_in_2;
  assign io_north_out_2 = t_0_2_n_out;
  assign t_0_3_e_in = t_0_4_w_out;
  assign t_0_4_w_in = t_0_3_e_out;
  assign t_0_3_s_in = t_1_3_n_out;
  assign t_1_3_n_in = t_0_3_s_out;
  assign t_0_3_n_in = io_north_in_3;
  assign io_north_out_3 = t_0_3_n_out;
  assign t_0_4_e_in = t_0_5_w_out;
  assign t_0_5_w_in = t_0_4_e_out;
  assign t_0_4_s_in = t_1_4_n_out;
  assign t_1_4_n_in = t_0_4_s_out;
  assign t_0_4_n_in = io_north_in_4;
  assign io_north_out_4 = t_0_4_n_out;
  assign t_0_5_e_in = t_0_6_w_out;
  assign t_0_6_w_in = t_0_5_e_out;
  assign t_0_5_s_in = t_1_5_n_out;
  assign t_1_5_n_in = t_0_5_s_out;
  assign t_0_5_n_in = io_north_in_5;
  assign io_north_out_5 = t_0_5_n_out;
  assign t_0_6_e_in = t_0_7_w_out;
  assign t_0_7_w_in = t_0_6_e_out;
  assign t_0_6_s_in = t_1_6_n_out;
  assign t_1_6_n_in = t_0_6_s_out;
  assign t_0_6_n_in = io_north_in_6;
  assign io_north_out_6 = t_0_6_n_out;
  assign t_0_7_e_in = io_east_in_0;
  assign io_east_out_0 = t_0_7_e_out;
  assign t_0_7_s_in = t_1_7_n_out;
  assign t_1_7_n_in = t_0_7_s_out;
  assign t_0_7_n_in = io_north_in_7;
  assign io_north_out_7 = t_0_7_n_out;
  assign t_1_0_e_in = t_1_1_w_out;
  assign t_1_1_w_in = t_1_0_e_out;
  assign t_1_0_w_in = io_west_in_1;
  assign io_west_out_1 = t_1_0_w_out;
  assign t_1_0_s_in = t_2_0_n_out;
  assign t_2_0_n_in = t_1_0_s_out;
  assign t_1_1_e_in = t_1_2_w_out;
  assign t_1_2_w_in = t_1_1_e_out;
  assign t_1_1_s_in = t_2_1_n_out;
  assign t_2_1_n_in = t_1_1_s_out;
  assign t_1_2_e_in = t_1_3_w_out;
  assign t_1_3_w_in = t_1_2_e_out;
  assign t_1_2_s_in = t_2_2_n_out;
  assign t_2_2_n_in = t_1_2_s_out;
  assign t_1_3_e_in = t_1_4_w_out;
  assign t_1_4_w_in = t_1_3_e_out;
  assign t_1_3_s_in = t_2_3_n_out;
  assign t_2_3_n_in = t_1_3_s_out;
  assign t_1_4_e_in = t_1_5_w_out;
  assign t_1_5_w_in = t_1_4_e_out;
  assign t_1_4_s_in = t_2_4_n_out;
  assign t_2_4_n_in = t_1_4_s_out;
  assign t_1_5_e_in = t_1_6_w_out;
  assign t_1_6_w_in = t_1_5_e_out;
  assign t_1_5_s_in = t_2_5_n_out;
  assign t_2_5_n_in = t_1_5_s_out;
  assign t_1_6_e_in = t_1_7_w_out;
  assign t_1_7_w_in = t_1_6_e_out;
  assign t_1_6_s_in = t_2_6_n_out;
  assign t_2_6_n_in = t_1_6_s_out;
  assign t_1_7_e_in = io_east_in_1;
  assign io_east_out_1 = t_1_7_e_out;
  assign t_1_7_s_in = t_2_7_n_out;
  assign t_2_7_n_in = t_1_7_s_out;
  assign t_2_0_e_in = t_2_1_w_out;
  assign t_2_1_w_in = t_2_0_e_out;
  assign t_2_0_w_in = io_west_in_2;
  assign io_west_out_2 = t_2_0_w_out;
  assign t_2_0_s_in = t_3_0_n_out;
  assign t_3_0_n_in = t_2_0_s_out;
  assign t_2_1_e_in = t_2_2_w_out;
  assign t_2_2_w_in = t_2_1_e_out;
  assign t_2_1_s_in = t_3_1_n_out;
  assign t_3_1_n_in = t_2_1_s_out;
  assign t_2_2_e_in = t_2_3_w_out;
  assign t_2_3_w_in = t_2_2_e_out;
  assign t_2_2_s_in = t_3_2_n_out;
  assign t_3_2_n_in = t_2_2_s_out;
  assign t_2_3_e_in = t_2_4_w_out;
  assign t_2_4_w_in = t_2_3_e_out;
  assign t_2_3_s_in = t_3_3_n_out;
  assign t_3_3_n_in = t_2_3_s_out;
  assign t_2_4_e_in = t_2_5_w_out;
  assign t_2_5_w_in = t_2_4_e_out;
  assign t_2_4_s_in = t_3_4_n_out;
  assign t_3_4_n_in = t_2_4_s_out;
  assign t_2_5_e_in = t_2_6_w_out;
  assign t_2_6_w_in = t_2_5_e_out;
  assign t_2_5_s_in = t_3_5_n_out;
  assign t_3_5_n_in = t_2_5_s_out;
  assign t_2_6_e_in = t_2_7_w_out;
  assign t_2_7_w_in = t_2_6_e_out;
  assign t_2_6_s_in = t_3_6_n_out;
  assign t_3_6_n_in = t_2_6_s_out;
  assign t_2_7_e_in = io_east_in_2;
  assign io_east_out_2 = t_2_7_e_out;
  assign t_2_7_s_in = t_3_7_n_out;
  assign t_3_7_n_in = t_2_7_s_out;
  assign t_3_0_e_in = t_3_1_w_out;
  assign t_3_1_w_in = t_3_0_e_out;
  assign t_3_0_w_in = io_west_in_3;
  assign io_west_out_3 = t_3_0_w_out;
  assign t_3_0_s_in = t_4_0_n_out;
  assign t_4_0_n_in = t_3_0_s_out;
  assign t_3_1_e_in = t_3_2_w_out;
  assign t_3_2_w_in = t_3_1_e_out;
  assign t_3_1_s_in = t_4_1_n_out;
  assign t_4_1_n_in = t_3_1_s_out;
  assign t_3_2_e_in = t_3_3_w_out;
  assign t_3_3_w_in = t_3_2_e_out;
  assign t_3_2_s_in = t_4_2_n_out;
  assign t_4_2_n_in = t_3_2_s_out;
  assign t_3_3_e_in = t_3_4_w_out;
  assign t_3_4_w_in = t_3_3_e_out;
  assign t_3_3_s_in = t_4_3_n_out;
  assign t_4_3_n_in = t_3_3_s_out;
  assign t_3_4_e_in = t_3_5_w_out;
  assign t_3_5_w_in = t_3_4_e_out;
  assign t_3_4_s_in = t_4_4_n_out;
  assign t_4_4_n_in = t_3_4_s_out;
  assign t_3_5_e_in = t_3_6_w_out;
  assign t_3_6_w_in = t_3_5_e_out;
  assign t_3_5_s_in = t_4_5_n_out;
  assign t_4_5_n_in = t_3_5_s_out;
  assign t_3_6_e_in = t_3_7_w_out;
  assign t_3_7_w_in = t_3_6_e_out;
  assign t_3_6_s_in = t_4_6_n_out;
  assign t_4_6_n_in = t_3_6_s_out;
  assign t_3_7_e_in = io_east_in_3;
  assign io_east_out_3 = t_3_7_e_out;
  assign t_3_7_s_in = t_4_7_n_out;
  assign t_4_7_n_in = t_3_7_s_out;
  assign t_4_0_e_in = t_4_1_w_out;
  assign t_4_1_w_in = t_4_0_e_out;
  assign t_4_0_w_in = io_west_in_4;
  assign io_west_out_4 = t_4_0_w_out;
  assign t_4_0_s_in = t_5_0_n_out;
  assign t_5_0_n_in = t_4_0_s_out;
  assign t_4_1_e_in = t_4_2_w_out;
  assign t_4_2_w_in = t_4_1_e_out;
  assign t_4_1_s_in = t_5_1_n_out;
  assign t_5_1_n_in = t_4_1_s_out;
  assign t_4_2_e_in = t_4_3_w_out;
  assign t_4_3_w_in = t_4_2_e_out;
  assign t_4_2_s_in = t_5_2_n_out;
  assign t_5_2_n_in = t_4_2_s_out;
  assign t_4_3_e_in = t_4_4_w_out;
  assign t_4_4_w_in = t_4_3_e_out;
  assign t_4_3_s_in = t_5_3_n_out;
  assign t_5_3_n_in = t_4_3_s_out;
  assign t_4_4_e_in = t_4_5_w_out;
  assign t_4_5_w_in = t_4_4_e_out;
  assign t_4_4_s_in = t_5_4_n_out;
  assign t_5_4_n_in = t_4_4_s_out;
  assign t_4_5_e_in = t_4_6_w_out;
  assign t_4_6_w_in = t_4_5_e_out;
  assign t_4_5_s_in = t_5_5_n_out;
  assign t_5_5_n_in = t_4_5_s_out;
  assign t_4_6_e_in = t_4_7_w_out;
  assign t_4_7_w_in = t_4_6_e_out;
  assign t_4_6_s_in = t_5_6_n_out;
  assign t_5_6_n_in = t_4_6_s_out;
  assign t_4_7_e_in = io_east_in_4;
  assign io_east_out_4 = t_4_7_e_out;
  assign t_4_7_s_in = t_5_7_n_out;
  assign t_5_7_n_in = t_4_7_s_out;
  assign t_5_0_e_in = t_5_1_w_out;
  assign t_5_1_w_in = t_5_0_e_out;
  assign t_5_0_w_in = io_west_in_5;
  assign io_west_out_5 = t_5_0_w_out;
  assign t_5_0_s_in = t_6_0_n_out;
  assign t_6_0_n_in = t_5_0_s_out;
  assign t_5_1_e_in = t_5_2_w_out;
  assign t_5_2_w_in = t_5_1_e_out;
  assign t_5_1_s_in = t_6_1_n_out;
  assign t_6_1_n_in = t_5_1_s_out;
  assign t_5_2_e_in = t_5_3_w_out;
  assign t_5_3_w_in = t_5_2_e_out;
  assign t_5_2_s_in = t_6_2_n_out;
  assign t_6_2_n_in = t_5_2_s_out;
  assign t_5_3_e_in = t_5_4_w_out;
  assign t_5_4_w_in = t_5_3_e_out;
  assign t_5_3_s_in = t_6_3_n_out;
  assign t_6_3_n_in = t_5_3_s_out;
  assign t_5_4_e_in = t_5_5_w_out;
  assign t_5_5_w_in = t_5_4_e_out;
  assign t_5_4_s_in = t_6_4_n_out;
  assign t_6_4_n_in = t_5_4_s_out;
  assign t_5_5_e_in = t_5_6_w_out;
  assign t_5_6_w_in = t_5_5_e_out;
  assign t_5_5_s_in = t_6_5_n_out;
  assign t_6_5_n_in = t_5_5_s_out;
  assign t_5_6_e_in = t_5_7_w_out;
  assign t_5_7_w_in = t_5_6_e_out;
  assign t_5_6_s_in = t_6_6_n_out;
  assign t_6_6_n_in = t_5_6_s_out;
  assign t_5_7_e_in = io_east_in_5;
  assign io_east_out_5 = t_5_7_e_out;
  assign t_5_7_s_in = t_6_7_n_out;
  assign t_6_7_n_in = t_5_7_s_out;
  assign t_6_0_e_in = t_6_1_w_out;
  assign t_6_1_w_in = t_6_0_e_out;
  assign t_6_0_w_in = io_west_in_6;
  assign io_west_out_6 = t_6_0_w_out;
  assign t_6_0_s_in = t_7_0_n_out;
  assign t_7_0_n_in = t_6_0_s_out;
  assign t_6_1_e_in = t_6_2_w_out;
  assign t_6_2_w_in = t_6_1_e_out;
  assign t_6_1_s_in = t_7_1_n_out;
  assign t_7_1_n_in = t_6_1_s_out;
  assign t_6_2_e_in = t_6_3_w_out;
  assign t_6_3_w_in = t_6_2_e_out;
  assign t_6_2_s_in = t_7_2_n_out;
  assign t_7_2_n_in = t_6_2_s_out;
  assign t_6_3_e_in = t_6_4_w_out;
  assign t_6_4_w_in = t_6_3_e_out;
  assign t_6_3_s_in = t_7_3_n_out;
  assign t_7_3_n_in = t_6_3_s_out;
  assign t_6_4_e_in = t_6_5_w_out;
  assign t_6_5_w_in = t_6_4_e_out;
  assign t_6_4_s_in = t_7_4_n_out;
  assign t_7_4_n_in = t_6_4_s_out;
  assign t_6_5_e_in = t_6_6_w_out;
  assign t_6_6_w_in = t_6_5_e_out;
  assign t_6_5_s_in = t_7_5_n_out;
  assign t_7_5_n_in = t_6_5_s_out;
  assign t_6_6_e_in = t_6_7_w_out;
  assign t_6_7_w_in = t_6_6_e_out;
  assign t_6_6_s_in = t_7_6_n_out;
  assign t_7_6_n_in = t_6_6_s_out;
  assign t_6_7_e_in = io_east_in_6;
  assign io_east_out_6 = t_6_7_e_out;
  assign t_6_7_s_in = t_7_7_n_out;
  assign t_7_7_n_in = t_6_7_s_out;
  assign t_7_0_e_in = t_7_1_w_out;
  assign t_7_1_w_in = t_7_0_e_out;
  assign t_7_0_w_in = io_west_in_7;
  assign io_west_out_7 = t_7_0_w_out;
  assign t_7_0_s_in = io_south_in_0;
  assign io_south_out_0 = t_7_0_s_out;
  assign t_7_1_e_in = t_7_2_w_out;
  assign t_7_2_w_in = t_7_1_e_out;
  assign t_7_1_s_in = io_south_in_1;
  assign io_south_out_1 = t_7_1_s_out;
  assign t_7_2_e_in = t_7_3_w_out;
  assign t_7_3_w_in = t_7_2_e_out;
  assign t_7_2_s_in = io_south_in_2;
  assign io_south_out_2 = t_7_2_s_out;
  assign t_7_3_e_in = t_7_4_w_out;
  assign t_7_4_w_in = t_7_3_e_out;
  assign t_7_3_s_in = io_south_in_3;
  assign io_south_out_3 = t_7_3_s_out;
  assign t_7_4_e_in = t_7_5_w_out;
  assign t_7_5_w_in = t_7_4_e_out;
  assign t_7_4_s_in = io_south_in_4;
  assign io_south_out_4 = t_7_4_s_out;
  assign t_7_5_e_in = t_7_6_w_out;
  assign t_7_6_w_in = t_7_5_e_out;
  assign t_7_5_s_in = io_south_in_5;
  assign io_south_out_5 = t_7_5_s_out;
  assign t_7_6_e_in = t_7_7_w_out;
  assign t_7_7_w_in = t_7_6_e_out;
  assign t_7_6_s_in = io_south_in_6;
  assign io_south_out_6 = t_7_6_s_out;
  assign t_7_7_e_in = io_east_in_7;
  assign io_east_out_7 = t_7_7_e_out;
  assign t_7_7_s_in = io_south_in_7;
  assign io_south_out_7 = t_7_7_s_out;

  // --- TILE INSTANTIATION ---
  sovryn_noc_router_hdc core_0_0 (
    .clk(clk), .rst_n(rst_n),
    .n_in(t_0_0_n_in), .n_out(t_0_0_n_out),
    .s_in(t_0_0_s_in), .s_out(t_0_0_s_out),
    .e_in(t_0_0_e_in), .e_out(t_0_0_e_out),
    .w_in(t_0_0_w_in), .w_out(t_0_0_w_out)
  );
  sovryn_noc_router_hdc core_0_1 (
    .clk(clk), .rst_n(rst_n),
    .n_in(t_0_1_n_in), .n_out(t_0_1_n_out),
    .s_in(t_0_1_s_in), .s_out(t_0_1_s_out),
    .e_in(t_0_1_e_in), .e_out(t_0_1_e_out),
    .w_in(t_0_1_w_in), .w_out(t_0_1_w_out)
  );
  sovryn_noc_router_hdc core_0_2 (
    .clk(clk), .rst_n(rst_n),
    .n_in(t_0_2_n_in), .n_out(t_0_2_n_out),
    .s_in(t_0_2_s_in), .s_out(t_0_2_s_out),
    .e_in(t_0_2_e_in), .e_out(t_0_2_e_out),
    .w_in(t_0_2_w_in), .w_out(t_0_2_w_out)
  );
  sovryn_noc_router_hdc core_0_3 (
    .clk(clk), .rst_n(rst_n),
    .n_in(t_0_3_n_in), .n_out(t_0_3_n_out),
    .s_in(t_0_3_s_in), .s_out(t_0_3_s_out),
    .e_in(t_0_3_e_in), .e_out(t_0_3_e_out),
    .w_in(t_0_3_w_in), .w_out(t_0_3_w_out)
  );
  sovryn_noc_router_hdc core_0_4 (
    .clk(clk), .rst_n(rst_n),
    .n_in(t_0_4_n_in), .n_out(t_0_4_n_out),
    .s_in(t_0_4_s_in), .s_out(t_0_4_s_out),
    .e_in(t_0_4_e_in), .e_out(t_0_4_e_out),
    .w_in(t_0_4_w_in), .w_out(t_0_4_w_out)
  );
  sovryn_noc_router_hdc core_0_5 (
    .clk(clk), .rst_n(rst_n),
    .n_in(t_0_5_n_in), .n_out(t_0_5_n_out),
    .s_in(t_0_5_s_in), .s_out(t_0_5_s_out),
    .e_in(t_0_5_e_in), .e_out(t_0_5_e_out),
    .w_in(t_0_5_w_in), .w_out(t_0_5_w_out)
  );
  sovryn_noc_router_hdc core_0_6 (
    .clk(clk), .rst_n(rst_n),
    .n_in(t_0_6_n_in), .n_out(t_0_6_n_out),
    .s_in(t_0_6_s_in), .s_out(t_0_6_s_out),
    .e_in(t_0_6_e_in), .e_out(t_0_6_e_out),
    .w_in(t_0_6_w_in), .w_out(t_0_6_w_out)
  );
  sovryn_noc_router_hdc core_0_7 (
    .clk(clk), .rst_n(rst_n),
    .n_in(t_0_7_n_in), .n_out(t_0_7_n_out),
    .s_in(t_0_7_s_in), .s_out(t_0_7_s_out),
    .e_in(t_0_7_e_in), .e_out(t_0_7_e_out),
    .w_in(t_0_7_w_in), .w_out(t_0_7_w_out)
  );
  sovryn_noc_router_hdc core_1_0 (
    .clk(clk), .rst_n(rst_n),
    .n_in(t_1_0_n_in), .n_out(t_1_0_n_out),
    .s_in(t_1_0_s_in), .s_out(t_1_0_s_out),
    .e_in(t_1_0_e_in), .e_out(t_1_0_e_out),
    .w_in(t_1_0_w_in), .w_out(t_1_0_w_out)
  );
  sovryn_noc_router_hdc core_1_1 (
    .clk(clk), .rst_n(rst_n),
    .n_in(t_1_1_n_in), .n_out(t_1_1_n_out),
    .s_in(t_1_1_s_in), .s_out(t_1_1_s_out),
    .e_in(t_1_1_e_in), .e_out(t_1_1_e_out),
    .w_in(t_1_1_w_in), .w_out(t_1_1_w_out)
  );
  sovryn_noc_router_mamba core_1_2 (
    .clk(clk), .rst_n(rst_n),
    .n_in(t_1_2_n_in), .n_out(t_1_2_n_out),
    .s_in(t_1_2_s_in), .s_out(t_1_2_s_out),
    .e_in(t_1_2_e_in), .e_out(t_1_2_e_out),
    .w_in(t_1_2_w_in), .w_out(t_1_2_w_out)
  );
  sovryn_noc_router_mamba core_1_3 (
    .clk(clk), .rst_n(rst_n),
    .n_in(t_1_3_n_in), .n_out(t_1_3_n_out),
    .s_in(t_1_3_s_in), .s_out(t_1_3_s_out),
    .e_in(t_1_3_e_in), .e_out(t_1_3_e_out),
    .w_in(t_1_3_w_in), .w_out(t_1_3_w_out)
  );
  sovryn_noc_router_mamba core_1_4 (
    .clk(clk), .rst_n(rst_n),
    .n_in(t_1_4_n_in), .n_out(t_1_4_n_out),
    .s_in(t_1_4_s_in), .s_out(t_1_4_s_out),
    .e_in(t_1_4_e_in), .e_out(t_1_4_e_out),
    .w_in(t_1_4_w_in), .w_out(t_1_4_w_out)
  );
  sovryn_noc_router_mamba core_1_5 (
    .clk(clk), .rst_n(rst_n),
    .n_in(t_1_5_n_in), .n_out(t_1_5_n_out),
    .s_in(t_1_5_s_in), .s_out(t_1_5_s_out),
    .e_in(t_1_5_e_in), .e_out(t_1_5_e_out),
    .w_in(t_1_5_w_in), .w_out(t_1_5_w_out)
  );
  sovryn_noc_router_hdc core_1_6 (
    .clk(clk), .rst_n(rst_n),
    .n_in(t_1_6_n_in), .n_out(t_1_6_n_out),
    .s_in(t_1_6_s_in), .s_out(t_1_6_s_out),
    .e_in(t_1_6_e_in), .e_out(t_1_6_e_out),
    .w_in(t_1_6_w_in), .w_out(t_1_6_w_out)
  );
  sovryn_noc_router_hdc core_1_7 (
    .clk(clk), .rst_n(rst_n),
    .n_in(t_1_7_n_in), .n_out(t_1_7_n_out),
    .s_in(t_1_7_s_in), .s_out(t_1_7_s_out),
    .e_in(t_1_7_e_in), .e_out(t_1_7_e_out),
    .w_in(t_1_7_w_in), .w_out(t_1_7_w_out)
  );
  sovryn_noc_router_hdc core_2_0 (
    .clk(clk), .rst_n(rst_n),
    .n_in(t_2_0_n_in), .n_out(t_2_0_n_out),
    .s_in(t_2_0_s_in), .s_out(t_2_0_s_out),
    .e_in(t_2_0_e_in), .e_out(t_2_0_e_out),
    .w_in(t_2_0_w_in), .w_out(t_2_0_w_out)
  );
  sovryn_noc_router_hdc core_2_1 (
    .clk(clk), .rst_n(rst_n),
    .n_in(t_2_1_n_in), .n_out(t_2_1_n_out),
    .s_in(t_2_1_s_in), .s_out(t_2_1_s_out),
    .e_in(t_2_1_e_in), .e_out(t_2_1_e_out),
    .w_in(t_2_1_w_in), .w_out(t_2_1_w_out)
  );
  sovryn_noc_router_mamba core_2_2 (
    .clk(clk), .rst_n(rst_n),
    .n_in(t_2_2_n_in), .n_out(t_2_2_n_out),
    .s_in(t_2_2_s_in), .s_out(t_2_2_s_out),
    .e_in(t_2_2_e_in), .e_out(t_2_2_e_out),
    .w_in(t_2_2_w_in), .w_out(t_2_2_w_out)
  );
  sovryn_noc_router_transformer core_2_3 (
    .clk(clk), .rst_n(rst_n),
    .n_in(t_2_3_n_in), .n_out(t_2_3_n_out),
    .s_in(t_2_3_s_in), .s_out(t_2_3_s_out),
    .e_in(t_2_3_e_in), .e_out(t_2_3_e_out),
    .w_in(t_2_3_w_in), .w_out(t_2_3_w_out)
  );
  sovryn_noc_router_transformer core_2_4 (
    .clk(clk), .rst_n(rst_n),
    .n_in(t_2_4_n_in), .n_out(t_2_4_n_out),
    .s_in(t_2_4_s_in), .s_out(t_2_4_s_out),
    .e_in(t_2_4_e_in), .e_out(t_2_4_e_out),
    .w_in(t_2_4_w_in), .w_out(t_2_4_w_out)
  );
  sovryn_noc_router_mamba core_2_5 (
    .clk(clk), .rst_n(rst_n),
    .n_in(t_2_5_n_in), .n_out(t_2_5_n_out),
    .s_in(t_2_5_s_in), .s_out(t_2_5_s_out),
    .e_in(t_2_5_e_in), .e_out(t_2_5_e_out),
    .w_in(t_2_5_w_in), .w_out(t_2_5_w_out)
  );
  sovryn_noc_router_hdc core_2_6 (
    .clk(clk), .rst_n(rst_n),
    .n_in(t_2_6_n_in), .n_out(t_2_6_n_out),
    .s_in(t_2_6_s_in), .s_out(t_2_6_s_out),
    .e_in(t_2_6_e_in), .e_out(t_2_6_e_out),
    .w_in(t_2_6_w_in), .w_out(t_2_6_w_out)
  );
  sovryn_noc_router_hdc core_2_7 (
    .clk(clk), .rst_n(rst_n),
    .n_in(t_2_7_n_in), .n_out(t_2_7_n_out),
    .s_in(t_2_7_s_in), .s_out(t_2_7_s_out),
    .e_in(t_2_7_e_in), .e_out(t_2_7_e_out),
    .w_in(t_2_7_w_in), .w_out(t_2_7_w_out)
  );
  sovryn_noc_router_hdc core_3_0 (
    .clk(clk), .rst_n(rst_n),
    .n_in(t_3_0_n_in), .n_out(t_3_0_n_out),
    .s_in(t_3_0_s_in), .s_out(t_3_0_s_out),
    .e_in(t_3_0_e_in), .e_out(t_3_0_e_out),
    .w_in(t_3_0_w_in), .w_out(t_3_0_w_out)
  );
  sovryn_noc_router_hdc core_3_1 (
    .clk(clk), .rst_n(rst_n),
    .n_in(t_3_1_n_in), .n_out(t_3_1_n_out),
    .s_in(t_3_1_s_in), .s_out(t_3_1_s_out),
    .e_in(t_3_1_e_in), .e_out(t_3_1_e_out),
    .w_in(t_3_1_w_in), .w_out(t_3_1_w_out)
  );
  sovryn_noc_router_mamba core_3_2 (
    .clk(clk), .rst_n(rst_n),
    .n_in(t_3_2_n_in), .n_out(t_3_2_n_out),
    .s_in(t_3_2_s_in), .s_out(t_3_2_s_out),
    .e_in(t_3_2_e_in), .e_out(t_3_2_e_out),
    .w_in(t_3_2_w_in), .w_out(t_3_2_w_out)
  );
  sovryn_noc_router_transformer core_3_3 (
    .clk(clk), .rst_n(rst_n),
    .n_in(t_3_3_n_in), .n_out(t_3_3_n_out),
    .s_in(t_3_3_s_in), .s_out(t_3_3_s_out),
    .e_in(t_3_3_e_in), .e_out(t_3_3_e_out),
    .w_in(t_3_3_w_in), .w_out(t_3_3_w_out)
  );
  sovryn_noc_router_transformer core_3_4 (
    .clk(clk), .rst_n(rst_n),
    .n_in(t_3_4_n_in), .n_out(t_3_4_n_out),
    .s_in(t_3_4_s_in), .s_out(t_3_4_s_out),
    .e_in(t_3_4_e_in), .e_out(t_3_4_e_out),
    .w_in(t_3_4_w_in), .w_out(t_3_4_w_out)
  );
  sovryn_noc_router_mamba core_3_5 (
    .clk(clk), .rst_n(rst_n),
    .n_in(t_3_5_n_in), .n_out(t_3_5_n_out),
    .s_in(t_3_5_s_in), .s_out(t_3_5_s_out),
    .e_in(t_3_5_e_in), .e_out(t_3_5_e_out),
    .w_in(t_3_5_w_in), .w_out(t_3_5_w_out)
  );
  sovryn_noc_router_hdc core_3_6 (
    .clk(clk), .rst_n(rst_n),
    .n_in(t_3_6_n_in), .n_out(t_3_6_n_out),
    .s_in(t_3_6_s_in), .s_out(t_3_6_s_out),
    .e_in(t_3_6_e_in), .e_out(t_3_6_e_out),
    .w_in(t_3_6_w_in), .w_out(t_3_6_w_out)
  );
  sovryn_noc_router_hdc core_3_7 (
    .clk(clk), .rst_n(rst_n),
    .n_in(t_3_7_n_in), .n_out(t_3_7_n_out),
    .s_in(t_3_7_s_in), .s_out(t_3_7_s_out),
    .e_in(t_3_7_e_in), .e_out(t_3_7_e_out),
    .w_in(t_3_7_w_in), .w_out(t_3_7_w_out)
  );
  sovryn_noc_router_mamba core_4_0 (
    .clk(clk), .rst_n(rst_n),
    .n_in(t_4_0_n_in), .n_out(t_4_0_n_out),
    .s_in(t_4_0_s_in), .s_out(t_4_0_s_out),
    .e_in(t_4_0_e_in), .e_out(t_4_0_e_out),
    .w_in(t_4_0_w_in), .w_out(t_4_0_w_out)
  );
  sovryn_noc_router_mamba core_4_1 (
    .clk(clk), .rst_n(rst_n),
    .n_in(t_4_1_n_in), .n_out(t_4_1_n_out),
    .s_in(t_4_1_s_in), .s_out(t_4_1_s_out),
    .e_in(t_4_1_e_in), .e_out(t_4_1_e_out),
    .w_in(t_4_1_w_in), .w_out(t_4_1_w_out)
  );
  sovryn_noc_router_transformer core_4_2 (
    .clk(clk), .rst_n(rst_n),
    .n_in(t_4_2_n_in), .n_out(t_4_2_n_out),
    .s_in(t_4_2_s_in), .s_out(t_4_2_s_out),
    .e_in(t_4_2_e_in), .e_out(t_4_2_e_out),
    .w_in(t_4_2_w_in), .w_out(t_4_2_w_out)
  );
  sovryn_noc_router_kan core_4_3 (
    .clk(clk), .rst_n(rst_n),
    .n_in(t_4_3_n_in), .n_out(t_4_3_n_out),
    .s_in(t_4_3_s_in), .s_out(t_4_3_s_out),
    .e_in(t_4_3_e_in), .e_out(t_4_3_e_out),
    .w_in(t_4_3_w_in), .w_out(t_4_3_w_out)
  );
  sovryn_noc_router_kan core_4_4 (
    .clk(clk), .rst_n(rst_n),
    .n_in(t_4_4_n_in), .n_out(t_4_4_n_out),
    .s_in(t_4_4_s_in), .s_out(t_4_4_s_out),
    .e_in(t_4_4_e_in), .e_out(t_4_4_e_out),
    .w_in(t_4_4_w_in), .w_out(t_4_4_w_out)
  );
  sovryn_noc_router_transformer core_4_5 (
    .clk(clk), .rst_n(rst_n),
    .n_in(t_4_5_n_in), .n_out(t_4_5_n_out),
    .s_in(t_4_5_s_in), .s_out(t_4_5_s_out),
    .e_in(t_4_5_e_in), .e_out(t_4_5_e_out),
    .w_in(t_4_5_w_in), .w_out(t_4_5_w_out)
  );
  sovryn_noc_router_mamba core_4_6 (
    .clk(clk), .rst_n(rst_n),
    .n_in(t_4_6_n_in), .n_out(t_4_6_n_out),
    .s_in(t_4_6_s_in), .s_out(t_4_6_s_out),
    .e_in(t_4_6_e_in), .e_out(t_4_6_e_out),
    .w_in(t_4_6_w_in), .w_out(t_4_6_w_out)
  );
  sovryn_noc_router_mamba core_4_7 (
    .clk(clk), .rst_n(rst_n),
    .n_in(t_4_7_n_in), .n_out(t_4_7_n_out),
    .s_in(t_4_7_s_in), .s_out(t_4_7_s_out),
    .e_in(t_4_7_e_in), .e_out(t_4_7_e_out),
    .w_in(t_4_7_w_in), .w_out(t_4_7_w_out)
  );
  sovryn_noc_router_mamba core_5_0 (
    .clk(clk), .rst_n(rst_n),
    .n_in(t_5_0_n_in), .n_out(t_5_0_n_out),
    .s_in(t_5_0_s_in), .s_out(t_5_0_s_out),
    .e_in(t_5_0_e_in), .e_out(t_5_0_e_out),
    .w_in(t_5_0_w_in), .w_out(t_5_0_w_out)
  );
  sovryn_noc_router_mamba core_5_1 (
    .clk(clk), .rst_n(rst_n),
    .n_in(t_5_1_n_in), .n_out(t_5_1_n_out),
    .s_in(t_5_1_s_in), .s_out(t_5_1_s_out),
    .e_in(t_5_1_e_in), .e_out(t_5_1_e_out),
    .w_in(t_5_1_w_in), .w_out(t_5_1_w_out)
  );
  sovryn_noc_router_transformer core_5_2 (
    .clk(clk), .rst_n(rst_n),
    .n_in(t_5_2_n_in), .n_out(t_5_2_n_out),
    .s_in(t_5_2_s_in), .s_out(t_5_2_s_out),
    .e_in(t_5_2_e_in), .e_out(t_5_2_e_out),
    .w_in(t_5_2_w_in), .w_out(t_5_2_w_out)
  );
  sovryn_noc_router_kan core_5_3 (
    .clk(clk), .rst_n(rst_n),
    .n_in(t_5_3_n_in), .n_out(t_5_3_n_out),
    .s_in(t_5_3_s_in), .s_out(t_5_3_s_out),
    .e_in(t_5_3_e_in), .e_out(t_5_3_e_out),
    .w_in(t_5_3_w_in), .w_out(t_5_3_w_out)
  );
  sovryn_noc_router_kan core_5_4 (
    .clk(clk), .rst_n(rst_n),
    .n_in(t_5_4_n_in), .n_out(t_5_4_n_out),
    .s_in(t_5_4_s_in), .s_out(t_5_4_s_out),
    .e_in(t_5_4_e_in), .e_out(t_5_4_e_out),
    .w_in(t_5_4_w_in), .w_out(t_5_4_w_out)
  );
  sovryn_noc_router_transformer core_5_5 (
    .clk(clk), .rst_n(rst_n),
    .n_in(t_5_5_n_in), .n_out(t_5_5_n_out),
    .s_in(t_5_5_s_in), .s_out(t_5_5_s_out),
    .e_in(t_5_5_e_in), .e_out(t_5_5_e_out),
    .w_in(t_5_5_w_in), .w_out(t_5_5_w_out)
  );
  sovryn_noc_router_mamba core_5_6 (
    .clk(clk), .rst_n(rst_n),
    .n_in(t_5_6_n_in), .n_out(t_5_6_n_out),
    .s_in(t_5_6_s_in), .s_out(t_5_6_s_out),
    .e_in(t_5_6_e_in), .e_out(t_5_6_e_out),
    .w_in(t_5_6_w_in), .w_out(t_5_6_w_out)
  );
  sovryn_noc_router_mamba core_5_7 (
    .clk(clk), .rst_n(rst_n),
    .n_in(t_5_7_n_in), .n_out(t_5_7_n_out),
    .s_in(t_5_7_s_in), .s_out(t_5_7_s_out),
    .e_in(t_5_7_e_in), .e_out(t_5_7_e_out),
    .w_in(t_5_7_w_in), .w_out(t_5_7_w_out)
  );
  sovryn_noc_router_transformer core_6_0 (
    .clk(clk), .rst_n(rst_n),
    .n_in(t_6_0_n_in), .n_out(t_6_0_n_out),
    .s_in(t_6_0_s_in), .s_out(t_6_0_s_out),
    .e_in(t_6_0_e_in), .e_out(t_6_0_e_out),
    .w_in(t_6_0_w_in), .w_out(t_6_0_w_out)
  );
  sovryn_noc_router_transformer core_6_1 (
    .clk(clk), .rst_n(rst_n),
    .n_in(t_6_1_n_in), .n_out(t_6_1_n_out),
    .s_in(t_6_1_s_in), .s_out(t_6_1_s_out),
    .e_in(t_6_1_e_in), .e_out(t_6_1_e_out),
    .w_in(t_6_1_w_in), .w_out(t_6_1_w_out)
  );
  sovryn_noc_router_transformer core_6_2 (
    .clk(clk), .rst_n(rst_n),
    .n_in(t_6_2_n_in), .n_out(t_6_2_n_out),
    .s_in(t_6_2_s_in), .s_out(t_6_2_s_out),
    .e_in(t_6_2_e_in), .e_out(t_6_2_e_out),
    .w_in(t_6_2_w_in), .w_out(t_6_2_w_out)
  );
  sovryn_noc_router_transformer core_6_3 (
    .clk(clk), .rst_n(rst_n),
    .n_in(t_6_3_n_in), .n_out(t_6_3_n_out),
    .s_in(t_6_3_s_in), .s_out(t_6_3_s_out),
    .e_in(t_6_3_e_in), .e_out(t_6_3_e_out),
    .w_in(t_6_3_w_in), .w_out(t_6_3_w_out)
  );
  sovryn_noc_router_transformer core_6_4 (
    .clk(clk), .rst_n(rst_n),
    .n_in(t_6_4_n_in), .n_out(t_6_4_n_out),
    .s_in(t_6_4_s_in), .s_out(t_6_4_s_out),
    .e_in(t_6_4_e_in), .e_out(t_6_4_e_out),
    .w_in(t_6_4_w_in), .w_out(t_6_4_w_out)
  );
  sovryn_noc_router_transformer core_6_5 (
    .clk(clk), .rst_n(rst_n),
    .n_in(t_6_5_n_in), .n_out(t_6_5_n_out),
    .s_in(t_6_5_s_in), .s_out(t_6_5_s_out),
    .e_in(t_6_5_e_in), .e_out(t_6_5_e_out),
    .w_in(t_6_5_w_in), .w_out(t_6_5_w_out)
  );
  sovryn_noc_router_transformer core_6_6 (
    .clk(clk), .rst_n(rst_n),
    .n_in(t_6_6_n_in), .n_out(t_6_6_n_out),
    .s_in(t_6_6_s_in), .s_out(t_6_6_s_out),
    .e_in(t_6_6_e_in), .e_out(t_6_6_e_out),
    .w_in(t_6_6_w_in), .w_out(t_6_6_w_out)
  );
  sovryn_noc_router_transformer core_6_7 (
    .clk(clk), .rst_n(rst_n),
    .n_in(t_6_7_n_in), .n_out(t_6_7_n_out),
    .s_in(t_6_7_s_in), .s_out(t_6_7_s_out),
    .e_in(t_6_7_e_in), .e_out(t_6_7_e_out),
    .w_in(t_6_7_w_in), .w_out(t_6_7_w_out)
  );
  sovryn_noc_router_transformer core_7_0 (
    .clk(clk), .rst_n(rst_n),
    .n_in(t_7_0_n_in), .n_out(t_7_0_n_out),
    .s_in(t_7_0_s_in), .s_out(t_7_0_s_out),
    .e_in(t_7_0_e_in), .e_out(t_7_0_e_out),
    .w_in(t_7_0_w_in), .w_out(t_7_0_w_out)
  );
  sovryn_noc_router_transformer core_7_1 (
    .clk(clk), .rst_n(rst_n),
    .n_in(t_7_1_n_in), .n_out(t_7_1_n_out),
    .s_in(t_7_1_s_in), .s_out(t_7_1_s_out),
    .e_in(t_7_1_e_in), .e_out(t_7_1_e_out),
    .w_in(t_7_1_w_in), .w_out(t_7_1_w_out)
  );
  sovryn_noc_router_kan core_7_2 (
    .clk(clk), .rst_n(rst_n),
    .n_in(t_7_2_n_in), .n_out(t_7_2_n_out),
    .s_in(t_7_2_s_in), .s_out(t_7_2_s_out),
    .e_in(t_7_2_e_in), .e_out(t_7_2_e_out),
    .w_in(t_7_2_w_in), .w_out(t_7_2_w_out)
  );
  sovryn_noc_router_kan core_7_3 (
    .clk(clk), .rst_n(rst_n),
    .n_in(t_7_3_n_in), .n_out(t_7_3_n_out),
    .s_in(t_7_3_s_in), .s_out(t_7_3_s_out),
    .e_in(t_7_3_e_in), .e_out(t_7_3_e_out),
    .w_in(t_7_3_w_in), .w_out(t_7_3_w_out)
  );
  sovryn_noc_router_kan core_7_4 (
    .clk(clk), .rst_n(rst_n),
    .n_in(t_7_4_n_in), .n_out(t_7_4_n_out),
    .s_in(t_7_4_s_in), .s_out(t_7_4_s_out),
    .e_in(t_7_4_e_in), .e_out(t_7_4_e_out),
    .w_in(t_7_4_w_in), .w_out(t_7_4_w_out)
  );
  sovryn_noc_router_kan core_7_5 (
    .clk(clk), .rst_n(rst_n),
    .n_in(t_7_5_n_in), .n_out(t_7_5_n_out),
    .s_in(t_7_5_s_in), .s_out(t_7_5_s_out),
    .e_in(t_7_5_e_in), .e_out(t_7_5_e_out),
    .w_in(t_7_5_w_in), .w_out(t_7_5_w_out)
  );
  sovryn_noc_router_transformer core_7_6 (
    .clk(clk), .rst_n(rst_n),
    .n_in(t_7_6_n_in), .n_out(t_7_6_n_out),
    .s_in(t_7_6_s_in), .s_out(t_7_6_s_out),
    .e_in(t_7_6_e_in), .e_out(t_7_6_e_out),
    .w_in(t_7_6_w_in), .w_out(t_7_6_w_out)
  );
  sovryn_noc_router_transformer core_7_7 (
    .clk(clk), .rst_n(rst_n),
    .n_in(t_7_7_n_in), .n_out(t_7_7_n_out),
    .s_in(t_7_7_s_in), .s_out(t_7_7_s_out),
    .e_in(t_7_7_e_in), .e_out(t_7_7_e_out),
    .w_in(t_7_7_w_in), .w_out(t_7_7_w_out)
  );
endmodule
