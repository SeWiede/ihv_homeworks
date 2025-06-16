//=============================================================================
// Project  : Industrial HW Verification
//
// File Name: avmm_mem_coverage.sv
//
//
// Version:   1.0
//
// Code created by Easier UVM Code Generator version 2016-04-18-EP on Thu Apr 28 06:08:21 2022
//=============================================================================
// Description: Coverage for agent avmm
//=============================================================================

`ifndef AVMM_MEM_COVERAGE_SV
`define AVMM_MEM_COVERAGE_SV

class avmm_mem_coverage extends uvm_subscriber #(avmm_tr);

  `uvm_component_utils(avmm_mem_coverage)

  avmm_config m_config;    
  bit         m_is_covered;
  avmm_tr     m_item, m_prev_item;
  
  logic [7:0] m_pw_regs[127:126] = '{default: 0};

  typedef enum {READ_E, WRITE_E, WRITE_PAGE_2_LOCKED_E, WRITE_PAGE_2_UNLOCKED_E} access_type_t;

  function access_type_t get_access_type(bit check_page_2_locked = 0);
    if (m_item.read == 1)
      return READ_E;
    else if (m_item.write == 1)
      if (check_page_2_locked)
        if (m_pw_regs == avmm_mem_pkg::page2_write_access_key)
           return WRITE_PAGE_2_UNLOCKED_E;
        else
           return WRITE_PAGE_2_LOCKED_E;
      else
        return WRITE_E;
    else
      `uvm_error("avmm_mem_coverage", "Illegal AVMM transaction!")        
  endfunction: get_access_type


  covergroup m_cov;
    option.per_instance = 0;

    cp_address: coverpoint m_item.address {
      bins zero_addr         = {0};
      bins one_addr          = {1};
      bins page_1_last_addr  = {127};
      bins page_2_first_addr = {128};
      bins page_2_last_addr  = {255};
    }

    cp_read: coverpoint m_item.read {
      bins read  = {1};
    }
    
    cp_write: coverpoint m_item.write {
      bins write  = {1};
    }

    cp_writedata: coverpoint m_item.writedata[7:0] iff m_item.write == 1 {
      bins zero_data = {0};
      bins max_data  = {8'hFF};
      bins special_data_patterns[] = {8'hAA, 8'h55};
    }

    cp_readdata: coverpoint m_item.readdata iff m_item.read == 1 {
      bins zero_data = {0};
      bins max_data  = {8'hFF};
      bins special_data_patterns[] = {8'hAA, 8'h55};    
    }

    // ------------------------------------------------------------------------
    // TODO: Write additional coverage 
    // ------------------------------------------------------------------------

    // ------------------------------------------------------------------------
    // END TODO
    // ------------------------------------------------------------------------

  endgroup

  extern function new(string name, uvm_component parent);
  extern function void write(input avmm_tr t);
  extern function void build_phase(uvm_phase phase);
  extern function void report_phase(uvm_phase phase);

endclass : avmm_mem_coverage 


function avmm_mem_coverage::new(string name, uvm_component parent);
  super.new(name, parent);
  m_is_covered = 0;
  m_cov = new();
endfunction : new


function void avmm_mem_coverage::write(input avmm_tr t);
  // Store previous transaction
  m_prev_item = m_item;
  // Store new transaction
  m_item = t;

  // Remember write accesses to password registers for
  // unlocking write accesses to page 2
  if (t.address inside {127, 126})
    m_pw_regs[t.address] = t.writedata;

  if (m_config.coverage_enable)
  begin    
    m_cov.sample();
    if (m_cov.get_inst_coverage() >= 100) m_is_covered = 1;
  end
endfunction : write


function void avmm_mem_coverage::build_phase(uvm_phase phase);
  if (!uvm_config_db #(avmm_config)::get(this, "", "config", m_config))
    `uvm_error(get_type_name(), "avmm config not found")
endfunction : build_phase


function void avmm_mem_coverage::report_phase(uvm_phase phase);
  if (m_config.coverage_enable)
    `uvm_info(get_type_name(), $sformatf("Coverage score = %3.1f%%", m_cov.get_inst_coverage()), UVM_MEDIUM)
  else
    `uvm_info(get_type_name(), "Coverage disabled for this agent", UVM_MEDIUM)
endfunction : report_phase

`endif // AVMM_MEM_COVERAGE_SV

