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
	
endmodule
