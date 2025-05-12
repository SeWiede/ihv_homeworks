library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use work.common_pkg.all;

entity ex2 is
  port(po: out std_logic := '0');
end entity;

architecture beh of ex2 is

  signal clk1, clk2, pi: std_logic;
  
begin

  Clock(clk1, 20, 10 ns);
  Clock(clk2, 40, 6 ns);
  Waveform(clk1, pi, "00100000001000000000");

  pulse_clk_crosser_inst: entity work.pulse_clk_crosser
    port map (
      clk_in_i  => clk1,
      clk_out_i => clk2,
      pulse_i   => pi,
      pulse_o   => po
    );
  
end architecture;
