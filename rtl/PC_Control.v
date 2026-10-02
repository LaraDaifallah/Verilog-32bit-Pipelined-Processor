// Bismillah
module PC_Control(
    input [31:0] current_pc, sign_ext_off, rs_data,       
    input [1:0]  PCSrc,        
    input ExecuteEn,     
    output reg [31:0] next_pc
);

    always @(*) begin
        case(PCSrc)
    
            2'b00: next_pc = current_pc + 32'd1;

            2'b01: begin
                if (ExecuteEn)
                    next_pc = current_pc + sign_ext_off;
                else
                    next_pc = current_pc + 32'd1;
            end

            2'b10: begin
                if (ExecuteEn)
                    next_pc = rs_data;
                else
                    next_pc = current_pc + 32'd1;
            end

            default: next_pc = current_pc + 32'd1;
        endcase
    end
endmodule		


