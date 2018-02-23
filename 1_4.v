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
 
 //test register
 module reg_test();
 reg s0,CLK,Clr,LSHL;
 reg [7:0]S;
 wire [7:0]T;
 Register ThisRegistere(S,LSHL,s0,CLK,Clr,T);
	initial
	begin
	S=$random; 
	CLK = 1; LSHL = 0; Clr = 1;
	s0=0;
	end
	always
	#100 s0=~s0;
	always
	#50 CLK=~CLK;
 endmodule