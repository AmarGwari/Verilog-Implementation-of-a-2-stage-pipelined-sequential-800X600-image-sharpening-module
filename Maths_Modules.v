//----------------------------------------------------------------------------------------
//========================================================================================
//MATHS MODULES---------------------------------------------------------------------------
//========================================================================================
//----------------------------------------------------------------------------------------

//INCREMENTER MODULE.
module incrementerSmall(in,cond,op);

	input  [9:0] in;
	input  cond;
	output [9:0] op;
	
	assign op = in+(cond?3:1);

endmodule

module incrementer(in1,cond1,op1);

	input  [18:0] in1;
	input  cond1;
	output [18:0] op1;

	assign op1 = in1+(cond1?3:1);

endmodule

//Counter Module : negative edge -> increment
module counter(reset,cond,clk);

	input reset,clk;
	output cond;
	reg cond;
	
	reg  [9:0] val;
	wire [9:0] val_inc;
	
	incrementerSmall incs0(val,1'b0,val_inc); //incrementer -> +1 if 1'b0, +3 if 1'b1
	
	always@(negedge clk)
	begin
	if(val == 800)
	begin
		val <= 0;
		cond <= 1'b1;
	end
	else
	begin
		val <= val_inc;
		cond <= 1'b0;
	end
	if(reset)
	begin
		val <= 10'b0; //GLOBAL RESET
		cond = 1'b0;
	end
	end
	
endmodule

//HALT REGISTER : Gives signal for resetting the ckt.
module halt_reg(clk,halt,reset);

	input reset,clk;
	output halt;
	reg halt;
	
	reg [18:0] val;
	wire [18:0] val_inc;
	
	incrementer inc1(val,1'b0,val_inc);
	
	always@(posedge clk)
	begin
		if(val >= 19'd480000)
		begin
			halt <= 1'b1;
		end
		else
		begin
			val <= val_inc;
		end
		if(reset)
		begin
			val <= 1'b0;
			halt <= 1'b0;
		end
	end
	
endmodule

module ipAddUpdater(cond,ia0,ia1,ia2,ia3,ia4,ia5,ia6,ia7,ia8,
ia0upd,ia1upd,ia2upd,ia3upd,ia4upd,ia5upd,ia6upd,ia7upd,ia8upd);

	input [18:0] ia0,ia1,ia2,ia3,ia4,ia5,ia6,ia7,ia8;
	input cond;
	output [18:0] ia0upd,ia1upd,ia2upd,ia3upd,ia4upd,ia5upd,ia6upd,ia7upd,ia8upd;
	
	incrementer inc0(ia0,cond,ia0upd);
	incrementer inc1(ia1,cond,ia1upd);
	incrementer inc2(ia2,cond,ia2upd);
	incrementer inc3(ia3,cond,ia3upd);
	incrementer inc4(ia4,cond,ia4upd);
	incrementer inc5(ia5,cond,ia5upd);
	incrementer inc6(ia6,cond,ia6upd);
	incrementer inc7(ia7,cond,ia7upd);
	incrementer inc8(ia8,cond,ia8upd);

endmodule

module opAddUpdater(cond,oa,oaupd);

	input [18:0] oa;
	input cond;
	output [18:0] oaupd;
	
	incrementer inc9(oa,cond,oaupd);

endmodule

//---------------------------------------------------------------------------------------
//CONVOLUTER-SHARPER.

module multiplier(op,ip1,ip2);

	input [7:0] ip1,ip2;
	output [15:0] op;
	
	assign op = ip1*ip2;

endmodule

module sub2comp(op,ip1,ip2); //op = ip1 - ip2

	input  [15:0] ip1;
	input  [7:0] ip2;
	output [15:0] op;
	
	assign op = ip1 + ~(ip2) + 1;

endmodule

module adderSRP(op,ip1,ip2);

	input  [7:0] ip1;
	input  [15:0] ip2;
	output [15:0] op;
	
	assign op = ip1+ip2;

endmodule

module sharper(i0,i1,i2,i3,i4,i5,i6,i7,i8,op); //ROUGHLY -> Making it 2 times faster... 
//...make whole ckt will become 2 times faster (as this module has the highest run time)
	
	input [7:0] i0,i1,i2,i3,i4,i5,i6,i7,i8;
	output [7:0] op;
	
	//OPTIMISATION -> REDUCED MULTIPLIER MODULES FROM 9 to 1
	//BY kernel manipulation
	wire [15:0] m4;
	//2's complement subtractor
	wire [15:0] s0,s1,s2,s3,s4,s5,s6,s7;
	wire [15:0] srp0;
	
	multiplier mul0(m4,8'b00001001,i4);
	sub2comp   s2c0(s0,m4,i0);
	sub2comp   s2c1(s1,s0,i1);
	sub2comp   s2c2(s2,s1,i2);
	sub2comp   s2c3(s3,s2,i3);
	sub2comp   s2c4(s4,s3,i5);
	sub2comp   s2c5(s5,s4,i6);
	sub2comp   s2c6(s6,s5,i7);
	sub2comp   s2c7(s7,s6,i8);
	adderSRP   asp0(srp0,i0,s7);
	
	assign op = srp0[9:2];
	
endmodule

