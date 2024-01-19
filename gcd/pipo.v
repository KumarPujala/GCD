module pipo(rst,clk,ld,in,out);
input clk,rst,ld;
input [7:0] in;
output reg [7:0] out;
always @(posedge clk, posedge rst)
begin
    if(rst)
    out<=8'b0;
    else if (ld)
    out<=in;
end
endmodule