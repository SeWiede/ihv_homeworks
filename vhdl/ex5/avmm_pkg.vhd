library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

library osvvm;
  context osvvm.OsvvmContext;

library osvvm_common ;
  context osvvm_common.OsvvmCommonContext ; 

package avmm_pkg is

  type AvmmPinoutT is record
    address            : std_logic_vector;
    writedata          : std_logic_vector;
    readdata           : std_logic_vector;
    byteenable         : std_logic_vector;
    read               : std_logic;
    write              : std_logic;
  end record;

  procedure AvmmWrite(signal trans: inout AddressBusRecType; addr, data, byte_enable: std_logic_vector);
  procedure AvmmRead(signal trans: inout AddressBusRecType; addr, byte_enable: std_logic_vector; variable read_data: out std_logic_vector);
  procedure AvmmReadModifyWrite(signal trans: inout AddressBusRecType; addr, data, write_mask: std_logic_vector);

  /*
    type AddressBusRecType is record
    -- Handshaking controls
    --   Used by RequestTransaction in the Transaction Procedures
    --   Used by WaitForTransaction in the Verification Component
    --   RequestTransaction and WaitForTransaction are in osvvm.TbUtilPkg
    Rdy                : RdyType ;
    Ack                : AckType ;
    -- Transaction Type
    Operation          : AddressBusOperationType ;
    -- Address to verification component and its width
    -- Width may be smaller than Address
    Address            : std_logic_vector_max_c ;
    AddrWidth          : integer_max ;
    -- Data to and from the verification component and its width.
    -- Width will be smaller than Data for byte operations
    -- Width size requirements are enforced in the verification component
    DataToModel        : std_logic_vector_max_c ;
    DataFromModel      : std_logic_vector_max_c ;
    DataWidth          : integer_max ;
    -- Burst FIFOs
    WriteBurstFifo     : ScoreboardIdType ; 
    ReadBurstFifo      : ScoreboardIdType ; 
    --    UseCheckFifo       : boolean_max ; 
    --    CheckFifo          : ScoreboardIdType ; 
    -- Parameters - internal settings for the VC in a singleton data structure   
    Params             : ModelParametersIDType ;  
    -- StatusMsgOn provides transaction messaging override.
    -- When true, print transaction messaging independent of 
    -- other verification based based controls.
    StatusMsgOn        : boolean_max ;
    -- Verification Component Options Parameters - used by SetModelOptions
    IntToModel         : integer_max ;
    IntFromModel       : integer_max ; 
    BoolToModel        : boolean_max ; 
    BoolFromModel      : boolean_max ;
    TimeToModel        : time_max ; 
    TimeFromModel      : time_max ; 
    -- Verification Component Options Type  
    Options            : integer_max ;  
    end record AddressBusRecType ;
  */

  subtype AvmmRecType is AddressBusRecType(
    Address(4 downto 0),
    DataToModel(15 downto 0),
    DataFromModel(15 downto 0)
  );
  subtype AvmmPinoutR is AvmmPinoutT(    
    address(4 downto 0),
    writedata(15 downto 0),
    readdata(15 downto 0),
    byteenable(1 downto 0)
    );

  function to_string(val: AvmmPinoutT) return string;
  function Match (
    constant  Actual          : in    AvmmPinoutT ;
    constant  Expected        : in    AvmmPinoutT
  ) return boolean; 
end package;

package body avmm_pkg is
  function to_string(val: AvmmPinoutT) return string is
  begin
    return "AvmmPinoutT: address(0x" & to_string(val.address) &
      ") writedata(0x" & to_string(val.writedata)  &
      ") readdata(0x" & to_string(val.readdata) &
      ") byteenable(0x" & to_string(val.byteenable) &
      ") read(" & to_string(val.read) &
      ") write(" & to_string(val.write) & ");";
  end function;

  function Match (
      constant  Actual   : in AvmmPinoutT ;
      constant  Expected : in AvmmPinoutT
    ) return boolean is
  begin
    return (Actual.address = Expected.address) and
           (Actual.write = '0' -- dont care otherwise
              or (Actual.write = '1' and Actual.writedata = Expected.writedata)) and 
           (Actual.read = '0' -- dont care otherwise
              or (Actual.read = '1' and Actual.readdata = Expected.readdata)) and 
           (Actual.byteenable = Expected.byteenable) and
           (Actual.read = Expected.read) and
           (Actual.write = Expected.write);
  end function;

  procedure AvmmWrite(signal trans: inout AddressBusRecType; addr, data, byte_enable: std_logic_vector) is
  begin
    -- Enter your code here
    trans.intToModel <= to_integer(unsigned(byte_enable));
    write(trans, addr, data);
  end procedure;

  procedure AvmmRead(signal trans: inout AddressBusRecType; addr, byte_enable: std_logic_vector; variable read_data: out std_logic_vector) is
    variable data : std_logic_vector(trans.dataFromModel'range) := (others => '0');
  begin
    -- Enter your code here
    trans.intToModel <= to_integer(unsigned(byte_enable));
    read(trans, addr, data);
    read_data := data;
  end procedure;

  procedure AvmmReadModifyWrite(signal trans: inout AddressBusRecType; addr, data, write_mask: std_logic_vector) is
    variable data_r : std_logic_vector(trans.dataFromModel'range) := (others => '0');
    variable byte_enable : std_logic_vector(trans.dataFromModel'length - 1 / 8 downto 0) := (others => '0');
  begin
    for i in 0 to write_mask'length / 8 - 1 loop
      if unsigned(write_mask(i*8 to (i+1)*8-1)) > 0 then
        byte_enable(write_mask'length / 8 - 1 - i) := '1';
      end if;
    end loop;

    trans.intToModel <= to_integer(unsigned(byte_enable));
    read(trans, addr, data_r);
    -- additonal step, not done by avmm
    data_r := (data_r and not write_mask) or (data and write_mask);
    write(trans, addr, data_r);
  end procedure;
  
end package body;