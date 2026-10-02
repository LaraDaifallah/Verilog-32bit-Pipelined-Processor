// Bismillah
module Extender(
    input [11:0] Imm12,     
    input [21:0] Offset22, 
    input [1:0] ExtSel,     // control signal: 00 = 0Ext12, 01 = SignExt12, 10 = SignExt22
    output reg [31:0] ExtOut
);

    always @(*) begin
        case (ExtSel)
            // 0Ext 12bits 
            2'b00: ExtOut = {20'b0,Imm12};
            
            // SignExt 12bits
            2'b01: ExtOut = {{20{Imm12[11]}},Imm12};
            
            // SigExt 22bits 
            2'b10: ExtOut = {{10{Offset22[21]}},Offset22};
            
            default: ExtOut = 32'h0;
        endcase
    end
endmodule	

