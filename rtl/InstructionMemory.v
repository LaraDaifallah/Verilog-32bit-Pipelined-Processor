// Bismillah
module InstructionMemory(
    input  [31:0] address,
    output reg [31:0] inst 
);
    reg [31:0] ROM [1023:0];

    initial begin
        integer i;
        for (i = 0; i < 1024; i = i + 1) begin
            ROM[i] = 32'h0;
        end
        $readmemh("inst.txt", ROM);
    end
    always @(*) begin
        inst = ROM[address[9:0]];
    end

endmodule			 


