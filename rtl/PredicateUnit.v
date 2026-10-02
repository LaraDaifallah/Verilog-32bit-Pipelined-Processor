// Bismillah
module PredicateUnit(
    input [4:0]  Rp_addr,   
    input [31:0] Rp_data,  
    output ExecuteEn  
);

    assign ExecuteEn = (Rp_addr == 5'd0) ? 1'b1 : (Rp_data != 32'd0);

endmodule		  


