module sovryn_pan_stem_npu_array_v3_seed_a_observe_debug #(
  parameter OBS_PACKET_WIDTH = 22
)(
  input wire clk,
  input wire rst_n,
  input wire local_observe_valid,
  input wire [OBS_PACKET_WIDTH-1:0] local_observe_payload,
  input wire observe_in_valid,
  input wire [OBS_PACKET_WIDTH-1:0] observe_in_payload,
  output reg observe_out_valid,
  output reg [OBS_PACKET_WIDTH-1:0] observe_out_payload
);
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      observe_out_valid <= 1'b0;
      observe_out_payload <= {OBS_PACKET_WIDTH{1'b0}};
    end else if (local_observe_valid) begin
      observe_out_valid <= 1'b1;
      observe_out_payload <= local_observe_payload;
    end else begin
      observe_out_valid <= observe_in_valid;
      observe_out_payload <= observe_in_payload;
    end
  end
endmodule
