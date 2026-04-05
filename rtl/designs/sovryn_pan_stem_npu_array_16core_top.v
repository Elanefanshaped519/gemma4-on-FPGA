// ==============================================================================
// SOVRYN PAN-STEM: Cluster Orchestrator 16-Core Top Wrapper
// ==============================================================================
// Architecture Pivot: 8 Mamba, 4 NPU, 2 HDC, 2 KAN
// Purpose: Master Controller Hub delegating to Node Alpha (Inference),
// Node Omega (Z3 SMT Verification), and Node Gamma (Ingress/Web).

module sovryn_pan_stem_npu_array_16core_top #(
    parameter DATA_WIDTH = 8,
    parameter PARAM_WIDTH = 8,
    parameter HDC_DIM = 1000
)(
    input  wire                   clk,
    input  wire                   reset,
    
    // Ingress from Node Gamma (Web / Ops)
    input  wire [DATA_WIDTH-1:0]  gamma_stream_in,
    input  wire                   gamma_valid,
    
    // Ingress from Node Alpha (Creative Thoughts / Code)
    input  wire [DATA_WIDTH-1:0]  alpha_stream_in,
    input  wire                   alpha_valid,
    
    // Output Interfaces via NPU Routing Hub
    output wire [DATA_WIDTH-1:0]  dispatch_to_alpha_out,
    output wire                   dispatch_to_alpha_valid,
    
    output wire [DATA_WIDTH-1:0]  dispatch_to_omega_out,
    output wire                   dispatch_to_omega_valid,
    
    output wire [DATA_WIDTH-1:0]  dispatch_to_gamma_out,
    output wire                   dispatch_to_gamma_valid
);

    // ==========================================
    // 1. HDC ENCODING (2 Cores)
    // ==========================================
    // Compresses chaotic incoming telemetry from Gamma
    wire [HDC_DIM-1:0] hdc_vector;
    
    sovryn_hdc_hyperdimensional_encoder #(
        .DIMENSIONS(HDC_DIM)
    ) hdc_core_island (
        .clk(clk),
        .reset(reset),
        .data_in(gamma_stream_in),
        .valid_in(gamma_valid),
        .hdc_out(hdc_vector)
    );

    // ==========================================
    // 2. KAN DISPATCH INTELLIGENCE (2 Cores)
    // ==========================================
    // Heavily reduced. Only calculates routing complexity (Who gets what task?)
    wire [DATA_WIDTH-1:0] kan_stimulus_f_x;
    
    sovryn_kan_spline_cluster #(
        .CORE_COUNT(2), // Scaled down for Orchestrator Mode
        .DATA_WIDTH(DATA_WIDTH)
    ) kan_array_island (
        .clk(clk),
        .reset(reset),
        .vector_in(hdc_vector),
        .stimulus_out(kan_stimulus_f_x)
    );

    // ==========================================
    // 3. THE SWARM MUX & LNN (State Management)
    // ==========================================
    // Swarm now handles Network States instead of personalities
    
    wire [PARAM_WIDTH-1:0] tau_alpha = 8'd10;  reg [PARAM_WIDTH-1:0] leak_alpha = 8'd1;  
    wire [PARAM_WIDTH-1:0] tau_omega = 8'd2;   reg [PARAM_WIDTH-1:0] leak_omega = 8'd5;  
    wire [PARAM_WIDTH-1:0] tau_gamma = 8'd50;  reg [PARAM_WIDTH-1:0] leak_gamma = 8'd0;  
    
    wire [1:0] swarm_state; // Defines current cluster focal context
    wire [PARAM_WIDTH-1:0] active_tau;
    wire [PARAM_WIDTH-1:0] active_leak;

    sovryn_pan_stem_swarm_multiplexer #(
        .DATA_WIDTH(DATA_WIDTH),
        .PARAM_WIDTH(PARAM_WIDTH)
    ) swarm_mux (
        .clk(clk),
        .reset(reset),
        .tau_thinker(tau_alpha), 
        .tau_critic(tau_omega),  
        .tau_coder(tau_gamma),   
        .leak_thinker(leak_alpha),
        .leak_critic(leak_omega),
        .leak_coder(leak_gamma),
        .agent_select(swarm_state), 
        .active_tau(active_tau),
        .active_leak(active_leak)
    );

    wire [DATA_WIDTH-1:0] lnn_ode_result;

    sovryn_pan_stem_npu_liquid_ode_solver #(
        .DATA_WIDTH(DATA_WIDTH)
    ) liquid_ode_engine (
        .clk(clk),
        .reset(reset),
        .f_x_in(kan_stimulus_f_x),     
        .tau_in(active_tau),           
        .delta_t(8'd1),                
        .ode_out(lnn_ode_result)
    );

    // ==========================================
    // 4. MICRO-DPLL AIRLOCK / FIREWALL
    // ==========================================
    // Fast-fail boolean check *before* waking up Node Omega's 256GB RAM
    
    wire dpll_panic_interrupt;

    sovryn_pan_stem_micro_dpll_solver dpll_watchdog (
        .clk(clk),
        .reset(reset),
        // Only trigger DPLL check when Swarm intends to delegate a massive proof to Omega
        .evaluate_trigger(swarm_state == 2'b01), 
        .clause_matrix({(128*64*2){1'b0}}),       
        .is_busy(),
        .is_sat(),
        .is_unsat(dpll_panic_interrupt), // PANIC if Node Alpha proposed trivial logic flaw
        .sat_assignment()
    );

    // ==========================================
    // 5. MAMBA STATE CLUSTER MEMORY (8 Cores)
    // ==========================================
    // Massive capability to remember state across Alpha, Omega, and Gamma async processes.
    
    reg [DATA_WIDTH-1:0] mamba_memory_bus [0:7]; // Doubled capacity
    
    always @(posedge clk) begin
        if (reset) begin
            mamba_memory_bus[0] <= 8'd0;
            mamba_memory_bus[1] <= 8'd0;
            mamba_memory_bus[2] <= 8'd0;
            mamba_memory_bus[3] <= 8'd0;
            mamba_memory_bus[4] <= 8'd0;
            mamba_memory_bus[5] <= 8'd0;
            mamba_memory_bus[6] <= 8'd0;
            mamba_memory_bus[7] <= 8'd0;
        end else if (!dpll_panic_interrupt) begin
            mamba_memory_bus[0] <= lnn_ode_result;
            mamba_memory_bus[1] <= mamba_memory_bus[0];
            mamba_memory_bus[2] <= mamba_memory_bus[1];
            mamba_memory_bus[3] <= mamba_memory_bus[2];
            mamba_memory_bus[4] <= mamba_memory_bus[3];
            mamba_memory_bus[5] <= mamba_memory_bus[4];
            mamba_memory_bus[6] <= mamba_memory_bus[5];
            mamba_memory_bus[7] <= mamba_memory_bus[6];
        end
    end

    // ==========================================
    // 6. NPU DATAPATH (4 Cores)
    // ==========================================
    // Multi-way routing capability required to handle the star topology.
    
    // If DPLL finds a flaw, we bounce it back to Alpha, not to Omega.
    assign dispatch_to_alpha_out = (dpll_panic_interrupt) ? mamba_memory_bus[7] : 8'd0;
    assign dispatch_to_alpha_valid = dpll_panic_interrupt;

    assign dispatch_to_omega_out = (!dpll_panic_interrupt && swarm_state == 2'b01) ? mamba_memory_bus[7] : 8'd0;
    assign dispatch_to_omega_valid = (!dpll_panic_interrupt && swarm_state == 2'b01);

    assign dispatch_to_gamma_out = (swarm_state == 2'b10) ? mamba_memory_bus[7] : 8'd0;
    assign dispatch_to_gamma_valid = (swarm_state == 2'b10);

endmodule
