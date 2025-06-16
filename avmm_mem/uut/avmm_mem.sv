//=============================================================================
// Project  : Industrial HW Verification
//
// File Name: avmm_mem.sv
//
//
// Version:   1.0
//
//=============================================================================
// Description: Memory module accessible through AVMM interface.
//              Memory has two pages:
//              Page 1: Address in [0, 127]
//              Page 2: Address in [128, 255]
//              Page 2 is write-protected. Write-protection can be
//              unlocked by writing a password to addresses 126 and 127.
//=============================================================================

module avmm_mem (input  logic       clk, rst_n,
                 input  logic[7:0]  address,
                 input  logic       write, read,
                 input  logic[31:0] writedata,
                 output logic[31:0] readdata);

  logic [7:0] mem [255:0] = '{default:0};

  const logic[7:0] page2_write_access_key [1:0] = '{23, 79};

  always @(posedge clk) begin
    if (write) begin       
      if ((address < 128) || 
        (mem[127:126] == page2_write_access_key)) begin
        mem[address] <= writedata[7:0];
      end
    end  
    if (read) begin
      readdata <= mem[address];
    end
    if (!rst_n) begin
      readdata <= 0;
    end
  end
  
endmodule : avmm_mem
