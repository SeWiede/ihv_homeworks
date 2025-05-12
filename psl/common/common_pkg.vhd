library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

package common_pkg is

  procedure Clock(signal clk: out std_logic; cnt: integer; period: time := 10 ns);
  procedure Waveform(signal clk: in std_logic; signal sig: out std_logic; waveform: std_logic_vector);
  
end package;

package body common_pkg is
  
  procedure Waveform(signal clk: in std_logic; signal sig: out std_logic; waveform: std_logic_vector) is
  begin
    for i in waveform'range loop
      sig <= waveform(i);
      wait until rising_edge(clk);
    end loop;
    wait;
  end procedure;

  procedure Clock(signal clk: out std_logic; cnt: integer; period: time := 10 ns) is
  begin
    for i in 1 to cnt loop
      clk <= '1';
      wait for period / 2;
      clk <= '0';
      wait for period / 2;
    end loop;
    wait;
  end procedure;
 
end package body;
