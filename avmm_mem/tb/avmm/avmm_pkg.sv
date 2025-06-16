//=============================================================================
// Project  : Industrial HW Verification
//
// File Name: avmm_pkg.sv
//
//
// Version:   1.0
//
// Code created by Easier UVM Code Generator version 2016-04-18-EP on Thu Apr 28 06:08:21 2022
//=============================================================================
// Description: Package for agent avmm
//=============================================================================

package avmm_pkg;

  `include "uvm_macros.svh"

  import uvm_pkg::*;

  `include "avmm_tr.sv"
  `include "avmm_config.sv"
  `include "avmm_driver.sv"
  `include "avmm_monitor.sv"
  `include "avmm_sequencer.sv"
  `include "avmm_agent.sv"
  `include "avmm_default_seq.sv"

endpackage : avmm_pkg
