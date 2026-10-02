// Bismillah
module ALU(
    input  [31:0] IN1, IN2,   
    input  [2:0]  ALU_OP,      
    output reg [31:0] Result 
);

    always @(*) begin
        case (ALU_OP)
            3'b000: Result = IN1 + IN2; // ADD,ADDI,LW,SW
            3'b001: Result = IN1 - IN2; // SUB
            3'b010: Result = IN1 | IN2; // OR,ORI
            3'b011: Result = ~(IN1 | IN2); // NOR,NORI
            3'b100: Result = IN1 & IN2; // AND,ANDI
            default: Result = 32'h0;      
        endcase
    end

endmodule  			


