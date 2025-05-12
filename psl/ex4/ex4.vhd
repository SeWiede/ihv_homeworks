library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use work.common_pkg.all;

entity ex4 is
  port (
    rd_valid, rd_done: out std_logic;
    rd_data : out std_logic_vector(7 downto 0)
  );
end entity;

architecture beh of ex4 is

  subtype BurstT is integer range 1 to 7;

  signal clk: std_logic;
  signal rd_ena: std_logic;
  signal rd_burst: BurstT;

  procedure Read(signal rd_ena, rd_valid, rd_done: out std_logic; signal rd_burst: out BurstT; signal rd_data: out std_logic_vector(7 downto 0); burst: BurstT := 1) is
  begin
    rd_valid <= '0';
    rd_done <= '0';
    rd_data <= (others => '0');
    rd_ena <= '0';
    rd_burst <= 1;
    wait until rising_edge(clk);
    rd_ena <= '1';
    rd_burst <= burst;
    wait until rising_edge(clk);
    for i in 1 to burst loop
      if (i mod 3) = 0 then
        rd_valid <= '0';
        rd_data <= (others => '0');
        wait until rising_edge(clk);
      end if;
      rd_valid <= '1';
      rd_data <= "1111" & std_logic_vector(to_unsigned(i, 4));
      wait until rising_edge(clk);
    end loop;
    rd_ena <= '0';
    rd_valid <= '0';
    rd_data <= (others => '0');
    rd_burst <= 1;
    rd_done <= '1';
    wait until rising_edge(clk);
    rd_done <= '0';
    rd_ena <= '0';
    rd_valid <= '0';
    rd_data <= (others => '0');
    rd_burst <= 1;
  end procedure;

begin

  Clock(clk, 90);

  process is
  begin
    for i in 1 to 7 loop
      Read(rd_ena, rd_valid, rd_done, rd_burst, rd_data, i);
      wait until rising_edge(clk);
      wait until rising_edge(clk);
      wait until rising_edge(clk);
    end loop;
    wait;
  end process;

end architecture;
