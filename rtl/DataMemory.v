// Bismillah
module DataMemory(
    input clk, MEM_W, MEM_R,            
    input [31:0] address, data_in,   
    output reg [31:0] data_out 
);
    // 4KB
    reg [31:0] RAM [1023:0];
    integer i;
    initial begin
        for (i = 0; i < 1024; i = i + 1) begin
            RAM[i] = 32'h0; 
        end
        RAM[0] = 32'h0000000A;
        RAM[1] = 32'h00000014;
        RAM[5] = 32'hBADBADBA; 	
		RAM[20] = 32'hBADBADBA; 
    end
	
 	 //asynchronous read 
    always @(*) begin
        if (MEM_R)
            data_out = RAM[address[9:0]]; // using only the 10 LSB to cover all the 1024 words
        else
            data_out = 32'h0; 
    end

    //synchronous write
    always @(posedge clk) begin
        if (MEM_W) begin
            RAM[address[9:0]] <= data_in;
        end
    end

endmodule		 


