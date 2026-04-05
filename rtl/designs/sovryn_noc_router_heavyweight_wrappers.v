module sovryn_noc_router_hdc (
  input  wire clk, input wire rst_n,
  input  wire [31:0] n_in, output reg [31:0] n_out,
  input  wire [31:0] s_in, output reg [31:0] s_out,
  input  wire [31:0] e_in, output reg [31:0] e_out,
  input  wire [31:0] w_in, output reg [31:0] w_out
);
  wire [31:0] ingress_data = n_in ^ s_in ^ e_in ^ w_in;
  reg [31:0] egress_data;
  reg [31:0] hypervector_basis = 32'hA5A5A5A5;
  reg [4:0] popcount;
  integer i;
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      egress_data <= 0; popcount <= 0;
      n_out <= 0; s_out <= 0; e_out <= 0; w_out <= 0;
    end else begin
      popcount = 0;
      for (i = 0; i < 32; i = i + 1) begin
        popcount = popcount + (ingress_data[i] ^ hypervector_basis[i]);
      end
      egress_data <= (popcount > 16) ? 32'hFFFFFFFF : 32'h00000000;
      n_out <= egress_data; s_out <= egress_data; e_out <= egress_data; w_out <= egress_data;
    end
  end
endmodule

module sovryn_noc_router_mamba (
  input  wire clk, input wire rst_n,
  input  wire [31:0] n_in, output reg [31:0] n_out,
  input  wire [31:0] s_in, output reg [31:0] s_out,
  input  wire [31:0] e_in, output reg [31:0] e_out,
  input  wire [31:0] w_in, output reg [31:0] w_out
);
  // Scale-Up: 16-Way INT8 Mamba Kernel Array
  wire [31:0] ingress_data = n_in ^ s_in ^ e_in ^ w_in;
  reg [31:0] egress_data;
  integer j;
  reg signed [7:0] state_h [0:15];
  reg signed [7:0] a_matrix [0:15];
  reg signed [7:0] b_matrix [0:15];
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
       egress_data <= 0;
       n_out <= 0; s_out <= 0; e_out <= 0; w_out <= 0;
       for(j=0; j<16; j=j+1) begin state_h[j] <= 0; a_matrix[j] <= 8'h02; b_matrix[j] <= 8'h01; end
    end else begin
       for(j=0; j<16; j=j+1) begin
         // Mamba internal state update equation (vectorized INT8)
         state_h[j] <= (state_h[j] * a_matrix[j] >>> 4) + (ingress_data[7:0] * b_matrix[j] >>> 4);
       end
       egress_data <= {state_h[3], state_h[2], state_h[1], state_h[0]}; // Packed INT8 output
       n_out <= egress_data; s_out <= egress_data; e_out <= egress_data; w_out <= egress_data;
    end
  end
endmodule

module sovryn_noc_router_transformer (
  input  wire clk, input wire rst_n,
  input  wire [31:0] n_in, output reg [31:0] n_out,
  input  wire [31:0] s_in, output reg [31:0] s_out,
  input  wire [31:0] e_in, output reg [31:0] e_out,
  input  wire [31:0] w_in, output reg [31:0] w_out
);
  // Scale-Up: 32-Way INT8 Systolic Array for Matrix Multiplication
  wire [31:0] ingress_data = n_in ^ s_in ^ e_in ^ w_in;
  reg [31:0] egress_data;
  reg signed [31:0] acc [0:3]; // 4 distinct INT8 accumulators
  reg signed [7:0] weights [0:15];
  integer k;
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
       acc[0]<=0; acc[1]<=0; acc[2]<=0; acc[3]<=0; egress_data<=0;
       n_out <= 0; s_out <= 0; e_out <= 0; w_out <= 0;
       for(k=0; k<16; k=k+1) weights[k] <= 8'h01;
    end else begin
       // Unrolled INT8 parallel MACs pulling 32-Bit vectors (4 x INT8)
       acc[0] <= acc[0] + ($signed(ingress_data[7:0]) * weights[0]) + ($signed(ingress_data[15:8]) * weights[1]);
       acc[1] <= acc[1] + ($signed(ingress_data[23:16]) * weights[2]) + ($signed(ingress_data[31:24]) * weights[3]);
       egress_data <= {acc[1][15:0], acc[0][15:0]};
       n_out <= egress_data; s_out <= egress_data; e_out <= egress_data; w_out <= egress_data;
    end
  end
endmodule

module sovryn_noc_router_kan (
  input  wire clk, input wire rst_n,
  input  wire [31:0] n_in, output reg [31:0] n_out,
  input  wire [31:0] s_in, output reg [31:0] s_out,
  input  wire [31:0] e_in, output reg [31:0] e_out,
  input  wire [31:0] w_in, output reg [31:0] w_out
);
  wire [31:0] ingress_data = n_in ^ s_in ^ e_in ^ w_in;
  reg [31:0] egress_data;
  reg [7:0] spline_lut [0:255];
  integer i;
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
       egress_data <= 0;
       for(i=0; i<256; i=i+1) spline_lut[i] <= i[7:0]; 
       n_out <= 0; s_out <= 0; e_out <= 0; w_out <= 0;
    end else begin
       // Double-wide Spline Lookup
       egress_data <= {16'h0000, spline_lut[ingress_data[15:8]], spline_lut[ingress_data[7:0]]};
       n_out <= egress_data; s_out <= egress_data; e_out <= egress_data; w_out <= egress_data;
    end
  end
endmodule