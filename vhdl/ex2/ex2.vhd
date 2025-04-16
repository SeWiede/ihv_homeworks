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
  -- Signal for making output'transaction visible for waveform viewer
  signal output_transaction : bit := '0';

  -- state_p directly triggers on the clock and checks for rising_edges for state changes.
  -- stimuli_p' WaitForClock() calls wait for clock cycles on the inverted clock signal
  -- thus the stimuli process is triggered on the falling edge of the clock
  -- We dont want both processes to trigger on the rising edge because we want to count the events that happen on the rising edge
  -- There might be issues with 'race conditions' otherwise. I'd expect a few of-by-ones in the AffirmIfEqual() calls
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
  -- triggering on this intermediate signal makes the waveformviewer show this signal
  output_transaction <=  output'transaction; 

  event_count_p: process(output) is
  begin
    -- During initialization, the process is evaluated until the first wait statement
    -- 'event triggers when the signal changes
    eventCounter <= eventCounter + 1;
    -- wait on output'event; implicit --> I guess that's why the counters were initialized with -1
  end process;

  trans_count_p: process(output_transaction) is
  begin
    -- During initialization, the process is evaluated until the first wait statement
    -- "'transaction is bit a signal, the inverse of previous value each cycle S is active"
    -- thus we need to count events on 'transaction
    -- 'transaction'event triggers when there are assignments on the signal
    transCounter <= transCounter + 1;

    -- wait on output'transaction'event; -- implicit
  end process;

  stimuli_p: process is
  begin
    -- During initialization, the process is evaluated until the first wait statement
    wait for 0 ns;
    state <= Idle;
    WaitForClock(clock_n, 20);
    -- Enter your code here
    -- transaction, no event -> no value change (default is '0' and Idle assigns '0')
    -- since we're waiting for 20 clock cylces the transaction counter increases by 20, event stays the same
    report "transCounter: " & integer'image(transCounter) & -- + 20
            ", eventCounter: " & integer'image(eventCounter); -- + 0
    AffirmIfEqual(transCounter, 20, "transCounter should be 20");
    AffirmIfEqual(eventCounter, 0, "eventcounter should be 0");

    state <= Invert;
    WaitForClock(clock_n, 20);
    -- Enter your code here
    -- transaction and event -> value changes every clock cycle!
    -- since we're waiting for 20 clock cylces the transaction counter increases by 20, event aswell
    report "transCounter: " & integer'image(transCounter) & -- +20
            ", eventCounter: " & integer'image(eventCounter); -- +20
    AffirmIfEqual(transCounter, 40, "transCounter should be 40");
    AffirmIfEqual(eventCounter, 20, "eventCounter should be 20");

    state <= NotAffected;
    WaitForClock(clock_n, 20);
    -- Enter your code here
    -- no transaction, no event -> "unaffected" does neither trigger 'event nor 'transaction
    report "transCounter: " & integer'image(transCounter) & -- + 0
            ", eventCounter: " & integer'image(eventCounter); -- + 0
    AffirmIfEqual(transCounter, 40, "transCounter should be 40");
    AffirmIfEqual(eventCounter, 20, "eventCounter should be 20");

    state <= Keep;
    WaitForClock(clock_n, 20);
    -- Enter your code here
    -- transaction, no event -> no value change
    -- thus transCounter is incremented each clock cylce but eventCounter is not
    report "transCounter: " & integer'image(transCounter) & -- + 20
            ", eventCounter: " & integer'image(eventCounter); -- + 0
    AffirmIfEqual(transCounter, 60, "transCounter should be 60");
    AffirmIfEqual(eventCounter, 20, "eventCounter should be 20");

    Log("**********************************");
    ReportAlerts;
    std.env.stop;
    wait ; 
  end process;

end architecture;
