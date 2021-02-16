//----------------------------------------------------------------------------------------
/* 
	ASSEMBLING THE CIRCUIT USING THE MODULES
	1) RESET -> reset the fetch register and counters
	2) HALT  -> Signifies work completion for circuit functions
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
