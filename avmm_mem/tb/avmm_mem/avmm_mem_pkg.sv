//=============================================================================
// Project  : Industrial HW Verification
//
// File Name: avmm_mem_pkg.sv
//
//
// Version:   1.0
//
// Code created by Easier UVM Code Generator version 2016-04-18-EP on Thu Apr 28 06:08:21 2022
//=============================================================================
// Description: Package for top
//=============================================================================

package avmm_mem_pkg;

  `include "uvm_macros.svh"

  import uvm_pkg::*;

  import avmm_pkg::*;

  const logic[7:0] page2_write_access_key [1:0] = '{23, 79};

  `include "avmm_mem_tr.sv"
  `include "avmm_mem_config.sv"
  `include "avmm_mem_coverage.sv"
  `include "avmm_mem_scoreboard.sv"
  `include "avmm_mem_env.sv"

endpackage : avmm_mem_pkg

