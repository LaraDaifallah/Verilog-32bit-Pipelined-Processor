// Bismillah
module ControlUnit(
    input [4:0] Opcode,
    output reg RegWrite, // write to RegFile
    output reg ALUSrc, // 0: RtData, 1: ExtImm
    output reg RegDst, // 0: Rd, 1: R31 (for call inst wb)
    output reg MemRead, // Enable mem Read
    output reg MemWrite, // Enable mem Write
    output reg RegReadSrc2, // 0: use Rt field, 1: use Rd field (for SW inst)
    output reg [1:0] WB_Sel, // 00: ALU, 01: Memory, 10: PC+1 (for CALL inst)
    output reg [2:0] ALU_OP, // math op
    output reg [1:0] PCSrc, // 00: PC+1, 01: Jump/Call, 10: JR
    output reg [1:0] ExtSel // 00: Zero, 01: Sign12, 10: Sign22
);

    always @(*) begin

        RegWrite = 0; ALUSrc = 0; RegDst = 0; MemRead = 0; MemWrite = 0;
        RegReadSrc2 = 0; WB_Sel = 2'b00; ALU_OP = 3'b000; PCSrc = 2'b00; ExtSel = 2'b00;
        case (Opcode)
            // R-type insts
            5'd0: begin RegWrite = 1; ALU_OP = 3'b000; end //ADD
            5'd1: begin RegWrite = 1; ALU_OP = 3'b001; end //SUB
            5'd2: begin RegWrite = 1; ALU_OP = 3'b010; end //OR
            5'd3: begin RegWrite = 1; ALU_OP = 3'b011; end //NOR
            5'd4: begin RegWrite = 1; ALU_OP = 3'b100; end //AND

            // I-type ints
            5'd5: begin RegWrite = 1; ALUSrc = 1; ExtSel = 2'b01; ALU_OP = 3'b000; end //ADDI (sign)
            5'd6: begin RegWrite = 1; ALUSrc = 1; ExtSel = 2'b00; ALU_OP = 3'b010; end //ORI (zero)
            5'd7: begin RegWrite = 1; ALUSrc = 1; ExtSel = 2'b00; ALU_OP = 3'b011; end //NORI (zero)
            5'd8: begin RegWrite = 1; ALUSrc = 1; ExtSel = 2'b00; ALU_OP = 3'b100; end //ANDI (zero)

            // Memory insts (LW/SW) 
            5'd9: begin // LW
                RegWrite = 1; ALUSrc = 1; ExtSel = 2'b01; 
                MemRead = 1; WB_Sel = 2'b01; ALU_OP = 3'b000; 
            end 
            5'd10: begin // SW 
                MemWrite = 1; ALUSrc = 1; ExtSel = 2'b01; 
                RegReadSrc2 = 1; ALU_OP = 3'b000; 
            end 

            // J-type insts
            5'd11: begin // J
                PCSrc = 2'b01; ExtSel = 2'b10; 
            end 
            5'd12: begin // CALL
                PCSrc = 2'b01; ExtSel = 2'b10; 
                RegWrite = 1; RegDst = 1; WB_Sel = 2'b10; 
            end 
            5'd13: begin // JR
                PCSrc = 2'b10; 
            end 

            default: ; // NOP
        endcase
    end
endmodule									



