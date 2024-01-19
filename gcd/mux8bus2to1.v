module mux8bus2to1(a,b,sel,out);
input [7:0] a,b;
input sel;
output [7:0] out;
assign out = sel?a:b;
endmodule