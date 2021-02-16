//UPDATE REGISTER
//Ports -> 9 values 1 output value -> same output
module UPDATEPreg(clk,reset,oa,v0,v1,v2,v3,v4,v5,v6,v7,v8,
                  oan,vn0,vn1,vn2,vn3,vn4,vn5,vn6,vn7,vn8);

	input clk,reset;
	output  [7:0] v0,v1,v2,v3,v4,v5,v6,v7,v8; //9 vals (from memory)
	input  [18:0] oan; // op address
	input [7:0] vn0,vn1,vn2,vn3,vn4,vn5,vn6,vn7,vn8; // new 9 vals from memory
	output [18:0] oa; // new o/p address
	reg    [18:0] oa; 
	reg    [7:0] v0,v1,v2,v3,v4,v5,v6,v7,v8;
	
	always@(negedge clk)
	begin
		v0<=vn0;
		v1<=vn1;
		v2<=vn2;
		v3<=vn3;
		v4<=vn4;
		v5<=vn5;
		v6<=vn6;
		v7<=vn7;
		v8<=vn8;
		oa<=oan;
		if(reset)
		begin
			oa <= 0;
		end
	end
	
endmodule
