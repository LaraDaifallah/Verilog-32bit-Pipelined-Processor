`timescale 1ns/1ps
module PipelinedProcessor_tb();
    reg clk, rst;
    integer i;
    reg stop_log;
  
    PipelinedProcessor uut (.clk(clk), .rst(rst));
    always #5 clk = ~clk;

    initial begin  
        $display("======================================================================");
        $display("Pipelined Processor: Full State Snapshot Trace");
        $display("======================================================================");
        
        clk = 0; rst = 1; stop_log = 0;
        #15 rst = 0; 
        wait(uut.ID_Stage.Instruction_D == 32'h0000DEAD);
        stop_log = 1;
        repeat(4) @(negedge clk);  

        $display("----------------------------------------------------------------------");
        $display("Simulation Finished Successfully.");
        $display("----------------------------------------------------------------------");
        $finish;
    end

    always @(negedge clk) begin
        if (!rst) begin
            $display("\n[CYCLE: %0d] | PC: %0d", uut.clockCycles, uut.current_pc_D-1);
            
            if (stop_log)
                $display("Instruction: program is done");
            else
                $display("Instruction: %h", uut.Instruction_D);

          
            $display("Data Memory:");
            for (i = 15; i <=20; i = i + 1) begin
                $display("  Mem[%0d]: %h", i, uut.MEM_Stage.data_ram.RAM[i]);
            end
		   
            $display("Registers:");
            for (i = 0; i < 32; i = i + 1) begin
                $display("  R%02d: %h", i, uut.ID_Stage.RF.Registers[i]);
            end
            
            $display("======================================================================");
        end
    end
endmodule