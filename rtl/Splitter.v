// Bismillah
module Splitter(
    input [31:0] Inst,
    output [4:0]  OPCode, Rp, Rd, Rs, Rt,        
    output [11:0] Immediate,  
    output [21:0] Offset     
);

    assign OPCode = Inst[31:27]; 
    assign Rp = Inst[26:22]; 

    // R-Type: [Op5][Rp5][Rd5][Rs5][Rt5][Unused7]
    // I-Type: [Op5][Rp5][Rd5][Rs5][Immediate12]
	// J-Type: [Op5][Rp5][Offset22]
	
    assign Rd = Inst[21:17]; 
    assign Rs = Inst[16:12];	
    assign Rt = Inst[11:7];  
    assign Immediate = Inst[11:0];  
    assign Offset = Inst[21:0];  

endmodule	  


