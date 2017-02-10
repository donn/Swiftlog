`timescale 1ns/1ns

module mux(a, b, s, z);

input s;
input [31:0] a, b;
output [31:0] z;

assign z = s? b: a;

endmodule