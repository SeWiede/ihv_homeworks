//=============================================================================
// Project  : Industrial HW Verification
//
// File Name: avmm_agent.sv
//
//
// Version:   1.0
//
// Code created by Easier UVM Code Generator version 2016-04-18-EP on Thu Apr 28 06:08:21 2022
//=============================================================================
// Description: Agent for avmm
//=============================================================================

`ifndef AVMM_AGENT_SV
`define AVMM_AGENT_SV

class avmm_agent extends uvm_agent;

  `uvm_component_utils(avmm_agent)

  uvm_analysis_port #(avmm_tr) analysis_port;

  // Subcomponents
  avmm_config       m_config;
  avmm_sequencer_t  m_sequencer;
  avmm_driver       m_driver;
  avmm_monitor      m_monitor;

  local int m_is_active = -1;

  extern function new(string name, uvm_component parent);

  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern function uvm_active_passive_enum get_is_active();

endclass : avmm_agent 


function  avmm_agent::new(string name, uvm_component parent);
  super.new(name, parent);
  analysis_port = new("analysis_port", this);
endfunction : new


function void avmm_agent::build_phase(uvm_phase phase);

  if (!uvm_config_db #(avmm_config)::get(this, "", "config", m_config))
    `uvm_error(get_type_name(), "avmm config not found")

  m_monitor     = avmm_monitor    ::type_id::create("m_monitor", this);

  // Create sequencer and driver
  if (get_is_active() == UVM_ACTIVE)
  begin
    m_driver    = avmm_driver     ::type_id::create("m_driver", this);
    m_sequencer = avmm_sequencer_t::type_id::create("m_sequencer", this);
  end

endfunction : build_phase


function void avmm_agent::connect_phase(uvm_phase phase);
  if (m_config.vif == null)
    `uvm_warning(get_type_name(), "avmm virtual interface is not set!")

  // Pass on virtual interface to monitor
  m_monitor.vif = m_config.vif;
  m_monitor.analysis_port.connect(analysis_port);

  if (get_is_active() == UVM_ACTIVE)
  begin
    // Connect sequener and driver
    m_driver.seq_item_port.connect(m_sequencer.seq_item_export);
    // Pass on virtual interface to monitor
    m_driver.vif = m_config.vif;
  end

endfunction : connect_phase


function uvm_active_passive_enum avmm_agent::get_is_active();
  if (m_is_active == -1)
  begin
    if (uvm_config_db#(uvm_bitstream_t)::get(this, "", "is_active", m_is_active))
    begin
      if (m_is_active != m_config.is_active)
        `uvm_warning(get_type_name(), "is_active field in config_db conflicts with config object")
    end
    else 
      m_is_active = m_config.is_active;
  end
  return uvm_active_passive_enum'(m_is_active);
endfunction : get_is_active


`endif // AVMM_AGENT_SV

