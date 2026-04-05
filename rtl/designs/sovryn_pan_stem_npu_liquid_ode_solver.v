// Sovryn Liquid Time-Constant (LTC) ODE Solver
// Integration method: Forward Euler
// Solves: dx/dt = -x/tau + f(x, I)
// Engineered for deterministic hardware execution without Z3 divergence

module sovryn_pan_stem_npu_liquid_ode_solver #(
    parameter DATA_WIDTH = 8,  // INT8 highly recommended over INT4 for ODE stability
    parameter FRAC_WIDTH = 4   // Fixed-point fractional space
)(
    input  wire                   clk,
    input  wire                   reset,
    input  wire                   enable,
    
    // Time parameter
    input  wire [DATA_WIDTH-1:0]  delta_t,      // The liquid delta time (dt)
    
    // Liquid network physical parameters
    input  wire [DATA_WIDTH-1:0]  tau_inv,      // (1 / tau) precalculated decay rate
    input  wire [DATA_WIDTH-1:0]  synapse_f,    // f(x, I) the non-linear synapse output from KAN
    
    // State machine
    input  wire [DATA_WIDTH-1:0]  x_current,    // Pre-integration state 
    output reg  [DATA_WIDTH-1:0]  x_next        // Post-integration routed output
);

    localparam MULT_WIDTH = DATA_WIDTH * 2;
    
    wire signed [DATA_WIDTH-1:0] signed_x       = x_current;
    wire signed [DATA_WIDTH-1:0] signed_tau_inv = tau_inv;
    wire signed [DATA_WIDTH-1:0] signed_dt      = delta_t;
    wire signed [DATA_WIDTH-1:0] signed_f       = synapse_f;
    
    // 1. Compute ODE inner derivative: (-x * 1/tau) + f(x, I)
    // Multiplication produces double-width tensor, requires fixed-point right-shift to normalize
    wire signed [MULT_WIDTH-1:0] decay_mult_raw = -signed_x * signed_tau_inv;
    wire signed [DATA_WIDTH-1:0] decay_normalized = decay_mult_raw[DATA_WIDTH+FRAC_WIDTH-1 : FRAC_WIDTH];
    
    wire signed [DATA_WIDTH-1:0] derivative = decay_normalized + signed_f;
    
    // 2. Forward Euler Accumulation: x(t) = x(t-1) + (dx/dt * dt)
    wire signed [MULT_WIDTH-1:0] dt_mult_raw = derivative * signed_dt;
    wire signed [DATA_WIDTH-1:0] accum_step = dt_mult_raw[DATA_WIDTH+FRAC_WIDTH-1 : FRAC_WIDTH];
    
    wire signed [DATA_WIDTH-1:0] integration_result = signed_x + accum_step;
    
    always @(posedge clk) begin
        if (reset) begin
            x_next <= {DATA_WIDTH{1'b0}};
        end else if (enable) begin
            // Feed into the Liquid Register
            x_next <= integration_result;
        end
    end

endmodule
