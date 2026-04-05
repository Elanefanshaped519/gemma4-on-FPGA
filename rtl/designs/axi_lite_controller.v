`timescale 1ns/1ps

module axi_lite_controller (
    (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME s_axi_aclk, ASSOCIATED_BUSIF S_AXI, ASSOCIATED_RESET s_axi_aresetn" *)
    (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 s_axi_aclk CLK" *)
    input  wire         s_axi_aclk,

    (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME s_axi_aresetn, POLARITY ACTIVE_LOW" *)
    (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 s_axi_aresetn RST" *)
    input  wire         s_axi_aresetn,

    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI AWADDR" *)
    (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME S_AXI, PROTOCOL AXI4LITE, ADDR_WIDTH 32, DATA_WIDTH 32, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, READ_WRITE_MODE READ_WRITE" *)
    input  wire [31:0]  s_axi_awaddr,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI AWVALID" *)
    input  wire         s_axi_awvalid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI AWREADY" *)
    output reg          s_axi_awready,

    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI WDATA" *)
    input  wire [31:0]  s_axi_wdata,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI WSTRB" *)
    input  wire [3:0]   s_axi_wstrb,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI WVALID" *)
    input  wire         s_axi_wvalid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI WREADY" *)
    output reg          s_axi_wready,

    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI BRESP" *)
    output reg [1:0]    s_axi_bresp,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI BVALID" *)
    output reg          s_axi_bvalid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI BREADY" *)
    input  wire         s_axi_bready,

    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI ARADDR" *)
    input  wire [31:0]  s_axi_araddr,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI ARVALID" *)
    input  wire         s_axi_arvalid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI ARREADY" *)
    output reg          s_axi_arready,

    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI RDATA" *)
    output reg [31:0]   s_axi_rdata,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI RRESP" *)
    output reg [1:0]    s_axi_rresp,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI RVALID" *)
    output reg          s_axi_rvalid,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI RREADY" *)
    input  wire         s_axi_rready,

    output wire [7:0]   ext_irq_npu_trigger
);

    reg [31:0] mmio_awaddr_reg;
    reg [31:0] mmio_wdata_reg;
    reg        mmio_awvalid_pulse;
    reg        mmio_wvalid_pulse;
    reg        read_pending;
    wire       write_fire;

    wire [31:0] mmio_rdata_wire;
    wire        mmio_rvalid_wire;
    assign write_fire = (!s_axi_bvalid) && s_axi_awvalid && s_axi_wvalid;

    function [31:0] apply_wstrb32;
        input [31:0] previous;
        input [31:0] wdata;
        input [3:0]  wstrb;
        begin
            apply_wstrb32 = previous;
            if (wstrb[0]) apply_wstrb32[7:0]   = wdata[7:0];
            if (wstrb[1]) apply_wstrb32[15:8]  = wdata[15:8];
            if (wstrb[2]) apply_wstrb32[23:16] = wdata[23:16];
            if (wstrb[3]) apply_wstrb32[31:24] = wdata[31:24];
        end
    endfunction

    sovryn_pan_stem_npu_array_64core_hub_top hub_top (
        .sys_clk(s_axi_aclk),
        .sys_rst_n(s_axi_aresetn),
        .mmio_awaddr(mmio_awaddr_reg),
        .mmio_awvalid(mmio_awvalid_pulse),
        .mmio_awready(),
        .mmio_wdata(mmio_wdata_reg),
        .mmio_wvalid(mmio_wvalid_pulse),
        .mmio_wready(),
        .mmio_rdata(mmio_rdata_wire),
        .mmio_rvalid(mmio_rvalid_wire),
        .ext_irq_npu_trigger(ext_irq_npu_trigger)
    );

    always @(posedge s_axi_aclk) begin
        if (!s_axi_aresetn) begin
            s_axi_awready      <= 1'b1;
            s_axi_wready       <= 1'b1;
            s_axi_bresp        <= 2'b00;
            s_axi_bvalid       <= 1'b0;
            s_axi_arready      <= 1'b1;
            s_axi_rdata        <= 32'h0000_0000;
            s_axi_rresp        <= 2'b00;
            s_axi_rvalid       <= 1'b0;
            mmio_awaddr_reg    <= 32'h0000_0000;
            mmio_wdata_reg     <= 32'h0000_0000;
            mmio_awvalid_pulse <= 1'b0;
            mmio_wvalid_pulse  <= 1'b0;
            read_pending       <= 1'b0;
        end else begin
            mmio_awvalid_pulse <= 1'b0;
            mmio_wvalid_pulse  <= 1'b0;

            // AXI-Lite write path (single outstanding transaction).
            if (write_fire) begin
                mmio_awaddr_reg    <= s_axi_awaddr;
                mmio_wdata_reg     <= apply_wstrb32(32'h0000_0000, s_axi_wdata, s_axi_wstrb);
                mmio_awvalid_pulse <= 1'b1;
                mmio_wvalid_pulse  <= 1'b1;
                s_axi_bresp        <= 2'b00;
                s_axi_bvalid       <= 1'b1;
            end else if (s_axi_bvalid && s_axi_bready) begin
                s_axi_bvalid <= 1'b0;
            end

            s_axi_awready <= !s_axi_bvalid;
            s_axi_wready  <= !s_axi_bvalid;

            // AXI-Lite read path (single outstanding transaction, one-cycle data return).
            if (!s_axi_rvalid && !read_pending && !write_fire && s_axi_arvalid) begin
                mmio_awaddr_reg <= s_axi_araddr;
                read_pending    <= 1'b1;
            end

            if (read_pending) begin
                s_axi_rdata  <= mmio_rdata_wire;
                s_axi_rresp  <= 2'b00;
                s_axi_rvalid <= 1'b1;
                read_pending <= 1'b0;
            end else if (s_axi_rvalid && s_axi_rready) begin
                s_axi_rvalid <= 1'b0;
            end

            s_axi_arready <= (!s_axi_rvalid) && (!read_pending) && (!write_fire);
        end
    end

endmodule
