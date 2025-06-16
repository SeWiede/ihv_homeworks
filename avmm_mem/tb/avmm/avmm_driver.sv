//=============================================================================
// Project  : Industrial HW Verification
//
// File Name: avmm_driver.sv
//
//
// Version:   1.0
//
// Code created by Easier UVM Code Generator version 2016-04-18-EP on Thu Apr 28 06:08:21 2022
//=============================================================================
// Description: Driver for avmm
//=============================================================================

`ifndef AVMM_DRIVER_SV
`define AVMM_DRIVER_SV

class avmm_driver extends uvm_driver #(avmm_tr);

  `uvm_component_utils(avmm_driver)

  // Virtual interface handle
  virtual avmm_if vif;

  extern function new(string name, uvm_component parent);

  extern task run_phase(uvm_phase phase);
  extern task do_drive();

endclass : avmm_driver 


function avmm_driver::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new


task avmm_driver::run_phase(uvm_phase phase);
  `uvm_info(get_type_name(), "run_phase", UVM_HIGH)

  // --------------------------------------------------------------------------
  // TODO: Insert code to drive 0 on all AVMM input signals during reset
  // --------------------------------------------------------------------------

  // --------------------------------------------------------------------------
  // END TODO
  // --------------------------------------------------------------------------

  // --------------------------------------------------------------------------
  // TODO: Insert code to wait until design is out of reset
  // --------------------------------------------------------------------------

  // --------------------------------------------------------------------------
  // END TODO
  // --------------------------------------------------------------------------

  // Process Sequence Items
  forever
  begin
    // Get next transaction from sequencer
    seq_item_port.get_next_item(req);
    `uvm_info(get_type_name(), {"req item\n",req.sprint}, UVM_HIGH)
    do_drive();    
  end
endtask : run_phase


task avmm_driver::do_drive();
  // Drive UUT interface
  vif.address   <= req.address;
  vif.read      <= req.read;
  vif.write     <= req.write;
  vif.writedata <= req.writedata;
  @(posedge vif.clk);
  vif.read <= 0; vif.write <= 0;
  rsp = null;
  if (req.read == 1) begin
    // Wait for readdata
    @(posedge vif.clk);
    // Create response
    rsp = avmm_tr::type_id::create("rsp");
    rsp.copy(req);
    rsp.set_id_info(req);
    rsp.readdata = vif.readdata;
  end
  // Inform sequencer that transaction is done and send back response
  seq_item_port.item_done(rsp); 
endtask

`endif // AVMM_DRIVER_SV

