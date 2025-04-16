library common_lib;
context common_lib.common_context;

-- Implement the generic package head here. 
package linked_list is
  -- Enter your code here
end package;

-- Implement the package body here
package body linked_list is
  -- Enter your code here
end package body;

library common_lib;
context common_lib.common_context;

entity ex4 is
end entity;

architecture behav of ex4 is

  type PrimeRecT is record
    Number: integer;
    IsPrime: boolean;
  end record;

  -- implement the ToString function here
  function ToString(item: PrimeRecT) return string is
  begin
  -- Enter your code here
  end function;

  -- Instantiate the linked_list package here, use PrimeRecT as generic type
  -- Enter your code here
  
begin

  stimuli_p: process is
  begin
    -- Implement your main testbench code here
    -- Enter your code here
    Log("**********************************");
    std.env.stop;
    wait ; 
  end process;

end architecture;
