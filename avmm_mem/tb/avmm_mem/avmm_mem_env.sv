//=============================================================================
// Project  : Industrial HW Verification
//
// File Name: avmm_mem_env.sv
//
//
// Version:   1.0
//
// Code created by Easier UVM Code Generator version 2016-04-18-EP on Thu Apr 28 06:08:21 2022
//=============================================================================
// Description: Environment for top
//=============================================================================

`ifndef AVMM_MEM_ENV_SV
`define AVMM_MEM_ENV_SV

class avmm_mem_env extends uvm_env;

  `uvm_component_utils(avmm_mem_env)

  extern function new(string name, uvm_component parent);

  // Child agents
  avmm_config    m_avmm_config;  
  avmm_agent     m_avmm_agent;   
  
  // Scoreboard
  avmm_mem_scoreboard m_scoreboard;
  // Coverage
  avmm_mem_coverage   m_coverage;
  // Configuration
  avmm_mem_config     m_config;

  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern function void end_of_elaboration_phase(uvm_phase phase);

endclass : avmm_mem_env 

function avmm_mem_env::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

function void avmm_mem_env::build_phase(uvm_phase phase);
  `uvm_info(get_type_name(), "In build_phase", UVM_HIGH)

  // Fetch the top-level config from DB
  if (!uvm_config_db #(avmm_mem_config)::get(this, "", "config", m_config)) 
    `uvm_error(get_type_name(), "Unable to get avmm_mem_config")

  // Create configuration object for agent / scoreboard / coverage
  m_avmm_config                 = new("m_avmm_config");         
  m_avmm_config.vif             = m_config.avmm_vif;            
  m_avmm_config.is_active       = m_config.is_active_avmm;      
  m_avmm_config.checks_enable   = m_config.checks_enable_avmm;  
  m_avmm_config.coverage_enable = m_config.coverage_enable_avmm;

  // Put config object into the config DB
  uvm_config_db#(avmm_config)::set(this, "m_avmm_agent", "config", m_avmm_config);
  uvm_config_db#(avmm_config)::set(this, "m_coverage",   "config", m_avmm_config);
  uvm_config_db#(avmm_config)::set(this, "m_scoreboard", "config", m_avmm_config);

  // Create subcomponents
  m_avmm_agent    = avmm_agent         ::type_id::create("m_avmm_agent", this);
  m_coverage      = avmm_mem_coverage  ::type_id::create("m_coverage", this);
  m_scoreboard    = avmm_mem_scoreboard::type_id::create("m_scoreboard", this);

endfunction : build_phase

function void avmm_mem_env::connect_phase(uvm_phase phase);
  `uvm_info(get_type_name(), "In connect_phase", UVM_HIGH)

  // --------------------------------------------------------------------------
  // TODO: Connect analysis port of agent to analysis imp ports of coverage
  //       class and scoreboard
  // --------------------------------------------------------------------------

  // --------------------------------------------------------------------------
  // END TODO
  // --------------------------------------------------------------------------

endfunction : connect_phase

function void avmm_mem_env::end_of_elaboration_phase(uvm_phase phase);  
   uvm_factory factory = uvm_factory::get();

  `uvm_info(get_type_name(), "Information printed from avmm_mem_env::end_of_elaboration_phase method", UVM_MEDIUM)
  `uvm_info(get_type_name(), $sformatf("Verbosity threshold is %d", get_report_verbosity_level()), UVM_MEDIUM)

  // Print testbench hierarchy
  uvm_top.print_topology();
  
  // Print all components registered in the UVM factory
  factory.print();
endfunction : end_of_elaboration_phase


`endif // AVMM_MEM_ENV_SV

