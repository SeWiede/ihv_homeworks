//=============================================================================
// Project  : Industrial HW Verification
//
// File Name: avmm_mem_tr.sv
//
//
// Version:   1.0
//
//=============================================================================
// Description: Sequence item for avmm_sequencer
//=============================================================================

`ifndef AVMM_MEM_TR_SV
`define AVMM_MEM_TR_SV

class avmm_mem_tr extends avmm_tr; 

  `uvm_object_utils(avmm_mem_tr)

  // --------------------------------------------------------------------------
  // TODO: Add constraints to meet coverage
  // --------------------------------------------------------------------------

  constraint c_addr_coverage {
    // Bias toward special addresses
    address dist {
      0     := 900,
      1     := 900,
      127   := 900,
      128   := 900,
      255   := 900,
      [2:126]   := 1,
      [129:254] := 1
    };
  }

  constraint c_data_coverage {
    // Bias toward special writedata values
    writedata[7:0] inside {8'h00, 8'hFF, 8'hAA, 8'h55, page2_write_access_key[0], page2_write_access_key[1]};
  }


  // --------------------------------------------------------------------------
  // END TODO
  // --------------------------------------------------------------------------

endclass : avmm_mem_tr 


`endif // AVMM_MEM_TR_SV

