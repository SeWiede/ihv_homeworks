library common_lib;
context common_lib.common_context;

entity ex3 is
end entity;

architecture behav of ex3 is

  -- Define additional signals or constants here as required
  -- Enter your code here
  signal clock: std_logic;
  signal tx_electrical, rx_electrical: std_logic;
  signal tx_optical, rx_optical: std_logic;
  
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
  
end architecture;
