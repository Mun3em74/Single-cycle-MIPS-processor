module Data_mem #( parameter data_width = 32, parameter data_depth = 100, parameter address_width =32  ) (
    output reg  [31:0] RD,
    output reg  [(data_width/2) -1 : 0] test_value,
    input  wire [ data_width    -1 : 0] WD,
    input  wire [ address_width -1 : 0] A,
    input  wire                         WE,
    input  wire                         clk,
    input  wire                         rst
);
    reg [data_width-1 : 0] data_mem [data_depth-1 : 0];
    integer i=0;
always @(*) begin
    RD = data_mem [A];
    test_value = data_mem[32'd0];
end

always @(posedge clk, negedge rst) begin
    if (!rst) begin
        for (i=0; i != data_depth ;i=i+1 ) begin
            data_mem[i] <= {data_width {1'b0}};
        end
    end
    else if (WE) begin
        data_mem [A] <= WD;
    end
end


endmodule