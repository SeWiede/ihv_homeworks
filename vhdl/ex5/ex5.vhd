library common_lib;
context common_lib.common_context;
use work.avmm_pkg.all;

entity ex5 is
end entity;

architecture behav of ex5 is

  -- Define clk_i, trans_io and pins_io with the correct constrained data types
  -- Enter your code here
  signal trans_io : AvmmRecType;
  signal clk_i : std_logic;
  signal pins_io : AvmmPinoutR;

  package ScoreBoardAVMM is new OSVVM.ScoreboardGenericPkg generic map( 
      AvmmPinoutT,
      AvmmPinoutT,
      Match,
      to_string,
      to_string
    );
    use ScoreBoardAVMM.all;

    signal avmmScoreBoardID : ScoreBoardIDType; 

    constant IDLE_PINS : AvmmPinoutR := (
      address => (others => '0'),
      writedata => (others => '0'),
      readdata => (others => '0'),
      byteenable => (others => '0'),
      read => '0',
      write => '0'
    );

    signal testdone : std_logic;

    -- simulating target memory
    type ram_t is array (0 to pins_io.address'length-1) of std_logic_vector(pins_io.writedata'range);
    signal ram : ram_t := (others => (others => '0'));

begin

  CreateClock(clk_i, 10 ns);

  avmm_vu_inst: entity work.avmm_vu
    port map (
      trans_io => trans_io,
      clk_i    => clk_i,
      pins_io  => pins_io
    );

  stimuli_p: process is
    variable poppedPins : AvmmPinoutR;
    variable read_data: std_logic_vector(pins_io.readdata'range);
  begin
    -- Implement your main testbench code here
    -- Enter your code here
    Log("**********************************");
    avmmScoreBoardID <= newId("AVMM Scoreboard");
    waitForClock(clk_i);
    Log("***********Check Empty************");

    push(avmmScoreBoardID, IDLE_PINS);
    check(avmmScoreBoardID, IDLE_PINS);

    Log("***********Check Write************");
    waitForClock(clk_i);
    push(avmmScoreBoardID, (
      address => "00001",
      writedata => x"aa55",
      readdata => x"----",
      byteenable => "11",
      read => '0',
      write => '1'
    ));
    AvmmWrite(trans_io, "00001", x"aa55", "11");

    Log("***********Check Write************");
    waitForClock(clk_i);
    push(avmmScoreBoardID, (
      address => "00001",
      writedata => x"aa55",
      readdata => x"----",
      byteenable => "11",
      read => '0',
      write => '1'
    ));
    AvmmWrite(trans_io, "00001", x"aa55", "11");

    Log("***********Check Read************");
    waitForClock(clk_i);
    push(avmmScoreBoardID, (
      address => "00001",
      writedata => x"----",
      readdata => x"aa55",
      byteenable => "11",
      read => '1',
      write => '0'
    ));
    AvmmRead(trans_io, "00001", "11", read_data); 
    waitForClock(clk_i, 5);

    Log("*****Check Read Modify Write*****");
    waitForClock(clk_i);
    push(avmmScoreBoardID, ( -- cycle 2 read
      address => "00001",
      writedata => x"----",
      readdata => x"aa00",
      byteenable => "10",
      read => '1',
      write => '0'
    ));
    push(avmmScoreBoardID, (
      address => "00001",
      writedata => x"5500",
      readdata => x"----",
      byteenable => "10",
      read => '0',
      write => '1'
    ));
    AvmmReadModifyWrite(trans_io, "00001", x"5511", x"ff00");
    waitForClock(clk_i);
    waitForClock(clk_i);


  --  procedure AvmmWrite(signal trans: inout AddressBusRecType; addr, data, byte_enable: std_logic_vector) is
  --  procedure AvmmRead(signal trans: inout AddressBusRecType; addr, byte_enable: std_logic_vector; variable read_data: out std_logic_vector) is
  --procedure AvmmReadModifyWrite(signal trans: inout AddressBusRecType; addr, data, write_mask: std_logic_vector) is



    ReportAlerts ;
    Log("***************DONE***************");
    std.env.stop;
    wait ; 
  end process;

  -- just a process that handles expected reads
  expected_read_p: process
  begin
    wait until pins_io.read = '1';
    pins_io.readdata <= x"aa55";
    wait until pins_io.read = '1';
    pins_io.readdata <= x"aa00";  
  end process;



  check_reads_p: process
    variable masked : std_logic_vector(pins_io.writedata'range);
  begin
    wait until pins_io.read = '1';

    waitForClock(clk_i, 2);
    check(avmmScoreBoardID, pins_io);
  end process;

  check_writes_p: process
    variable masked : std_logic_vector(pins_io.writedata'range);
  begin
    wait until pins_io.write = '1';

    check(avmmScoreBoardID, pins_io);
    waitForClock(clk_i);
  end process;



  
end architecture;