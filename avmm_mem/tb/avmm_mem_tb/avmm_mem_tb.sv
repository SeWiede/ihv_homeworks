//=============================================================================
// Project  : Industrial HW Verification
//
// File Name: avmm_mem_tb.sv
//
//
// Version:   1.0
//
// Code created by Easier UVM Code Generator version 2016-04-18-EP on Thu Apr 28 06:08:21 2022
//=============================================================================
// Description: Testbench
//=============================================================================

module avmm_mem_tb;

  timeunit      1ns;
  timeprecision 1ps;

  `include "uvm_macros.svh"

  import uvm_pkg::*;

  import avmm_mem_test_pkg::*;
  import avmm_mem_pkg::avmm_mem_config;

  // Configuration object for top-level environment
  avmm_mem_config avmm_mem_env_config;

  // Test harness
  avmm_mem_th th();

  initial
  begin
    // Create and populate top-level configuration object
    avmm_mem_env_config = new("avmm_mem_env_config");
    if ( !avmm_mem_env_config.randomize() )
      `uvm_error("avmm_mem_tb", "Failed to randomize top-level configuration object" )

    avmm_mem_env_config.avmm_vif             = th.avmm_if_0;
    avmm_mem_env_config.is_active_avmm       = UVM_ACTIVE;  
    avmm_mem_env_config.checks_enable_avmm   = 1;           
    avmm_mem_env_config.coverage_enable_avmm = 1;           

    uvm_config_db #(avmm_mem_config)::set(null, "uvm_test_top.m_env", "config", avmm_mem_env_config);

    // Run test specified by UVM_TESTNAME simulator argument
    run_test();
  end

endmodule

