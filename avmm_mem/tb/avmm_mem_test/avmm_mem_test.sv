//=============================================================================
// Project  : Industrial HW Verification
//
// File Name: avmm_mem_test.sv
//
//
// Version:   1.0
//
// Code created by Easier UVM Code Generator version 2016-04-18-EP on Thu Apr 28 06:08:21 2022
//=============================================================================
// Description: Test class for top (included in package avmm_mem_test_pkg)
//=============================================================================

`ifndef AVMM_MEM_TEST_SV
`define AVMM_MEM_TEST_SV

class avmm_mem_test extends uvm_test;

  `uvm_component_utils(avmm_mem_test)

  avmm_mem_env m_env;

  // --------------------------------------------------------------------------
  // TODO: Increase iteration count if needed
  // --------------------------------------------------------------------------
  int m_test_iterations = 3;
  // --------------------------------------------------------------------------
  // END TODO
  // --------------------------------------------------------------------------

  extern function new(string name, uvm_component parent);

  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);

endclass : avmm_mem_test


function avmm_mem_test::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

function void avmm_mem_test::build_phase(uvm_phase phase);

  // Create the environment for the test
  m_env = avmm_mem_env::type_id::create("m_env", this);

  // Factory override of avmm_tr transaction with avmm_mem_tr transaction,
  // which contains constraints specific for this test
  set_type_override_by_type(avmm_tr::get_type(), avmm_mem_tr::get_type());

endfunction : build_phase


task avmm_mem_test::run_phase(uvm_phase phase);
  avmm_default_seq random_seq;
  avmm_pw_seq pw_seq;

  phase.raise_objection(this);

  repeat (m_test_iterations) begin

    // Create random test sequence
    random_seq = avmm_default_seq::type_id::create("random_seq");

    // --------------------------------------------------------------------------
    // TODO: Increase transaction count if needed
    // --------------------------------------------------------------------------
    random_seq.m_transaction_count = 10;
    // --------------------------------------------------------------------------
    // END TODO
    // --------------------------------------------------------------------------

    // Start the sequence and pass the desired sequencer
    random_seq.start(m_env.m_avmm_agent.m_sequencer);


    // --------------------------------------------------------------------------
    // TODO: Generate password sequence to either unlock or lock Page 2
    //       write access. You could use, e.g. the function $urandom_range to
    //       randomly decide if the password should be set or reset.
    // --------------------------------------------------------------------------    

    // --------------------------------------------------------------------------
    // END TODO
    // --------------------------------------------------------------------------
    
  end

  // Sequence done => run phase of test may terminate
  phase.drop_objection(this);
endtask : run_phase

`endif // AVMM_MEM_TEST_SV

