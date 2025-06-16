//=============================================================================
// Project  : Industrial HW Verification
//
// File Name: avmm_mem_th.sv
//
//
// Version:   1.0
//
// Code created by Easier UVM Code Generator version 2016-04-18-EP on Thu Apr 28 06:08:21 2022
//=============================================================================
// Description: Test Harness
//=============================================================================

module avmm_mem_th;

  timeunit      1ns;
  timeprecision 1ps;

  // Clock and reset declarations
  logic clock = 0;
  logic rst_n;

  // Clock generator process
  always #10 clock = ~clock;

  // Reset generator process
  initial
  begin
    rst_n = 0;
    #75 rst_n = 1;
  end

  // Instantiate AVMM interface
  avmm_if  avmm_if_0 (clock, rst_n);

  // Instantiate UUT
  avmm_mem uut (
    .clk      (clock),
    .rst_n    (rst_n),
    .address  (avmm_if_0.address),
    .write    (avmm_if_0.write),
    .read     (avmm_if_0.read),
    .readdata (avmm_if_0.readdata),
    .writedata(avmm_if_0.writedata)
  );

endmodule

