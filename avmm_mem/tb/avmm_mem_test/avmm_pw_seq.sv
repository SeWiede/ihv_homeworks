//=============================================================================
// Project  : Industrial HW Verification
//
// File Name: avmm_pw_seq.sv
//
//
// Version:   1.0
//
// Code created by Easier UVM Code Generator version 2016-04-18-EP on Thu Apr 28 06:08:21 2022
//=============================================================================
// Description: Password sequence for agent avmm
//=============================================================================

`ifndef AVMM_PW_SEQ_SV
`define AVMM_PW_SEQ_SV

class avmm_pw_seq extends uvm_sequence #(avmm_tr);

  `uvm_object_utils(avmm_pw_seq)
  
  // Control whether sequence sets or unsets the password for Page 2 access
  bit m_set_password = 1;

  extern function new(string name = "");
  extern task body();

endclass : avmm_pw_seq


function avmm_pw_seq::new(string name = "");
  super.new(name);
endfunction : new


task avmm_pw_seq::body();
  `uvm_info(get_type_name(), "PW sequence starting", UVM_HIGH)
  if (m_set_password) begin
    // --------------------------------------------------------------------------
    // TODO: Create sequence items, which are constrained to write password to
    //       the right registers. Hint: Look at the else branch for inspiration!
    // --------------------------------------------------------------------------

    // --------------------------------------------------------------------------
    // END TODO
    // --------------------------------------------------------------------------
  end
  else begin
    // Create sequence items, which are constrained to overwrite password registers with 0s.
    `uvm_do_with(req, {write == 1; address == 127; writedata == 0; })
    `uvm_do_with(req, {write == 1; address == 126; writedata == 0; })
  end
  `uvm_info(get_type_name(), "PW sequence completed", UVM_HIGH)
endtask : body


`endif // AVMM_PW_SEQ_SV

