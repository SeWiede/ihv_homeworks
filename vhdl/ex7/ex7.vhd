library common_lib;
context common_lib.common_context;
library ieee;
  use ieee.math_complex.all;

entity ex7 is
end entity;

architecture behav of ex7 is

  -- Implement the foreign subroutine definitions here
  -- Enter your code here

  procedure GetTimeC(hour, minute, second: out integer);
  attribute FOREIGN of GetTimeC : procedure is "GetTimeC ./shared.so";
  procedure GetTimeC(hour, minute, second: out integer) is
  begin
   Log("Error: foreign subprogram GetTimeC was not executed correclty");
   hour := -1; 
   minute := -1; 
   second := -1; 
  end procedure;

  procedure OneStepC(zr, zi, cr, ci: real; outr, outi: out real);
  attribute FOREIGN of OneStepC : procedure is "OneStepC ./shared.so";
  procedure OneStepC(zr, zi, cr, ci: real; outr, outi: out real) is
  begin
   Log("Error: foreign subprogram OneStepC was not executed correclty");
   outi := 0.0; 
   outr := 0.0; 
  end procedure;

  procedure IterateC(x, y : real; its: out integer);
  attribute FOREIGN of IterateC : procedure is "IterateC ./shared.so";
  procedure IterateC(x, y : real; its: out integer) is
  begin
   Log("Error: foreign subprogram IterateC was not executed correclty");
   its:=  -1;
  end procedure;

  /*function IterateC(x, y : real) return integer;
  attribute FOREIGN of IterateC : function is "IterateC ./shared.so";
  function IterateC(x, y : real) return integer is
  begin
   Log("Error: foreign subprogram IterateC was not executed correclty");
   return -1;
  end function;*/

  -- Func wrapper to use just like Iterate
  function IterateC(x, y : real) return integer is
    variable its : integer := 0;
  begin
    IterateC(x,y,its);
    return its;
  end function;

  -- Func wrappers to use just like OneStep
  pure function OneStepC(z, c : Complex) return Complex is 
    variable o : Complex := (0.0,0.0);
  begin
    OneStepC(z.re, z.im, c.re, c.im, o.re, o.im);
    return o;
  end function;

  -- Func wrapper such that logging is a one liner
  pure function GetTimeC return string is
    variable hour, minute, second: integer := 0;
  begin
    GetTimeC(hour, minute, second);
    return "Current Time: " & to_string(hour) & ":" & to_string(minute) & ":" & to_string(second);
  end function;

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
    variable o : Complex := (0.0,0.0);
  begin
    -- Implement the VHDL function
    -- Enter your code here
    o.re := z.re * z.re - z.im * z.im + c.re;
    o.im := 2.0 * z.re * z.im + c.im;

    return o;
  end function;

  pure function Iterate(x, y: real) return integer is
    -- Implement the VHDL function
    -- Enter your code here
    variable z : Complex := (0.0,0.0);
  begin
    for i in 1 to 200 loop
      -- Implement the VHDL function
      -- Enter your code here
      z := OneStepC(z, (x,y));

      if(z.re * z.re + z.im * z.im > 4.0) then
        return i;
      end if;

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
        mandel := IterateC(x, y);
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
