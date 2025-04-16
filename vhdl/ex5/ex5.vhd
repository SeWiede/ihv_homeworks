library common_lib;
context common_lib.common_context;
use work.avmm_pkg.all;

entity ex5 is
end entity;

architecture behav of ex5 is

  -- Define clk_i, trans_io and pins_io with the correct constrained data types
  -- Enter your code here
  
begin

  CreateClock(clk_i, 10 ns);

  avmm_vu_inst: entity work.avmm_vu
    port map (
      trans_io => trans_io,
      clk_i    => clk_i,
      pins_io  => pins_io
    );

  stimuli_p: process is
  begin
    -- Implement your main testbench code here
    -- Enter your code here
    Log("**********************************");
    std.env.stop;
    wait ; 
  end process;
  
end architecture;