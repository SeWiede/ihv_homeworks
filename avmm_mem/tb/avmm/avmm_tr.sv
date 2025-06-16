//=============================================================================
// Project  : Industrial HW Verification
//
// File Name: avmm_tr.sv
//
//
// Version:   1.0
//
// Code created by Easier UVM Code Generator version 2016-04-18-EP on Thu Apr 28 06:08:21 2022
//=============================================================================
// Description: Sequence item for avmm_sequencer
//=============================================================================

`ifndef AVMM_TR_SV
`define AVMM_TR_SV

class avmm_tr extends uvm_sequence_item; 

  // Transaction variables
  rand logic[7:0] address;
  rand logic read;
  rand logic write;
  rand logic[31:0] writedata;
  rand logic[31:0] readdata;

  `uvm_object_utils_begin(avmm_tr)
    `uvm_field_int      (address,   UVM_ALL_ON)
    `uvm_field_int      (read,      UVM_ALL_ON)
    `uvm_field_int      (write,     UVM_ALL_ON)
    `uvm_field_int      (writedata, UVM_ALL_ON)
    `uvm_field_int      (readdata,  UVM_ALL_ON)
  `uvm_object_utils_end

  extern function new(string name = "");

  // Constraints

  // Read and write should be asserted mutually exclusive
  constraint c_rw_mutex { (read ^ write) == 1; };

endclass : avmm_tr 


function avmm_tr::new(string name = "");
  super.new(name);
endfunction : new

`endif // AVMM_TR_SV

