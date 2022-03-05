module Adder (
    output wire [31:0] C,
    input  wire [31:0] A,B
);
    
    assign C = A + B;
endmodule