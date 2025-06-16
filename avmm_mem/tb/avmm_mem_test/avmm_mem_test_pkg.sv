//=============================================================================
// Project  : Industrial HW Verification
//
// File Name: avmm_mem_test_pkg.sv
//
//
// Version:   1.0
//
// Code created by Easier UVM Code Generator version 2016-04-18-EP on Thu Apr 28 06:08:21 2022
//=============================================================================
// Description: Test package for top
//=============================================================================

`ifndef AVMM_MEM_TEST_PKG_SV
`define AVMM_MEM_TEST_PKG_SV

package avmm_mem_test_pkg;

  `include "uvm_macros.svh"

  import uvm_pkg::*;

  import avmm_pkg::*;
  import avmm_mem_pkg::*;

  `include "avmm_pw_seq.sv"
  `include "avmm_mem_test.sv"

endpackage : avmm_mem_test_pkg

`endif // AVMM_MEM_TEST_PKG_SV

