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
