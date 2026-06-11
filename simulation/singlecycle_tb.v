`timescale 1ns / 1ps

module tb_riscv_sc;
//cpu testbench

reg clk;
reg start;

SingleCycleCPU riscv_DUT(clk, start);

initial
	forever #5 clk = ~clk;

initial begin
    $dumpfile("riscv_tb.vcd");
    $dumpvars(0, riscv_DUT);
	clk = 0;
	start = 0;
	#10 start = 1;

	#3000 $finish;

end

endmodule
