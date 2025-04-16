library common_lib;
context common_lib.common_context;
use work.avmm_pkg.all;

entity ex6 is
end entity;

architecture behav of ex6 is

  subtype WordT is std_logic_vector(7 downto 0);
  type RegistersT is array(0 to 3) of WordT;
  constant RESET_VAL_C: RegistersT  := ( "01000000", "00001010", "00001010", "00000000" );
  constant WRITE_MASK_C: RegistersT := ( "10111111", "11110000", "11110000", "00000000" );
  shared variable regs: RegistersT := RESET_VAL_C;
  
  signal clk_i: std_logic;
  signal ref_pins_io, pins_io: AvmmPinoutT(
    address(1 downto 0), 
    writedata(7 downto 0), 
    readdata(7 downto 0)
  );

  procedure Write(signal pins: inout AvmmPinoutT; addr: integer; data: std_logic_vector) is
  begin
    pins.address <= std_logic_vector(to_unsigned(addr, pins.address'length));
    pins.read <= '0';
    pins.write <= '1';
    pins.readdata <= "LLLLLLLL";
    pins.writedata <= data;
    WaitForClock(clk_i);
    pins.write <= '0';
    wait for 0 ns;
  end procedure;

  procedure Read(signal pins: inout AvmmPinoutT; addr: integer; variable data: out std_logic_vector) is
  begin
    pins.address <= std_logic_vector(to_unsigned(addr, pins.address'length));
    pins.read <= '1';
    pins.write <= '0';
    pins.writedata <= "00000000";
    WaitForClock(clk_i);
    pins.read <= '0';
    if not pins.readdatavalid then
      wait until pins.readdatavalid;
    end if;
    data := pins.readdata;
    wait for 0 ns;
  end procedure;

  procedure ReferenceModel(signal pins: inout AvmmPinoutT; signal clk: in std_logic) is
    subtype WordT is std_logic_vector(7 downto 0);
    type RegistersT is array(0 to 3) of WordT;
    variable addr: integer;
  begin
    pins <= ((pins.address'range => 'L'), (pins.writedata'range => 'L'), (pins.readdata'range => '0'), 'L', 'L', 'L');
    loop 
      wait until clk'event and clk = '1';
      addr := to_integer(unsigned(pins.address));

      pins.readdatavalid <= '0';
      if pins.read then
        pins.readdata <= regs(addr);
        pins.readdatavalid <= '1';
        -- auto-clear-on-read IF
        if addr = 0 then
          regs(0)(6) := '0';
        end if;
      end if;

      regs(1)(3 downto 0) := regs(1)(7 downto 4) xor regs(2)(3 downto 0);
      if pins.write then
        for i in 0 to 7 loop
          if WRITE_MASK_C(addr)(i) = '1' then
            regs(addr)(i) := pins.writedata(i);
          end if;
        end loop;
      end if;
      regs(3) := std_logic_vector(unsigned(regs(3)) + 1);
      if regs(0)(0) then
        regs := RESET_VAL_C;
      end if;

    end loop;
  end procedure;

begin

  CreateClock(clk_i, 10 ns);

  ref_pins_io.readdatavalid <= 'L';
  ref_pins_io.readdata <= (others => 'L');
  ref_pins_io.address <= pins_io.address;
  ref_pins_io.read <= pins_io.read;
  ref_pins_io.write <= pins_io.write;
  ref_pins_io.writedata <= pins_io.writedata;
  ReferenceModel(ref_pins_io, clk_i);

  dut_inst: entity work.dut
    port map (
      clk_i   => clk_i,
      pins_io => pins_io
    );

  check_p: process is
  begin
    -- Perform the checks (DUT vs reference model). As it is a register interface, it is sufficient to
    -- check the results of read-accesses to the registers.
    -- Enter your code here
  end process;

  stimuli_p: process is
    -- Enter your code here
  begin
    pins_io <= ((others => '0'), (others => '0'), (others => 'L'), 'L', '0', '0');
    -- Implement your main testbench code here
    -- Enter your code here
    Log("**********************************");
    std.env.stop;
    wait ; 
  end process;

end architecture;
