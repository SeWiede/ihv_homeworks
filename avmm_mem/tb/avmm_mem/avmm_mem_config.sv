//=============================================================================
// Project  : Industrial HW Verification
//
// File Name: avmm_mem_config.sv
//
//
// Version:   1.0
//
// Code created by Easier UVM Code Generator version 2016-04-18-EP on Thu Apr 28 06:08:21 2022
//=============================================================================
// Description: Configuration for top
//=============================================================================

`ifndef AVMM_MEM_CONFIG_SV
`define AVMM_MEM_CONFIG_SV

class avmm_mem_config extends uvm_object;

  virtual avmm_if          avmm_vif;            

  uvm_active_passive_enum  is_active_avmm       = UVM_ACTIVE;
  bit                      checks_enable_avmm;  
  bit                      coverage_enable_avmm;

  extern function new(string name = "");

endclass : avmm_mem_config 


function avmm_mem_config::new(string name = "");
  super.new(name);
endfunction : new

`endif // AVMM_MEM_CONFIG_SV

