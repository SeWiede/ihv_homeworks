// You can insert code here by setting file_header_inc in file common.tpl

//=============================================================================
// Project  : generated_tb
//
// File Name: avmm_config.sv
//
//
// Version:   1.0
//
// Code created by Easier UVM Code Generator version 2016-04-18-EP on Thu Apr 28 06:08:21 2022
//=============================================================================
// Description: Configuration for agent avmm
//=============================================================================

`ifndef AVMM_CONFIG_SV
`define AVMM_CONFIG_SV

// You can insert code here by setting agent_config_inc_before_class in file avmm.tpl

class avmm_config extends uvm_object;

  // Do not register config class with the factory

  virtual avmm_if          vif;
                  
  uvm_active_passive_enum  is_active = UVM_ACTIVE;
  bit                      coverage_enable;       
  bit                      checks_enable;         

  // You can insert variables here by setting config_var in file avmm.tpl

  // You can remove new by setting agent_config_generate_methods_inside_class = no in file avmm.tpl

  extern function new(string name = "");

  // You can insert code here by setting agent_config_inc_inside_class in file avmm.tpl

endclass : avmm_config 


// You can remove new by setting agent_config_generate_methods_after_class = no in file avmm.tpl

function avmm_config::new(string name = "");
  super.new(name);
endfunction : new


// You can insert code here by setting agent_config_inc_after_class in file avmm.tpl

`endif // AVMM_CONFIG_SV

