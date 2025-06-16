//=============================================================================
// Project  : Industrial HW Verification
//
// File Name: avmm_default_seq.sv
//
//
// Version:   1.0
//
// Code created by Easier UVM Code Generator version 2016-04-18-EP on Thu Apr 28 06:08:21 2022
//=============================================================================
// Description: Sequence for agent avmm
//=============================================================================

`ifndef AVMM_DEFAULT_SEQ_SV
`define AVMM_DEFAULT_SEQ_SV

class avmm_default_seq extends uvm_sequence #(avmm_tr);

  `uvm_object_utils(avmm_default_seq)

  int m_transaction_count = 10;

  extern function new(string name = "");
  extern task body();

endclass : avmm_default_seq


function avmm_default_seq::new(string name = "");
  super.new(name);
endfunction : new


task avmm_default_seq::body();
  `uvm_info(get_type_name(), "Default sequence starting", UVM_HIGH)

  repeat(m_transaction_count) begin
    req = avmm_tr::type_id::create("req");
    // Start new transaction (send request to seqeuncer)
    start_item(req); 
    if ( !req.randomize() )
      `uvm_error(get_type_name(), "Failed to randomize transaction")
    // Wait until transaction has been completed by driver
    finish_item(req); 
    // Get response create by driver in case of a read access
    if (req.read) begin
      get_response(rsp);      
    end    
  end

  `uvm_info(get_type_name(), "Default sequence completed", UVM_HIGH)
endtask : body


`endif // AVMM_DEFAULT_SEQ_SV

