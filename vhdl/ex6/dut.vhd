library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

  use work.avmm_pkg.all;

entity dut is
  port (
    signal clk_i: in std_logic;
    signal pins_io: inout AvmmPinoutT(
      address(1 downto 0), 
      writedata(7 downto 0), 
      readdata(7 downto 0)
    )
  );
end entity;

architecture behav of dut is

  subtype WordT is std_logic_vector(7 downto 0);
  type RegistersT is array(0 to 3) of WordT;

  constant RESET_VAL_C: RegistersT := (
    "01000000",
    "00001010",
    "00001010",
    "00000000"
  );
  signal regs_s: RegistersT := RESET_VAL_C;
  
begin

  faulty_model_p: process(clk_i) is
  begin
    if rising_edge(clk_i) then
      -- Clear on Write
      regs_s(0)(0) <= '0'; 
      -- Writeable
      if pins_io.write then
        regs_s(to_integer(unsigned(pins_io.address))) <= pins_io.writedata;
        -- Enter your code here
      end if;
      -- RO fields
      if regs_s(2)(7) = '0' then
        regs_s(1)(3 downto 0) <= regs_s(2)(3 downto 0) xor regs_s(1)(7 downto 4);
      else
        -- Enter your code here
        regs_s(1)(3 downto 0) <= regs_s(2)(3 downto 0) and regs_s(1)(7 downto 4);
      end if;
      regs_s(2)(3 downto 0) <= "1010";
      if regs_s(0)(2) = '0' then
        -- Enter your code here
        regs_s(3) <= std_logic_vector(unsigned(regs_s(3)) + 1);
      end if;

      pins_io.readdatavalid <= '0';
      if pins_io.read then
        pins_io.readdata <= regs_s(to_integer(unsigned(pins_io.address)));
        pins_io.readdatavalid <= '1';
        if pins_io.address = "00" then
          -- clear on read
          if regs_s(0)(5) = '0' then
            -- Enter your code here
            regs_s(0)(6) <= '0';
          end if;
        end if;
      end if;

      -- reset
      if regs_s(0)(0) = '1' then
        regs_s <= RESET_VAL_C;
      end if;
    end if;
  end process;

end architecture;
