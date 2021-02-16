//FETCH REGISTER
//Ports : 10 inputs/ -> 19bit ports (Addresses)
module FETCHPreg(clk,reset,in0,in1,in2,in3,in4,in5,in6,in7,in8,on,
				 i0,i1,i2,i3,i4,i5,i6,i7,i8,o);
	
	input clk,reset;
	input [18:0] in0,in1,in2,in3,in4,in5,in6,in7,in8,on; //new addresses
	output [18:0] i0,i1,i2,i3,i4,i5,i6,i7,i8,o; //old addresses
	reg [18:0] i0,i1,i2,i3,i4,i5,i6,i7,i8,o;
		
	always@(posedge clk)
	begin
		i0<=in0;
		i1<=in1;
		i2<=in2;
		i3<=in3;
		i4<=in4;
		i5<=in5;
		i6<=in6;
		i7<=in7;
		i8<=in8;
		o <=on;
		if(reset)
		begin
			i0 <= 19'd0;
			i1 <= 19'd1;
			i2 <= 19'd2;
			i3 <= 19'd802;
			i4 <= 19'd803;
			i5 <= 19'd804;
			i6 <= 19'd1604;
			i7 <= 19'd1605;
			i8 <= 19'd1606;
			o  <= 19'd0;
		end
	end
	
endmodule
