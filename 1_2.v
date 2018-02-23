// mux 2-1
module MUX2_1(P,Q,V,S);
input [7:0]P,Q;
input V;
output[7:0] S;
assign S = V ? P : Q;
endmodule
 
 //MUX tester
 module test_mux();
 reg [7:0] A,B;
 reg V0;
 wire[7:0]Out;
MUX2_1 M1(A,B,V0,Out);
	initial
	begin
	 A=$random; B=$random; V0=$random;
        #200 A=$random; B=$random; V0= ~V0;
        #200 A=$random; B=$random; V0= ~V0;
end
endmodule