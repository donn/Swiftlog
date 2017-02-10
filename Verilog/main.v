//main Verilog Module
`timescale 1ns/1ns

`include "Verilog/mux.v"

module main;

    reg [31:0] a, b;
    reg s;

    wire [31:0] z;

    mux uut(
        .a(a),
        .b(b),
        .s(s),
        .z(z)
    );

    initial begin
        #50;
		$display("Hello from Verilog!");
		$hello_world;
        #10
        a = 32'd777;
        b = 32'd999;
        s = 1'b1;
        #10
        $show_result(z);
		$finish;
    end

endmodule