// Bismillah
module Forwarding_Unit(
    input RegWrite_EX, RegWrite_MEM, RegWrite_WB,  
    input [4:0] SrcAddr,         
    input [4:0] Rd_EX, Rd_MEM, Rd_WB, 
    output reg [1:0] Forward // 00: RF, 01: EX, 10: MEM, 11: WB
);
    always @(*) begin
       
        if (RegWrite_EX && (SrcAddr != 5'd0) && (SrcAddr == Rd_EX))
            Forward = 2'b01; // forward from EX stage
        else if (RegWrite_MEM && (SrcAddr != 5'd0) && (SrcAddr == Rd_MEM))
            Forward = 2'b10; // forward from MEM stage
        else if (RegWrite_WB && (SrcAddr != 5'd0) && (SrcAddr == Rd_WB))
            Forward = 2'b11; // forward from WB stage
        else
            Forward = 2'b00; // no hazards use RegFile
    end
endmodule


