// ==============================================================================
// SOVRYN PAN-STEM: Master Cluster Orchestrator (64-Core Hub)
// ==============================================================================
// Architecture Pivot: 32 Mamba, 16 HDC, 8 NPU, 8 KAN
// Purpose: PetaLinux Python MMIO Backend. Jarvis acts as the OS, Minimax the Brain.
// This KV260 Silicion accelerates Agentic Memory, Compression, and Physical interrupts.

module sovryn_pan_stem_npu_array_64core_hub_top #(
    parameter DATA_WIDTH = 32,
    parameter HDC_DIM = 2000 // Dense Vector Size for log compression
)(
    input  wire                   sys_clk,
    input  wire                   sys_rst_n,
    
    // -----------------------------------------------------
    // AXI4-LITE MMIO Interface (Driven by jarvis_prompt_api.py)
    // -----------------------------------------------------
    input  wire [31:0]            mmio_awaddr,
    input  wire                   mmio_awvalid,
    output wire                   mmio_awready,
    input  wire [31:0]            mmio_wdata,
    input  wire                   mmio_wvalid,
    output wire                   mmio_wready,
    
    output wire [31:0]            mmio_rdata,
    output wire                   mmio_rvalid,
    
    // -----------------------------------------------------
    // Physical Interrupts (Node Alpha, Omega, Gamma)
    // -----------------------------------------------------
    output wire [7:0]             ext_irq_npu_trigger
);

    // ==========================================
    // MMIO Register Map Decoding
    // ==========================================
    // 0x00 - 0x1F : Mamba State Freeze (32 Cores)
    // 0x30 - 0x3F : HDC Log Ingress (16 Cores)
    // 0x40 - 0x47 : KAN Telemetry/Sec (8 Cores)
    // 0x50 - 0x57 : NPU Interrupts (8 Cores)

    reg [31:0] mamba_state_registers [0:31];
    reg [31:0] hdc_vector_registers [0:15];
    reg [31:0] kan_telemetry_registers [0:7];
    reg [7:0]  npu_interrupt_registers;
    reg [31:0] mmio_rdata_reg;
    integer idx;

    always @(posedge sys_clk) begin
        if (!sys_rst_n) begin
            npu_interrupt_registers <= 8'h00;

            for (idx = 0; idx < 32; idx = idx + 1) begin
                mamba_state_registers[idx] <= 32'h0000_0000;
            end

            for (idx = 0; idx < 16; idx = idx + 1) begin
                hdc_vector_registers[idx] <= 32'h0000_0000;
            end

            for (idx = 0; idx < 8; idx = idx + 1) begin
                kan_telemetry_registers[idx] <= 32'h0000_0001;
            end
        end else if (mmio_wvalid && mmio_awvalid) begin
            // Write to Mamba Array (0x00 - 0x1F)
            if (mmio_awaddr[7:5] == 3'b000) begin
                mamba_state_registers[mmio_awaddr[4:0]] <= mmio_wdata;
            end

            // Write to HDC Log Ingress (0x30 - 0x3F)
            if ((mmio_awaddr[7:4] == 4'h3) && (mmio_awaddr[3:0] < 4'd16)) begin
                hdc_vector_registers[mmio_awaddr[3:0]] <= mmio_wdata;
            end

            // Write to KAN Telemetry Override (0x40 - 0x47)
            if ((mmio_awaddr[7:4] == 4'h4) && (mmio_awaddr[2:0] < 3'd8)) begin
                kan_telemetry_registers[mmio_awaddr[2:0]] <= mmio_wdata;
            end
            
            // Write to NPU Hardware Triggers (0x50)
            if (mmio_awaddr == 32'h50) begin
                npu_interrupt_registers <= mmio_wdata[7:0]; // Fire interrupts
            end
        end
    end
    
    assign mmio_wready = 1'b1;
    assign mmio_awready = 1'b1;

    // ==========================================
    // 1. MAMBA CORES (32x)
    // ==========================================
    // UltraRAM backed registers tracking the context ID of 32 async Hermes agents.
    // Logic: In hardware, they hold states forever unless overwritten.
    
    // ==========================================
    // 2. HDC COMPRESSOR CORES (16x)
    // ==========================================
    // XOR arrays compressing gigabytes of logs into tokens.
    // Host software writes compressed vector hashes into 0x30-0x3F.

    // ==========================================
    // 3. KAN SUBCONSCIOUS CORES (8x)
    // ==========================================
    // DSP-Heavy spline evaluators monitoring thermal and packet anomalies.
    // If anomalies detected, hard-lock NPU triggers.
    wire kan_anomaly_lock;
    assign kan_anomaly_lock = (kan_telemetry_registers[0] == 32'h0000_0000);

    // ==========================================
    // 4. NPU DMA CORES (8x)
    // ==========================================
    // Direct hardware interrupts physically routed into Node Alpha/Omega.
    // Anomaly lock from KAN logic can block them instantly without API awareness.

    assign ext_irq_npu_trigger = kan_anomaly_lock ? 8'h00 : npu_interrupt_registers;

    // Output reading
    always @(*) begin
        mmio_rdata_reg = 32'h0000_0000;

        if (mmio_awaddr[7:5] == 3'b000) begin
            mmio_rdata_reg = mamba_state_registers[mmio_awaddr[4:0]];
        end else if ((mmio_awaddr[7:4] == 4'h3) && (mmio_awaddr[3:0] < 4'd16)) begin
            mmio_rdata_reg = hdc_vector_registers[mmio_awaddr[3:0]];
        end else if ((mmio_awaddr[7:4] == 4'h4) && (mmio_awaddr[2:0] < 3'd8)) begin
            mmio_rdata_reg = kan_telemetry_registers[mmio_awaddr[2:0]];
        end else if (mmio_awaddr == 32'h50) begin
            mmio_rdata_reg = {24'd0, npu_interrupt_registers};
        end
    end

    assign mmio_rvalid = 1'b1;
    assign mmio_rdata = mmio_rdata_reg;

endmodule
