library common_lib;
context common_lib.common_context;
library ieee;
  use ieee.math_complex.all;

entity ex7 is
end entity;

architecture behav of ex7 is

  -- Implement the foreign subroutine definitions here
  -- Enter your code here

  pure function ToAscii(iter: integer) return character is
  begin
    if iter < 50 then
      return '#';
    elsif iter < 100 then
      return '=';
    elsif iter < 150 then
      return ':';
    elsif iter < 200 then
      return '.';
    end if;
    return ' ';
  end function;

  pure function OneStep(z, c: Complex) return complex is
  begin
    -- Implement the VHDL function
    -- Enter your code here
  end function;

  pure function Iterate(x, y: real) return integer is
    -- Implement the VHDL function
    -- Enter your code here
  begin
    for i in 1 to 200 loop
      -- Implement the VHDL function
      -- Enter your code here
    end loop;
    return 200;
  end function;

  procedure Image is
    constant delta: real := 0.01;
    variable text: string(1 to integer(3.0 / delta) + 1) := (others => ' ');
    variable x, y: real;
    variable mandel, idx: integer;
  begin
    y := -1.0;
    while y < 1.0 loop
      x := -2.0;
      idx := 1;
      text := (others => ' ');
      while x < 1.0 loop
        mandel := Iterate(x, y);
        text(idx) := ToAscii(mandel);
        x := x + delta;
        idx := idx + 1;
      end loop;
      Log(text);
      y := y + delta;
    end loop;
  end procedure;
  
begin

stimuli_p: process is
  begin
    Log(GetTimeC);
    Image;
    Log(GetTimeC);
    wait;
  end process;

end architecture;
