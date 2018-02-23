// 8bit FAdder
module F_Adder(X,Y,M,R,G);
input [7:0] X,Y;
input M;
output [7:0] R;
output G;
assign {G, R} = M ? X + ~Y + {7'b0,1'b1} : X + Y;
endmodule

//FAdder tester
module test_FAdder();
reg [7:0] Out1,Out2;
reg M;
wire [7:0] S;
wire C;
F_Adder FA(Out1,Out2,M,S,C);
	initial
	begin
	Out1=8'b00000100; Out2=8'b00000001; 
	M=0;
	#200
	Out1=8'b00000001; Out2=8'b00000010;
	M=1;
      end
endmodule