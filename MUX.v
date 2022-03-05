module MUX #(parameter MUX_size = 32) (
    output reg  [MUX_size-1:0] out_mux,
    input  wire [MUX_size-1:0] in1_mux,in0_mux,
    input  wire                sel
);
    always @(*) begin
        if (sel) begin
        out_mux = in1_mux;
        end
        else out_mux = in0_mux;
    end
endmodule