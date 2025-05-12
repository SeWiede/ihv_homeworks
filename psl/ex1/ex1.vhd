library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use work.common_pkg.all;

entity ex1 is
end entity;

architecture beh of ex1 is
  signal clk, a, b, c: std_logic;
begin

  Clock(clk, 6);

  Waveform(clk, a, "011010");
  Waveform(clk, b, "001001");
  Waveform(clk, c, "011011");

end architecture;
