library common_lib;
context common_lib.common_context;
  
entity ex1 is
end entity;

architecture behav of ex1 is

  type ColorT is (Red, Green, Blue, Yellow);

  pure function ColorToString(pos: integer) return string is
  begin
    -- Enter your code here
    if pos < 0 or pos > ColorT'pos(ColorT'high)  then
      Alert("Invalid pos" & integer'image(pos));
      return "OutOfRange";
    else
      return to_string(ColorT'val(pos));
    end if;
  end function;

  pure function ColorsToList return string is
    type stringAccess is access string;
    variable oldList, newList, currentElem: stringAccess;
  begin
    -- Enter your code here
    for i in 0 to ColorT'pos(ColorT'high) loop
      currentElem := new string'(to_string(ColorT'val(i)));
      if i = 0 then
        newList := currentElem;
      else
        newList := new string'(oldList.all & ", " & currentElem.all);
      end if;
      oldList := newList;
    end loop;

    return newList.all;
  end function;

begin

  stimuli_p: process is
  begin
    -- During initialization, the process is evaluated until the first wait statement
    wait for 0 ns;
    -- Enter your code here
    Log("**********************************");
    Log("******** COLORS TO LIST *********");
    Log("**********************************");
    
    report ColorsToList;

    Log("**********************************");
    Log("**********************************");

    report ColorToString(0);
    report ColorToString(1);
    report ColorToString(10);


    ReportAlerts;
    std.env.stop;
    wait ; 
  end process;

end architecture;
