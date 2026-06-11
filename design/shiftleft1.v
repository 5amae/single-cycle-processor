`timescale 1ns / 1ps

module ShiftLeftOne (
    input signed [31:0] i,
    output signed [31:0] o
);

   assign o = i << 1;

endmodule

