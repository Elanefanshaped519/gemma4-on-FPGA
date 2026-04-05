// Sovryn Cognitive Reactor: Swarm Hardware Multiplexer
// Enables sub-nanosecond context switching between three distinct LNN agent personalities.
// Feeds the active parameter registers directly into the Liquid ODE Solver pipeline.

module sovryn_pan_stem_swarm_multiplexer #(
    parameter DATA_WIDTH = 8,
    parameter PARAM_WIDTH = 8
)(
    input  wire                   clk,
    input  wire                   reset,
    
    // Agent State Caches (Typically mapped to physical URAM limits)
    input  wire [PARAM_WIDTH-1:0] tau_thinker,
    input  wire [PARAM_WIDTH-1:0] tau_critic,
    input  wire [PARAM_WIDTH-1:0] tau_coder,
    
    input  wire [PARAM_WIDTH-1:0] leak_thinker,
    input  wire [PARAM_WIDTH-1:0] leak_critic,
    input  wire [PARAM_WIDTH-1:0] leak_coder,
    
    // Swarm Control Logic (Driven by the KAN scheduling matrix)
    input  wire [1:0]             agent_select, // 00=Thinker, 01=Critic, 10=Coder
    
    // Output dynamically bound to the liquid_ode_solver
    output reg  [PARAM_WIDTH-1:0] active_tau,
    output reg  [PARAM_WIDTH-1:0] active_leak
);

    always @(posedge clk) begin
        if (reset) begin
            active_tau  <= {PARAM_WIDTH{1'b0}};
            active_leak <= {PARAM_WIDTH{1'b0}};
        end else begin
            case (agent_select)
                2'b00: begin
                    // State: Creative Generation
                    active_tau  <= tau_thinker;
                    active_leak <= leak_thinker;
                end
                2'b01: begin
                    // State: SMT Validation / Adversarial Evaluation
                    active_tau  <= tau_critic;
                    active_leak <= leak_critic;
                end
                2'b10: begin
                    // State: Syntax Translation / Coding
                    active_tau  <= tau_coder;
                    active_leak <= leak_coder;
                end
                default: begin
                    // Fallback to absolute strict (Critic)
                    active_tau  <= tau_critic;
                    active_leak <= leak_critic;
                end
            endcase
        end
    end

endmodule
