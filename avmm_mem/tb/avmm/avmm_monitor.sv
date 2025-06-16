//=============================================================================
// Project  : Industrial HW Verification
//
// File Name: avmm_monitor.sv
//
//
// Version:   1.0
//
// Code created by Easier UVM Code Generator version 2016-04-18-EP on Thu Apr 28 06:08:21 2022
//=============================================================================
// Description: Monitor for avmm
//=============================================================================

`ifndef AVMM_MONITOR_SV
`define AVMM_MONITOR_SV

class avmm_monitor extends uvm_monitor;

  `uvm_component_utils(avmm_monitor)

  // Virtual interface handle
  virtual avmm_if vif;
  // Analysis port
  uvm_analysis_port #(avmm_tr) analysis_port;

  avmm_tr m_trans;

  extern function new(string name, uvm_component parent);
  extern task run_phase(uvm_phase phase);
  extern task do_mon();

endclass : avmm_monitor 


function avmm_monitor::new(string name, uvm_component parent);
  super.new(name, parent);
  analysis_port = new("analysis_port", this);
endfunction : new


task avmm_monitor::run_phase(uvm_phase phase);
  `uvm_info(get_type_name(), "run_phase", UVM_HIGH)
  
  do_mon();
endtask : run_phase


task avmm_monitor::do_mon;
  forever @(posedge vif.clk)
  begin
    if (vif.read || vif.write) begin
      m_trans = avmm_tr::type_id::create("m_trans");
     // Read UUT interface and populate transaction fields
      m_trans.read = vif.read;
      m_trans.write = vif.write;
      m_trans.address = vif.address;
      m_trans.writedata = vif.writedata;
      m_trans.readdata = 0;
      if (vif.read == 1) begin
        @(posedge vif.clk);
        m_trans.readdata = vif.readdata;
      end
      // Broadcast transaction
      analysis_port.write(m_trans);
    end
  end
endtask


`endif // AVMM_MONITOR_SV

