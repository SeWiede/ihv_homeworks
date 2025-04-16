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

begin

  sequencer_p: process is
  begin
    -- apply default values to the pins
    -- Enter your code here
    wait for 0 ns;
    dispatcher_loop: loop
      WaitForTransaction(clk => clk_i, Rdy => trans_io.Rdy, Ack => trans_io.Ack);
      case trans_io.Operation is
        when WRITE_OP =>
          -- Enter your code here

        when READ_OP =>
          -- Enter your code here

        when others =>
          Alert("Unimplemented Transaction", FAILURE);
          
      end case;
    end loop;
  end process;

end architecture;
