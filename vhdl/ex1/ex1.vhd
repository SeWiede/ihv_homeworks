library common_lib;
context common_lib.common_context;
  
entity ex1 is
end entity;

architecture behav of ex1 is

  type ColorT is (Red, Green, Blue, Yellow);

  pure function ColorToString(pos: integer) return string is
  begin
    -- Enter your code here
  end function;

  pure function ColorsToList return string is
    -- Enter your code here
  end function;

begin

  stimuli_p: process is
  begin
    -- During initialization, the process is evaluated until the first wait statement
    wait for 0 ns;
    -- Enter your code here
    Log("**********************************");
    ReportAlerts;
    std.env.stop;
    wait ; 
  end process;

end architecture;
