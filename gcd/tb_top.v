`timescale 1ns/1ps
module top_gcd_tb; reg rst,clk,go;
reg [7:0] data_in1,data_in2; wire done;
wire [7:0] out;
top_gcd gcd1 (rst,clk,go,data_in1,data_in2,done,out);
initial clk=1'b0;
always #55 clk=~clk;
initial begin
$dumpfile("top_gcd.vcd"); $dumpvars(0,top_gcd_tb); 
data_in1=8'h2a; data_in2=8'h10;
#10 rst=1'b1;
#20 rst=1'b0;
#45 go=1'b1;
#110 go=1'b0;
#6000 $finish;
end
endmodule