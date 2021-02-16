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
	
	
endmodule
