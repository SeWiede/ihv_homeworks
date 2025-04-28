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


  shared variable readCov : CovPType;
  shared variable writeCov : CovPType;
  shared variable readAfterWriteCov : CovPType;
  shared variable b2breadCov : CovPType;
  shared variable writeDifferentReadCov : CovPType;
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
    
    wait until ref_pins_io.read = '1';
    wait until ref_pins_io.readdatavalid = '1';
    wait for 0 ns;

    AffirmIfEqual(pins_io.readdata, ref_pins_io.readdata, 
                  "readdata on address " & to_string(pins_io.address) 
                  & " should be " & to_string(ref_pins_io.readdata)
                  & " was " & to_string(pins_io.readdata) );
  end process;

  stimuli_p: process is
    -- Enter your code here
    variable read_data,read_data1 : std_logic_vector(7 downto 0);
    variable address : integer;

    variable RV : RandomPType;

    variable testIterations : integer := 0;
    variable write_data : std_logic_vector(7 downto 0);
    variable rwaddrs : integer_vector(0 to 1);
  begin
    pins_io <= ((others => '0'), (others => '0'), (others => 'L'), 'L', '0', '0');
    -- Implement your main testbench code here
    -- Enter your code here

    rv.InitSeed(RV'instance_name);

    readCov.SetName("Simple Read Coverage");
    readCov.AddBins("address", GenBin(0, 2**pins_io.address'length-1));

    writeCov.SetName("Simple Write Coverage");
    writeCov.AddBins("address", GenBin(0, 2**pins_io.address'length-1));

    readAfterWriteCov.SetName("ReadAfterWrite Coverage");
    readAfterWriteCov.AddBins("address", GenBin(0, 2**pins_io.address'length-1));

    b2breadCov.SetName("Back to Back Read Coverage");
    b2breadCov.AddBins("b2bReads", GenBin(0, 2**pins_io.address'length-1));

    writeDifferentReadCov.SetName("Write but read seomwhere else");
    writeDifferentReadCov.AddCross("writeDifferentRead", GenBin(0, 2**pins_io.address'length-1), GenBin(0, 2**pins_io.address'length-1));

    -- reset first
    Write(pins_io, 0, x"01");
    WaitForClock(clk_i, 2);

    while testIterations < 100 
      or not readCov.IsCovered 
      or not writeCov.IsCovered
      or not readAfterWriteCov.IsCovered
      or not b2breadCov.IsCovered
      or not writeDifferentReadCov.IsCovered
    loop
      -- random operation
      case RV.DistInt((15, 15, 15 ,15, 20, 10)) is
      --case RV.DistInt((100,0, 0 , 0, 50)) is
        when 0 => -- just read
          log("just reading");
          -- IF does not always clear
          address  := readCov.RandCovPoint;
          Read(pins_io, 3, read_data);
          readCov.ICover(address);
        when 1 => -- just write random data
          log("just writing");
          address  := writeCov.RandCovPoint;
          write_data := RV.RandSlv(pins_io.writedata'length);
          -- keep old data (assume regs has correct data )
          write_data := (regs(address) and not WRITE_MASK_C(address)) or (write_data and WRITE_MASK_C(address));
          Write(pins_io, address, write_data); -- contrain to spec
          writeCov.ICover(address);
        when 2 => -- write immediately read
          log("just randomly writing then reading");
          address  := readAfterWriteCov.RandCovPoint;
          write_data := RV.RandSlv(pins_io.writedata'length);
          -- keep old data (assume regs has correct data )
          write_data := (regs(address) and not WRITE_MASK_C(address)) or (write_data and WRITE_MASK_C(address));
          Write(pins_io, address, write_data); -- contrain to spec
          Read(pins_io, address, read_data);
          readAfterWriteCov.ICover(address);
        when 3 =>
          log("b2b reading");
          address  := b2breadCov.RandCovPoint;
          Read(pins_io, address, read_data);
          Read(pins_io, address, read_data1);
          if address = 3 then
            -- CNT does not always increment
            AlertIfEqual(read_data, read_data1, "Must be off-by-one");
          end if;
          Log("data1 = "  & to_string(read_data) & ", data2 = " & to_string(read_data1));
          b2breadCov.ICover(address);
        when 4 =>
          log("write but read somewhere else");
          rwaddrs := writeDifferentReadCov.RandCovPoint;
          write_data := RV.RandSlv(pins_io.writedata'length);
          Write(pins_io, rwaddrs(0), write_data);
          Read(pins_io, rwaddrs(1), read_data1);
          writeDifferentReadCov.ICover(rwaddrs);
        when 5 =>
          log("occasional reset");
          Write(pins_io, 0, x"01");
        when others =>
          assert false severity failure;
      end case;

      WaitForClock(clk_i, 2);
      testIterations := testIterations + 1;
    end loop;

    log("Read coverage: " & to_String(readCov.GetCov));
    log("Write coverage: " & to_String(writeCov.GetCov));
    log("ReadAfterWrite coverage: " & to_String(readAfterWriteCov.GetCov));


    ReportAlerts;
    Log("**********************************");
    std.env.stop;
    wait ; 
  end process;

end architecture;

/*
  Can you find such “features/bugs” using constrained random testing? Which ones?

 - Some readonly fields are (sometimes) writable
 - Counters (regs(3)) are off by one after reset
 - Counters (regs(3)) does not always count (can get stuck)
 - IF does not always clear after
 - CHK is not always NAME xor ID
*/