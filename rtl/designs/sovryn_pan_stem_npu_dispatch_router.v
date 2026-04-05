(* keep_hierarchy = "yes" *)
module sovryn_pan_stem_npu_dispatch_router(
  input wire dispatch_valid,
  input wire [2:0] dispatch_opcode,
  input wire dispatch_dest_node,
  input wire [3:0] dispatch_addr,
  input wire [15:0] dispatch_data,
  output wire node0_request_valid,
  output wire node1_request_valid,
  output wire [2:0] node0_request_opcode,
  output wire [2:0] node1_request_opcode,
  output wire [3:0] node0_request_addr,
  output wire [3:0] node1_request_addr,
  output wire [15:0] node0_request_data,
  output wire [15:0] node1_request_data,
  output wire [2:0] dispatch_route_port
);
  assign node0_request_valid = dispatch_valid && !dispatch_dest_node;
  assign node1_request_valid = dispatch_valid && dispatch_dest_node;
  assign node0_request_opcode = dispatch_opcode;
  assign node1_request_opcode = dispatch_opcode;
  assign node0_request_addr = dispatch_addr;
  assign node1_request_addr = dispatch_addr;
  assign node0_request_data = dispatch_data;
  assign node1_request_data = dispatch_data;
  assign dispatch_route_port = dispatch_dest_node ? 3'd1 : 3'd0;
endmodule
