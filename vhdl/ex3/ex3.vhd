library common_lib;
context common_lib.common_context;

entity ex3 is
end entity;

architecture behav of ex3 is

  -- Define additional signals or constants here as required
  -- Enter your code here
  signal clock: std_logic;
  signal tx_electrical, rx_electrical, rx_electrical_int: std_logic;
  signal tx_optical, rx_optical, tx_optical_int, rx_optical_int: std_logic;
  
  constant propagation_delay: time := 23 ns;
  constant high_threshold: real := 0.632;
  constant low_threshold: real := 0.368;
  constant Vcc: real := 3.3; -- Example Vcc
  
  constant tau: time := 2.5 us; -- R * C


  constant EO_delay: time := 32 ns; -- electrical to optical delay
  constant fiber_delay: time := 600 ns; -- 120m/(200.000km/h)
begin

  CreateClock(clock, 600 us);
  tx_electrical <= clock;
  tx_optical <= clock;

  stimuli_p: process is
  begin
    wait for 10 ms;
    Log("**********************************");
    std.env.stop;
    wait ; 
  end process;

  -- Implement the transmission line, ie. assign a correctly delayed version of 'tx' onto 'rx'
  -- for both the electrical and the optical transmission lines
  -- Enter your code here

  -- electrical:
  rx_electrical_int <= transport tx_electrical after propagation_delay; -- pure delay to RX; only then interial
  rx_electrical <= rx_electrical_int after tau; -- intertial delay: filter out pulses < tau

  process(rx_electrical)
  begin
    report "rx_electrical: " & std_logic'image(rx_electrical);
  end process;

  -- optical:
  tx_optical_int <= reject 20 ns inertial tx_optical after EO_delay; -- inertial to fiber, reject glitches
  rx_optical_int <= transport tx_optical_int after fiber_delay; -- fiber is pure delay to RX
  rx_optical <= reject 20 ns inertial rx_optical_int after EO_delay; -- inertial from fiber, reject glitches
  
  process(rx_optical)
  begin
    report "rx_optical: " & std_logic'image(rx_optical);
  end process;

end architecture;
