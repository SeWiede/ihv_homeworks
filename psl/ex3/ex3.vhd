library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use work.common_pkg.all;

entity ex3 is
end entity;

architecture beh1 of ex3 is
  signal clk, req, ack, busy, done: std_logic;
begin

  Clock(clk, 7);

  Waveform(clk, req, "0100000");
  Waveform(clk, ack, "0010000");
  Waveform(clk, busy, "0001110");
  Waveform(clk, done, "0000001");

end architecture;

architecture beh2 of ex3 is
  signal clk, req, ack, busy, done: std_logic;
begin

  Clock(clk, 14);

  Waveform(clk, req, "10000001000000");
  Waveform(clk, ack, "01000000100000");
  Waveform(clk, busy, "00111000011110");
  Waveform(clk, done, "00000100000001");

end architecture;

architecture beh3 of ex3 is
  signal clk, read_request, gnt, cancel, data_start, data, data_end: std_logic;
begin

  Clock(clk, 22, 10 ns);

  Waveform(clk, read_request, "0010000000000010000000");
  Waveform(clk, gnt,          "0000010000000000001000");
  Waveform(clk, cancel,       "0000000000000000010000");
  Waveform(clk, data_start,   "0000001000000000000000");
  Waveform(clk, data,         "0000000111000000000000");
  Waveform(clk, data_end,     "0000000000100000000000");

end architecture;
