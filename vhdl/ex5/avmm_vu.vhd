library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use work.avmm_pkg.all;

library osvvm;
context osvvm.OsvvmContext;

library osvvm_common;
context osvvm_common.OsvvmCommonContext;

entity avmm_vu is
  port (
    trans_io: inout AddressBusRecType;
    clk_i   : in    std_logic;
    pins_io : inout AvmmPinoutT
  );
end entity;

architecture behav of avmm_vu is

  -- Enter your code here

  constant IDLE_PINS : AvmmPinoutT := (
    address => (pins_io.address'range => '0'),
    writedata => (pins_io.writedata'range => '0'),
    readdata => (pins_io.readdata'range => 'Z'), -- VU is not supposed to drive this
    byteenable => (pins_io.byteenable'range => '0'),
    read => '0',
    write => '0'
  );
begin

  sequencer_p: process is
    variable read_data : std_logic_vector(pins_io.readdata'range);
    variable wait_cycles_v : integer;
  begin
    -- apply default values to the pins
    -- Enter your code here

    pins_io <= IDLE_PINS;

    wait for 0 ns;
    dispatcher_loop: loop
      WaitForTransaction(clk => clk_i, Rdy => trans_io.Rdy, Ack => trans_io.Ack);
      case trans_io.Operation is
        when WRITE_OP =>
          pins_io.address <= std_logic_vector(trans_io.Address);
          pins_io.writedata <= std_logic_vector(trans_io.DataToModel);
          pins_io.write <= '1';
          pins_io.byteenable <= std_logic_vector(to_unsigned(trans_io.IntToModel, pins_io.byteenable'length));
          WaitForClock(clk_i, 1);
          pins_io <= IDLE_PINS;
          wait for 0 ns;
        when READ_OP =>
          pins_io.address <= std_logic_vector(trans_io.Address);
          pins_io.read <= '1';
          pins_io.byteenable <= std_logic_vector(to_unsigned(trans_io.IntToModel, pins_io.byteenable'length));
          WaitForClock(clk_i, 2);
          wait for 0 ns;
          trans_io.DataFromModel <= ToTransaction(pins_io.readdata);
          pins_io <= IDLE_PINS;
          wait for 0 ns;
        when others => -- not part of coverage
          Alert("Unimplemented Transaction", FAILURE);
      end case;
    end loop;
  end process;

end architecture;
