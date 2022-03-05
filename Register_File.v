module Register_File #(parameter reg_file_width = 32, parameter reg_file_depth = 32 ) (
    output reg  [31:0] RD1,RD2,
    input  wire [ 4:0] A1,A2,A3,
    input  wire [31:0] WD3,
    input  wire        WE3,
    input  wire        clk,
    input  wire        rst
);
    reg [reg_file_width-1 : 0] reg_file [reg_file_depth-1 : 0];

    always @(*) begin
        RD1 = reg_file [A1];
        RD2 = reg_file [A2];
        
    end
integer i=0;
    always @(posedge clk,negedge rst) begin
        if (!rst) begin
            for (i=0 ; i != reg_file_depth ; i=i+1) begin
                reg_file [i] <= {reg_file_width{1'b0}};
            end
        end
        else if (WE3) begin
            reg_file [A3] <= WD3;
        end
    end

endmodule