(* keep_hierarchy = "yes" *)
module sovryn_pan_stem_npu_readback_mux(
  input wire read_node,
  input wire [31:0] node0_read_data,
  input wire [31:0] node1_read_data,
  output wire [31:0] selected_read_data
);
  assign selected_read_data = read_node ? node1_read_data : node0_read_data;
endmodule
