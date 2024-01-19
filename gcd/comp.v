module comp(a,b,gt,eq,lt);
input [7:0] a,b;
output gt,eq,lt;
assign gt=(a>b);
assign eq=(a==b);
assign lt=(a<b);
endmodule