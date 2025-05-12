library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pulse_clk_crosser is
  port (
    clk_in_i       : in  std_logic;
    clk_out_i      : in  std_logic;
    pulse_i        : in  std_logic;
    pulse_o        : out std_logic
  );
end entity;

architecture rtl of pulse_clk_crosser is

  signal pcc_pulse_s                      : std_logic := '0';
  signal toggle_signal_s                  : std_logic := '0';
  signal pulse_clock_crosser_cross_data_s : std_logic := '0';
  signal pulse_detect_s                   : std_logic := '0';
  signal pulse_detect_ss                  : std_logic := '0';

begin

  process (clk_in_i)
  begin
    if rising_edge(clk_in_i) then
      pcc_pulse_s <= pulse_i;
      if pulse_i = '1' then
        toggle_signal_s <= not toggle_signal_s;
      end if;
    end if;
  end process;

  process (clk_out_i)
  begin
    if rising_edge(clk_out_i) then
      pulse_clock_crosser_cross_data_s <= toggle_signal_s;
      pulse_detect_s   <= pulse_clock_crosser_cross_data_s;
      pulse_detect_ss  <= pulse_detect_s;

      pulse_o <= '0';
      if pulse_detect_s = not pulse_detect_ss then
        pulse_o <= '1';
      end if;
    end if;
  end process;

end rtl;
