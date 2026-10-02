`timescale 1ns/1ps	
module InstructionMemory_tb;
		
	reg [31:0] address;
	wire [31:0] inst;
	
	InstructionMemory uut (
	    .address(address),
	    .inst(inst)
	);
	
	initial begin
	    $display("Starting Instruction Memory Verification");
	
	    address = 32'd0;
	    #10;
	    $display("TC1: Address 0 | Instruction: %h", inst);
	    if (inst !== 32'hx)
	        $display("Yayy (; Successfully read address 0.");
	    else
	        $display("Fail :( Data is unknown at address 0.");
	
	    $display("Verification Complete.");
	    $finish;
	end		
endmodule