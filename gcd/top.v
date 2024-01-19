module top_gcd(rst,clk,go,data_in1,data_in2,done,out); input rst,clk,go;
input [7:0] data_in1,data_in2;
output done;
output [7:0] out;
wire a_sel,b_sel,a_ld,b_ld,output_en,a_gt_b,a_eq_b,a_lt_b;
datapath_gcd u1(rst,clk,data_in1,data_in2,a_sel,b_sel,a_ld,b_ld,output_en,out,a_gt_b,a_eq_b,a_lt_b); 
controller_gcd u2(rst,clk,go,a_gt_b,a_lt_b,a_eq_b,a_sel,b_sel,a_ld,b_ld,done,output_en);
endmodule

// Data Path of GCD
module datapath_gcd(rst,clk,data_in1,data_in2,a_sel,b_sel,a_ld,b_ld,output_en,data_out,a_gt_b,a_eq_b ,a_lt_b);
input rst,clk;
input [7:0] data_in1,data_in2;
input a_sel,b_sel,a_ld,b_ld,output_en;
output [7:0] data_out;
output a_gt_b,a_eq_b,a_lt_b;
wire[7:0] ta_out,tb_out,sub_a,sub_b,ta_in,tb_in;
mux8bus2to1 amux (data_in1,sub_a,a_sel,ta_in), bmux (data_in2,sub_b,b_sel,tb_in);
pipo pipo_a (rst,clk,a_ld,ta_in,ta_out),
pipo_b (rst,clk,b_ld,tb_in,tb_out),
pipo_out (rst,clk,output_en,ta_out,data_out);
comp comp1 (ta_out,tb_out,a_gt_b,a_eq_b,a_lt_b);
subs subs_a (ta_out,tb_out,sub_a), subs_b (tb_out,ta_out,sub_b);
endmodule

// Control path of GCD
module controller_gcd(rst,clk,go,a_gt_b,a_lt_b,a_eq_b,a_sel,b_sel,a_ld,b_ld,done,output_en); 
input rst,clk,go,a_gt_b,a_lt_b,a_eq_b;
output reg a_sel,b_sel,a_ld,b_ld,done,output_en;
reg [4:0] state;
parameter s0=0,s1=1,s2=2,s3=3,s4=4,s5=5,s6=6,s7=7,s8=8;
always @(posedge clk,posedge rst) begin
if(rst)
state<=s0; else
case(state) s0: begin
if(go) state<=s1;
else state<=s0;
end
s1: state<=s2; s2: state<=s3; s3: begin
if(a_eq_b) state<=s7;
else if(a_gt_b) state<=s5;
else if(a_lt_b) state<=s4;
end
s4: state<=s6;
s5: state<=s6;
s6: state<=s3;
s7: state<=s8;
s8: state<= rst? s0:s8; default: state<=s0; endcase
end
always @(state)
begin
case(state)
s0: begin a_sel=1'b0; b_sel=1'b0;
a_ld=1'b0; b_ld=1'b0;
done=1'b0; output_en=1'b0; end
s1: begin
a_sel=1'b1; b_sel=1'b1; a_ld=1'b1; b_ld=1'b1; done=1'b0; output_en=1'b0; end
s2: begin
a_sel=1'b0; b_sel=1'b0; a_ld=1'b0; b_ld=1'b0; done=1'b0; output_en=1'b0; end
s3: begin
a_sel=1'b0; b_sel=1'b0; a_ld=1'b0; b_ld=1'b0; done=1'b0; output_en=1'b0; end
s4: begin
a_sel=1'b1; b_sel=1'b0; a_ld=1'b0; b_ld=1'b1; done=1'b0; output_en=1'b0; end
s5: begin
a_sel=1'b0; b_sel=1'b1; a_ld=1'b1; b_ld=1'b0; done=1'b0; output_en=1'b0; end
s6: begin
a_sel=1'b0; b_sel=1'b0; a_ld=1'b0; b_ld=1'b0; done=1'b0; output_en=1'b0; end
s7: begin
a_sel=1'b0; b_sel=1'b0; a_ld=1'b0; b_ld=1'b0; done=1'b1; output_en=1'b1; end
s8: begin
a_sel=1'b0; b_sel=1'b0; a_ld=1'b0; b_ld=1'b0; done=1'b1; output_en=1'b1; end
default: begin
a_sel=1'b0; b_sel=1'b0; a_ld=1'b0; b_ld=1'b0; done=1'b0; output_en=1'b0; end
endcase end
endmodule