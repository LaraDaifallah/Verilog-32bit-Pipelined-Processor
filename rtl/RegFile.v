// Bismillah
module RegFile(
    input clk, rst, ActualRegWrite, 
    input [4:0] rs, rt, rp, rd,
    input [31:0] data_in, next_pc,   
    output [31:0] rsdata, rtdata, rpdata,
    output [31:0] current_pc 
);

    reg [31:0] Registers [31:0]; 

    assign rsdata = (rs == 5'd0) ? 32'd0 : Registers[rs];
    assign rtdata = (rt == 5'd0) ? 32'd0 : Registers[rt];
    assign rpdata = (rp == 5'd0) ? 32'd0 : Registers[rp];
    
    assign current_pc = Registers[30];

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            integer i;
            for (i = 0; i < 32; i = i + 1) Registers[i] <= 32'h0;  

        end 
        else begin
            Registers[30] <= next_pc;
			
            if (ActualRegWrite && rd != 5'd0 && rd != 5'd30) begin
                Registers[rd] <= data_in;
            end
        end
    end
endmodule	



