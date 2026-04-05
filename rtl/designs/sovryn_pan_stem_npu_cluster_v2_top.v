(* keep_hierarchy = "yes" *)
module sovryn_pan_stem_npu_cluster_v2_top(
  input wire clk,
  input wire rst_n,
  input wire dispatch_valid,
  input wire [2:0] dispatch_opcode,
  input wire dispatch_dest_node,
  input wire [3:0] dispatch_addr,
  input wire [15:0] dispatch_data,
  input wire read_valid,
  input wire read_node,
  input wire [3:0] read_addr,
  output reg out_valid,
  output reg [2:0] route_port,
  output reg [31:0] read_data
);
`ifdef SOVRYN_FORMAL_ABSTRACT
  always @(posedge clk) begin
    if (!rst_n) begin
      out_valid <= 1'b0;
      route_port <= 3'd0;
      read_data <= 32'd0;
    end else begin
      out_valid <= dispatch_valid || read_valid;
      if (dispatch_valid) begin
        route_port <= dispatch_dest_node ? 3'd1 : 3'd0;
      end else if (read_valid) begin
        route_port <= read_node ? 3'd1 : 3'd0;
      end
      read_data <= 32'd0;
    end
  end
`else
  wire node0_request_valid;
  wire node1_request_valid;
  wire [2:0] node0_request_opcode;
  wire [2:0] node1_request_opcode;
  wire [3:0] node0_request_addr;
  wire [3:0] node1_request_addr;
  wire [15:0] node0_request_data;
  wire [15:0] node1_request_data;
  wire [2:0] dispatch_route_port;
  wire [31:0] node0_read_data;
  wire [31:0] node1_read_data;
  wire [31:0] selected_read_data;

  sovryn_pan_stem_npu_dispatch_router dispatch_router (
    .dispatch_valid(dispatch_valid),
    .dispatch_opcode(dispatch_opcode),
    .dispatch_dest_node(dispatch_dest_node),
    .dispatch_addr(dispatch_addr),
    .dispatch_data(dispatch_data),
    .node0_request_valid(node0_request_valid),
    .node1_request_valid(node1_request_valid),
    .node0_request_opcode(node0_request_opcode),
    .node1_request_opcode(node1_request_opcode),
    .node0_request_addr(node0_request_addr),
    .node1_request_addr(node1_request_addr),
    .node0_request_data(node0_request_data),
    .node1_request_data(node1_request_data),
    .dispatch_route_port(dispatch_route_port)
  );

  sovryn_pan_stem_npu_bank_cluster node0_cluster (
    .clk(clk),
    .rst_n(rst_n),
    .request_valid(node0_request_valid),
    .request_opcode(node0_request_opcode),
    .request_addr(node0_request_addr),
    .request_data(node0_request_data),
    .read_valid(read_valid && !read_node),
    .read_addr(read_addr),
    .read_data(node0_read_data)
  );

  sovryn_pan_stem_npu_bank_cluster node1_cluster (
    .clk(clk),
    .rst_n(rst_n),
    .request_valid(node1_request_valid),
    .request_opcode(node1_request_opcode),
    .request_addr(node1_request_addr),
    .request_data(node1_request_data),
    .read_valid(read_valid && read_node),
    .read_addr(read_addr),
    .read_data(node1_read_data)
  );

  sovryn_pan_stem_npu_readback_mux readback_mux (
    .read_node(read_node),
    .node0_read_data(node0_read_data),
    .node1_read_data(node1_read_data),
    .selected_read_data(selected_read_data)
  );

  always @(posedge clk) begin
    if (!rst_n) begin
      out_valid <= 1'b0;
      route_port <= 3'd0;
      read_data <= 32'd0;
    end else begin
      out_valid <= dispatch_valid || read_valid;
      if (dispatch_valid) begin
        route_port <= dispatch_route_port;
      end else if (read_valid) begin
        route_port <= read_node ? 3'd1 : 3'd0;
      end

      if (read_valid) begin
        read_data <= selected_read_data;
      end
    end
  end
`endif
endmodule
