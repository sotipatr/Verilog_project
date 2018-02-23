// mux 2-1
module MUX2_1(P,Q,V,S);
input [7:0]P,Q;
input V;
output[7:0] S;
assign S = V ? P : Q;
endmodule

// 8bit FAdder
module FAdder(X,Y,M,R);
input [7:0] X,Y;
input M;
output [7:0] R;

assign R = M ? X - Y : X + Y;
endmodule

//Register
module Register(S,LSHL,s0,CLK,Clr,T);
input s0;
input CLK,Clr,LSHL;
input [7:0] S;
output [7:0] T;
reg [7:0] T;

always @ (posedge CLK or negedge Clr)
    if(~Clr) T = 8'b00000000;
    else 
    case({s0})
    1'b1: T = {T[6:0],LSHL}; //shift left
    1'b0: T = S;  //parallel load
    endcase
 endmodule
 
 //T flip-flop
 module TFF(t,CLK,Q,Clr);
 input t,CLK,Clr;
 output Q;
 reg Q;
 always @ (posedge CLK or negedge Clr)
 if(~Clr) Q =1'b0;
    else Q =Q^t;
endmodule
//******************************************
//ALL
module All(A,B,C,CLK,Clr,LSHL,V0,V1,M,s0,T);
input [7:0] A,B,C;
input CLK,Clr,LSHL,V0,V1,M,s0;
output [7:0]T;
wire [7:0] Out1,Out2,S;
MUX2_1 M1(A,T,V0,Out1);
MUX2_1 M2(B,C,V1,Out2);
FAdder FA(Out1,Out2,M,S);
Register REG(S,LSHL,s0,CLK,Clr,T);
endmodule
//*******************
//Final
module Final(A,B,C,E,CLK,Clr,LSHL,T);
input [7:0] A,B,C;
input E,CLK,Clr,LSHL;
output [7:0] T;
count CONTER(E,CLK,Clr,M,s0,V);
All All_final(A,B,C,CLK,Clr,LSHL,V,V,M,s0,T);
endmodule

//Final testbanch
module Final_testbanch();
reg [7:0] A,B,C;
reg E,CLK,Clr,LSHL;
wire [7:0] T;
Final question2(A,B,C,E,CLK,Clr,LSHL,T);
initial
	begin
	E=0; Clr = 0; LSHL = 0;CLK =0;//2*(A+B-C)
	#50 Clr = 1; 
	A=8'b00000010;
  	B=8'b00000100;
  	C=8'b00000011; 
	 #600 Clr=0;
	 #50 Clr=1;
	 
	 E=1; //2*(A-B+C)    
	A=8'b00000010;
  	B=8'b00000100;
  	C=8'b00000011; 
	
	end
	always
	#50 CLK = ~CLK;
endmodule
//******************************
//counter
module count(E,CLK,Clr,M,s0,V);
input E,CLK,Clr;
output M,s0,V;
TFF ff3(t1,CLK,Q1,Clr);
TFF ff4(t2,CLK,Q2,Clr);
assign t1 = Q1||Q2;
assign t2 = ~Q1;
assign s0 = Q1;
assign V = ~Q2;
assign M = E^Q2;
endmodule

//test counter
module counter_test();
reg E,CLK,Clr;
wire M,s0,V;
count counter(E,CLK,Clr,M,s0,V);
initial
begin
E=1; CLK=0; Clr=0;
#100 Clr = 1;
end
always
  #50 CLK =~CLK;
endmodule