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

  /*procedure GetBetterTimeC(hour, minute, second, millisecond, microsecond: out integer);
  attribute FOREIGN of GetBetterTimeC : procedure is "GetBetterTimeC ./shared.so";
  procedure GetBetterTimeC(hour, minute, second, millisecond, microsecond: out integer) is
  begin
   Log("Error: foreign subprogram GetBetterTimeC was not executed correclty");
   hour := -1; 
   minute := -1; 
   second := -1; 
   millisecond := -1; 
   microsecond := -1; 
  end procedure;*/

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
      z := OneStep(z, (x,y));

      if(z.re * z.re + z.im * z.im > 4.0) then
        return i;
      end if;

    end loop;
    return 200;
  end function;

  pure function IterateVHDL(x, y: real) return integer is
    -- Implement the VHDL function
    -- Enter your code here
    variable z : Complex := (0.0,0.0);
  begin
    for i in 1 to 200 loop
      -- Implement the VHDL function
      -- Enter your code here
      OneStepC(z.re, z.im, x, y, z.re, z.im);
      --z := OneStepC(z, (x,y));

      if(z.re * z.re + z.im * z.im > 4.0) then
        return i;
      end if;

    end loop;
    return 200;
  end function;

  procedure Image is
    constant delta: real := 0.001; -- higher res -> way too quick otherwise
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

  procedure ImageVHDLC is
    constant delta: real := 0.001; -- higher res -> way too quick otherwise
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
        mandel := IterateVHDL(x, y);
        text(idx) := ToAscii(mandel);
        x := x + delta;
        idx := idx + 1;
      end loop;
      Log(text);
      y := y + delta;
    end loop;
  end procedure;

  procedure ImageC is
    constant delta: real := 0.001; -- higher res -> way too quick otherwise
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
        IterateC(x, y, mandel);
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
  variable hour, minute, second: integer := 0;
  variable startSec : integer := 0;
  variable stopSec : integer := 0;
begin
  GetTimeC(hour, minute, second);
  startSec := hour * 3600 + minute * 60 + second;
  Image;
  GetTimeC(hour, minute, second);
  stopSec := hour * 3600 + minute * 60 + second;
  Log("Image call took " & to_string(stopSec - startSec) & " sec");
  -- btw I cranked up the resolution to 0.001 - 0.01 was way too quick
  -- pure VHDL time: ~ 20 sec
  -- VHDL + stepC: ~ 4 sec
  -- pure C: ~ 3 sec
  wait;
end process;

end architecture;
