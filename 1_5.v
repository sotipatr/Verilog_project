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

//testbench
module All_tester();
reg [7:0] A,B,C;
reg V0,V1,M,s0,CLK,LSHL,Clr;
wire [7:0] T;
All Allprogram(A,B,C,CLK,Clr,LSHL,V0,V1,M,s0,T);
initial
	begin
	
	A=8'b00000001;
  	B=8'b00000100;
  	C=8'b00000010; LSHL = 0;
	Clr = 1;
	V0 = 1 ; CLK = 0; V1 = 1; s0 = 0; M = 0;//A+B 
	#100 M=1; V0=0; V1=0;  //T-C  
	#100 V1=1;             //T-B
	#100 M=0;              //T+B
	#100 M=0; V0=1; V1=0;  //A+C
	#100 M=1;               //A-C
        #100 V0=1; V1=1;  //A-B
  	#100 M=0; V0=0; V1=0;    //T+C
  	#100    s0=1;    //2*T
  	#100
  	$stop;
	end
	always 
	#50 CLK = ~CLK;
	
endmodule