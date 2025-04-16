library common_lib;
context common_lib.common_context;
  
entity ex2 is
end entity;

architecture behav of ex2 is

  type StateT is (Idle, Invert, NotAffected, Keep);
  signal state: StateT := Idle;
  signal clock, clock_n, output: std_logic := '0';
  signal eventCounter: integer := -1;
  signal transCounter: integer := -1;
  -- Enter your code here
  
begin

  CreateClock(clock, 10 ns);
  clock_n <= not clock;

  state_p: process (clock) is
  begin
    if rising_edge(clock) then
      case state is
        when Idle =>
          output <= '0';
        when Invert =>
          output <= not output;
        when NotAffected =>
          output <= unaffected;
        when Keep =>
          output <= output;
      end case;
    end if;
  end process;

  -- Enter your code here

  stimuli_p: process is
  begin
    -- During initialization, the process is evaluated until the first wait statement
    wait for 0 ns;
    state <= Idle;
    WaitForClock(clock_n, 20);
    -- Enter your code here

    state <= Invert;
    WaitForClock(clock_n, 20);
    -- Enter your code here

    state <= NotAffected;
    WaitForClock(clock_n, 20);
    -- Enter your code here

    state <= Keep;
    WaitForClock(clock_n, 20);
    -- Enter your code here

    Log("**********************************");
    ReportAlerts;
    std.env.stop;
    wait ; 
  end process;

end architecture;
