`timescale 1ns/1ps
module ControlUnit_tb;

    reg [4:0] Opcode;
    wire RegWrite, ALUSrc, RegDst, MemRead, MemWrite, RegReadSrc2;
    wire [1:0] WB_Sel, PCSrc, ExtSel;
    wire [2:0] ALU_OP;

    ControlUnit uut (
        .Opcode(Opcode),
        .RegWrite(RegWrite),
        .ALUSrc(ALUSrc),
        .RegDst(RegDst),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .RegReadSrc2(RegReadSrc2),
        .WB_Sel(WB_Sel),
        .ALU_OP(ALU_OP),
        .PCSrc(PCSrc),
        .ExtSel(ExtSel)
    );

    initial begin
        $display("Starting Control Unit Verification");

        // test case 1: R-type
        Opcode = 5'd0; 
        #10;
        $display("TC1 (ADD): Op=%d, RegWrite=%b, RegReadSrc2=%b", Opcode, RegWrite, RegReadSrc2);
        if (RegWrite == 1 && RegReadSrc2 == 0 && ALUSrc == 0)
            $display("Yayy (; R-Type arithmetic signals are correct.");
        else
            $display("Fail :( ADD control signal mismatch.");

        // test case 2: SW 
        Opcode = 5'd10; 
        #10;
        $display("TC2 (SW): Op=%d, MemWrite=%b, RegReadSrc2=%b", Opcode, MemWrite, RegReadSrc2);
        if (MemWrite == 1 && RegReadSrc2 == 1 && ALUSrc == 1)
            $display("Yayy (; SW correctly set RegReadSrc2 to read from Rd.");
        else
            $display("Fail :( SW failed to set the correct read source.");

        // test case 3: CALL
        Opcode = 5'd12; 
        #10;
        $display("TC3 (CALL): Op=%d, RegDst=%b, WB_Sel=%b, PCSrc=%b", Opcode, RegDst, WB_Sel, PCSrc);
        if (RegWrite == 1 && RegDst == 1 && WB_Sel == 2'b10)
            $display("Yayy (; CALL correctly targets R31 with PC+1.");
        else
            $display("Fail :( CALL write-back configuration mismatch.");

        // test case 4: Logical I-type
        Opcode = 5'd8; 
        #10;
        $display("TC4 (ANDI): Op=%d, ExtSel=%b, ALU_OP=%b", Opcode, ExtSel, ALU_OP);
        if (RegWrite == 1 && ExtSel == 2'b00 && ALU_OP == 3'b100)
            $display("Yayy (; ANDI correctly set zero-extension.");
        else
            $display("Fail :( ANDI extension mode mismatch.");

        $display("Control Unit Verification Complete.");
        $finish;
    end

endmodule