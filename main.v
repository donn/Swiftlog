//main Verilog Module

`timescale 1ns/1ns

module main;
   
    initial begin
		$display("Hello from Verilog!");
		$hello_world;
		$finish;
    end

endmodule