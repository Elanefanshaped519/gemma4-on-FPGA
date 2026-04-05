(* keep_hierarchy = "yes" *)
module sovryn_pan_stem_npu_cluster_v3_top(
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
  wire tile0_request_valid;
  wire tile1_request_valid;
  wire [2:0] tile0_request_opcode;
  wire [2:0] tile1_request_opcode;
  wire [3:0] tile0_request_addr;
  wire [3:0] tile1_request_addr;
  wire [15:0] tile0_request_data;
  wire [15:0] tile1_request_data;
  wire [31:0] tile0_read_data;
  wire [31:0] tile1_read_data;
  wire fabric_valid;
  wire [2:0] fabric_route_port;
  wire [31:0] fabric_read_data;

  sovryn_pan_stem_npu_dispatch_ingress ingress (
    .clk(clk),
    .rst_n(rst_n),
    .dispatch_valid(dispatch_valid),
    .dispatch_opcode(dispatch_opcode),
    .dispatch_dest_tile(dispatch_dest_node),
    .dispatch_addr(dispatch_addr),
    .dispatch_data(dispatch_data),
    .tile0_request_valid(tile0_request_valid),
    .tile1_request_valid(tile1_request_valid),
    .tile0_request_opcode(tile0_request_opcode),
    .tile1_request_opcode(tile1_request_opcode),
    .tile0_request_addr(tile0_request_addr),
    .tile1_request_addr(tile1_request_addr),
    .tile0_request_data(tile0_request_data),
    .tile1_request_data(tile1_request_data)
  );

  sovryn_pan_stem_npu_bank_tile tile0 (
    .clk(clk),
    .rst_n(rst_n),
    .request_valid(tile0_request_valid),
    .request_opcode(tile0_request_opcode),
    .request_addr(tile0_request_addr),
    .request_data(tile0_request_data),
    .read_addr(read_addr),
    .read_data(tile0_read_data)
  );

  sovryn_pan_stem_npu_bank_tile tile1 (
    .clk(clk),
    .rst_n(rst_n),
    .request_valid(tile1_request_valid),
    .request_opcode(tile1_request_opcode),
    .request_addr(tile1_request_addr),
    .request_data(tile1_request_data),
    .read_addr(read_addr),
    .read_data(tile1_read_data)
  );

  sovryn_pan_stem_npu_readback_fabric readback (
    .clk(clk),
    .rst_n(rst_n),
    .read_valid(read_valid),
    .read_tile(read_node),
    .tile0_read_data(tile0_read_data),
    .tile1_read_data(tile1_read_data),
    .fabric_valid(fabric_valid),
    .fabric_route_port(fabric_route_port),
    .fabric_read_data(fabric_read_data)
  );

  always @(posedge clk) begin
    if (!rst_n) begin
      out_valid <= 1'b0;
      route_port <= 3'd0;
      read_data <= 32'd0;
    end else begin
      out_valid <= dispatch_valid || fabric_valid;
      if (dispatch_valid) begin
        route_port <= dispatch_dest_node ? 3'd1 : 3'd0;
      end else if (fabric_valid) begin
        route_port <= fabric_route_port;
      end

      if (fabric_valid) begin
        read_data <= fabric_read_data;
      end
    end
  end
`endif
endmodule
