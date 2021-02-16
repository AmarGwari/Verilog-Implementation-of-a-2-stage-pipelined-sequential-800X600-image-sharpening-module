//PLAN
/*
	2 stages -> FETCH, UPDATE : 2 Pipeline regiters
	on positve  edge -> Update FETCH Register,Write OP memory
	on negative edge -> Update UPDATE Register,Increment Counter
	
	REG:FETCH -> IPMEM(COMBI) -> REG:UPDATE -> MATHS+Counter
		|------------------<---------------------------|
	
	2 stage pipelined structure
*/
//-----------------------------------------------------------------------------------------

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
//----------------------------------------------------------------------------------------

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
//----------------------------------------------------------------------------------------

//INPUT MEMORY : COMBINATIONAL READ, R.O.M.
/*
Ports :-
INPUT  : 9 addresses for input.
OUTPUT : 9 values for pixel values
*/

module IPMem(a0,a1,a2,a3,a4,a5,a6,a7,a8,v0,v1,v2,v3,v4,v5,v6,v7,v8,db0,db1,db2,db3,db4,db5,db6,db7,db8);

	input [18:0] a0,a1,a2,a3,a4,a5,a6,a7,a8;
	output [7:0] v0,v1,v2,v3,v4,v5,v6,v7,v8;
	output [7:0] db0,db1,db2,db3,db4,db5,db6,db7,db8;//DEBUG WIRES
	
	reg [7:0] ip_mem_blk [482804:0]; //512kB
		
	assign v0 = ip_mem_blk[a0]; //COMBINATIONAL READ
	assign v1 = ip_mem_blk[a1];
	assign v2 = ip_mem_blk[a2];
	assign v3 = ip_mem_blk[a3];
	assign v4 = ip_mem_blk[a4];
	assign v5 = ip_mem_blk[a5];
	assign v6 = ip_mem_blk[a6];
	assign v7 = ip_mem_blk[a7];
	assign v8 = ip_mem_blk[a8];
	//DEBUG WIRES
	assign db0 = ip_mem_blk[a0];
	assign db1 = ip_mem_blk[a1];
	assign db2 = ip_mem_blk[a2];
	assign db3 = ip_mem_blk[a3];
	assign db4 = ip_mem_blk[a4];
	assign db5 = ip_mem_blk[a5];
	assign db6 = ip_mem_blk[a6];
	assign db7 = ip_mem_blk[a7];
	assign db8 = ip_mem_blk[a8];
	
	initial
	begin
		$readmemh("BWPaddedPic.hex",ip_mem_blk);
	end
	
endmodule

//----------------------------------------------------------------------------------------

//OUPUT MEMORY : SEQUENTIAL WRITE
/*
Ports :-
INPUT  :  1 OP address, 1 value (1 byte)
OUTPUT :  NO 
*/

module OPMem(clk,add,val,debugWire);

	input clk;
	input [18:0] add;
	input  [7:0] val;
	output [7:0] debugWire;
	reg    [7:0] debugWire;
	
	reg [7:0] op_mem_blk [480000:0]; //512kB
	
	always@(posedge clk)
	begin
		op_mem_blk[add] <= val;
		debugWire <= val;
	end
	
	initial
	begin
	#48000000
	$writememh("BWOP.hex",op_mem_blk);
	end

endmodule

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

//----------------------------------------------------------------------------------------
/* 
	ASSEMBLING THE CIRCUIT USING THE MODULES
	1) RESET -> reset the fetch register and counters
	2) HALT  -> HALTS circuit functions
*/
//========================================================================================
// CONTROLLER MODULE
//========================================================================================
//----------------------------------------------------------------------------------------

module controller(clk,reset,halt,debugWire,db0,db1,db2,db3,db4,db5,db6,db7,db8);

	input clk,reset;
	output [7:0] debugWire,db0,db1,db2,db3,db4,db5,db6,db7,db8;
	output halt;
	
	//ADDRESS RELATED WIRES
	wire [18:0] ia0,ia1,ia2,ia3,ia4,ia5,ia6,ia7,ia8,opa;
	wire [18:0] ia0_updated1,ia1_updated1,ia2_updated1,ia3_updated1,ia4_updated1,ia5_updated1;
	wire [18:0] ia6_updated1,ia7_updated1,ia8_updated1,opa_updated1;
	wire [18:0] opa_updated2;
	
	//VALUES RELATED WIRES
	wire [7:0] ipVal0,ipVal1,ipVal2,ipVal3,ipVal4,ipVal5,ipVal6,ipVal7,ipVal8,opVal;
	wire [7:0] ipVal0Ud,ipVal1Ud,ipVal2Ud,ipVal3Ud,ipVal4Ud,ipVal5Ud,ipVal6Ud,ipVal7Ud,ipVal8Ud;
	//Control signals
	wire halt,condition;
	
	//Calling Modules------------------------------------------------------------------------------------------------------------------------------------
	//Fetch Pipeline Reg
	FETCHPreg fetch_stage_pipelineReg(clk,reset,ia0_updated1,ia1_updated1,ia2_updated1,ia3_updated1,ia4_updated1,ia5_updated1,
	ia6_updated1,ia7_updated1,ia8_updated1,opa_updated1,ia0,ia1,ia2,ia3,ia4,ia5,ia6,ia7,ia8,opa);
	//Input memory
	IPMem input_memory(ia0,ia1,ia2,ia3,ia4,ia5,ia6,ia7,ia8,ipVal0,ipVal1,ipVal2,ipVal3,ipVal4,ipVal5,ipVal6,ipVal7,ipVal8,db0,db1,db2,db3,db4,db5,db6,db7,db8);
	//Update Pipeline Reg
	UPDATEPreg update_stg_pipelineReg(clk,reset,opa_updated2,ipVal0Ud,ipVal1Ud,ipVal2Ud,ipVal3Ud,ipVal4Ud,ipVal5Ud,ipVal6Ud,ipVal7Ud,ipVal8Ud,
	opa,ipVal0,ipVal1,ipVal2,ipVal3,ipVal4,ipVal5,ipVal6,ipVal7,ipVal8);
	//Maths Modules
	counter cou0(reset,condition,clk);
	halt_reg hr0(clk,halt,reset);
	ipAddUpdater ipAu0(condition,ia0,ia1,ia2,ia3,ia4,ia5,ia6,ia7,ia8,ia0_updated1,ia1_updated1,ia2_updated1,ia3_updated1,ia4_updated1,ia5_updated1,
	ia6_updated1,ia7_updated1,ia8_updated1);
	opAddUpdater opAu0(1'b0,opa_updated2,opa_updated1);
	sharper shp0(ipVal0Ud,ipVal1Ud,ipVal2Ud,ipVal3Ud,ipVal4Ud,ipVal5Ud,ipVal6Ud,ipVal7Ud,ipVal8Ud,opVal);
	//Output Memory
	OPMem output_memory(clk,opa_updated2,opVal,debugWire);
	
endmodule

/* 

	THE DESIGN PROCESS OF OUR SHARPENING MODULE IS NOW OVER ... WE WILL NOW WRITE A TESTBENCH FOR IT

*/

module SRPcontroller_tb;

	reg clk,reset;
	wire halt;
	wire [7:0] debugWire,db0,db1,db2,db3,db4,db5,db6,db7,db8;
	
	controller cntrlr_ins0(clk,reset,halt,debugWire,db0,db1,db2,db3,db4,db5,db6,db7,db8);
	
	initial
	begin
	reset = 1;
	#50
	clk = 1;
	#50
	clk = 0;
	#20
	reset = 0;
	#30
	clk = 1;
	forever
	begin
	#50 clk = ~clk;
	end
	end
	
	
endmodule