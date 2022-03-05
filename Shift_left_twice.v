module Shift_left_twice #(parameter in_shift_size = 32 , parameter out_shift_size = 32) (
    input  wire [in_shift_size-1:0]  in_shift ,
    output reg  [out_shift_size-1:0] out_shift 
);
always @(*) begin
    out_shift = (in_shift<<2);
end    

endmodule