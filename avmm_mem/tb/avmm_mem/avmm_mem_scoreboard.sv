//=============================================================================
// Project  : Industrial HW Verification
//
// File Name: avmm_if.sv
//
//
// Version:   1.0
//=============================================================================
// Description: Scoreboard for avmm_mem module
//=============================================================================


class avmm_mem_scoreboard extends uvm_scoreboard;
 
  `uvm_component_utils(avmm_mem_scoreboard)
  uvm_analysis_imp#(avmm_tr, avmm_mem_scoreboard) item_collected_export;

  logic [7:0] mem [255:0] = '{default:0};

  extern function new (string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase); 
  extern virtual function void write(avmm_tr tr);
 
endclass : avmm_mem_scoreboard


function avmm_mem_scoreboard::new (string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

 
function void avmm_mem_scoreboard::build_phase(uvm_phase phase);
  super.build_phase(phase);
  item_collected_export = new("item_collected_export", this);
endfunction: build_phase

   
function void avmm_mem_scoreboard::write(avmm_tr tr);
  if (tr.write) begin
    if ((tr.address < 128) ||
      (mem[127:126] == avmm_mem_pkg::page2_write_access_key)) begin
      mem[tr.address] = tr.writedata;
    end
  end
  if (tr.read) begin
    if (mem[tr.address] != tr.readdata) begin
      `uvm_error(get_type_name(),
        $sformatf("Readdata did not match (address: 0x%0x, expected: 0x%0x, actual: 0x%0x).", 
          tr.address, mem[tr.address], tr.readdata))
	tr.print();
    end
    else begin
      `uvm_info(get_type_name(),
        $sformatf("Readdata sucessfully verified (address: 0x%0x, data: 0x%0x).", 
          tr.address, tr.readdata), UVM_LOW)
    end
  end
endfunction : write
