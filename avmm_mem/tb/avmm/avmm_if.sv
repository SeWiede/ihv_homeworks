//=============================================================================
// Project  : Industrial HW Verification
//
// File Name: avmm_if.sv
//
//
// Version:   1.0
//
// Code created by Easier UVM Code Generator version 2016-04-18-EP on Thu Apr 28 06:08:21 2022
//=============================================================================
// Description: Signal interface for agent avmm
//=============================================================================

`ifndef AVMM_IF_SV
`define AVMM_IF_SV

interface avmm_if(input logic clk, rst_n); 

  timeunit      1ns;
  timeprecision 1ps;

  import avmm_pkg::*;
 
  logic[7:0]  address;
  logic       write;
  logic       read;
  logic[31:0] writedata;
  logic[31:0] readdata;

endinterface : avmm_if

`endif // AVMM_IF_SV

