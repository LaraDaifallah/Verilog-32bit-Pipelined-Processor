// Bismillah
module KillUnit(
    input [4:0] Opcode,
    input ExecuteEn,    
    output reg killSignal
);
    always @(*) begin
        if (ExecuteEn) begin
            case (Opcode)
                5'd11, 5'd12, 5'd13: killSignal = 1'b1; // J, CALL, JR
                default: killSignal = 1'b0;
            endcase
        end 
        else begin
            killSignal = 1'b0;
        end
    end
endmodule


