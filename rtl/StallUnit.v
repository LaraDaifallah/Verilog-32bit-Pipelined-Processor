// Bismillah
module StallUnit(
    input MemRead_EX,               
    input [1:0] forward_rs,        
    input [1:0] forward_rt,      
    input [1:0] forward_rp,        
    output reg stallSignal
);

    initial stallSignal = 1'b0;
    always @(*) begin
      
        if (MemRead_EX && (forward_rs == 2'b01 || forward_rt == 2'b01 || forward_rp == 2'b01)) begin
            stallSignal = 1'b1;
        end
        else begin
            stallSignal = 1'b0;
        end
    end

endmodule	 


