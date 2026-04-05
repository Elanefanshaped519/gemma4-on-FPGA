module sovryn_noc_router_hdc (
  input  wire clk, input wire rst_n,
  input  wire [15:0] n_in, output reg [15:0] n_out,
  input  wire [15:0] s_in, output reg [15:0] s_out,
  input  wire [15:0] e_in, output reg [15:0] e_out,
  input  wire [15:0] w_in, output reg [15:0] w_out
);
  wire [15:0] ingress_data = n_in ^ s_in ^ e_in ^ w_in;
  reg [15:0] egress_data;
  
  // -- Core HDC Mathematics --
  reg [15:0] hypervector_basis = 16'hA5A5;
  reg [3:0] popcount;
  integer i;
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      egress_data <= 0; popcount <= 0;
      n_out <= 0; s_out <= 0; e_out <= 0; w_out <= 0;
    end else begin
      popcount = 0;
      for (i = 0; i < 16; i = i + 1) begin
        popcount = popcount + (ingress_data[i] ^ hypervector_basis[i]);
      end
      egress_data <= (popcount > 8) ? 16'hFFFF : 16'h0000;
      n_out <= egress_data; s_out <= egress_data; e_out <= egress_data; w_out <= egress_data;
    end
  end
endmodule

module sovryn_noc_router_mamba (
  input  wire clk, input wire rst_n,
  input  wire [15:0] n_in, output reg [15:0] n_out,
  input  wire [15:0] s_in, output reg [15:0] s_out,
  input  wire [15:0] e_in, output reg [15:0] e_out,
  input  wire [15:0] w_in, output reg [15:0] w_out
);
  wire [15:0] ingress_data = n_in ^ s_in ^ e_in ^ w_in;
  reg [15:0] egress_data;
  
  // -- Core Mamba SSM Mathematics --
  reg signed [15:0] A_matrix = 16'h00A0;
  reg signed [15:0] B_matrix = 16'h0080;
  reg signed [15:0] state_h;
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
       state_h <= 0; egress_data <= 0;
       n_out <= 0; s_out <= 0; e_out <= 0; w_out <= 0;
    end else begin
       state_h <= (state_h * A_matrix >>> 8) + (ingress_data * B_matrix >>> 8);
       egress_data <= state_h;
       n_out <= egress_data; s_out <= egress_data; e_out <= egress_data; w_out <= egress_data;
    end
  end
endmodule

module sovryn_noc_router_transformer (
  input  wire clk, input wire rst_n,
  input  wire [15:0] n_in, output reg [15:0] n_out,
  input  wire [15:0] s_in, output reg [15:0] s_out,
  input  wire [15:0] e_in, output reg [15:0] e_out,
  input  wire [15:0] w_in, output reg [15:0] w_out
);
  wire [15:0] ingress_data = n_in ^ s_in ^ e_in ^ w_in;
  reg [15:0] egress_data;
  
  // -- Core Transformer MAC Mathematics --
  reg signed [15:0] weight_cache [0:3];
  reg [1:0] cache_idx;
  reg signed [31:0] accumulator;
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
       accumulator <= 0; cache_idx <= 0; egress_data <= 0;
       weight_cache[0] <= 16'h0100; weight_cache[1] <= -16'h0080;
       weight_cache[2] <= 16'h0200; weight_cache[3] <= -16'h0150;
       n_out <= 0; s_out <= 0; e_out <= 0; w_out <= 0;
    end else begin
       accumulator <= accumulator + ($signed(ingress_data) * weight_cache[cache_idx]);
       cache_idx <= cache_idx + 1;
       egress_data <= accumulator[23:8];
       n_out <= egress_data; s_out <= egress_data; e_out <= egress_data; w_out <= egress_data;
    end
  end
endmodule

module sovryn_noc_router_kan (
  input  wire clk, input wire rst_n,
  input  wire [15:0] n_in, output reg [15:0] n_out,
  input  wire [15:0] s_in, output reg [15:0] s_out,
  input  wire [15:0] e_in, output reg [15:0] e_out,
  input  wire [15:0] w_in, output reg [15:0] w_out
);
  wire [15:0] ingress_data = n_in ^ s_in ^ e_in ^ w_in;
  reg [15:0] egress_data;
  
  // -- Core KAN Spline Mathematics --
  reg [15:0] spline_lut [0:15];
  integer i;
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
       egress_data <= 0;
       for(i=0; i<16; i=i+1) spline_lut[i] <= i * 16'h0A;
       n_out <= 0; s_out <= 0; e_out <= 0; w_out <= 0;
    end else begin
       egress_data <= spline_lut[ingress_data[15:12]] + ingress_data[11:8];
       n_out <= egress_data; s_out <= egress_data; e_out <= egress_data; w_out <= egress_data;
    end
  end
endmodule