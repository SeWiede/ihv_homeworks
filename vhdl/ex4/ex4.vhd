library common_lib;
context common_lib.common_context;

-- Implement the generic package head here. 
package linked_list is
  -- Enter your code here
  generic ( 
    type ElementT;
    DEFAULT_VALUE: ElementT;
    function ToStringF(item: ElementT) return string
  );
  
  type NodeT;
  type NodeT_Ptr is access NodeT;
  type NodeT is record
    data: ElementT;
    nextItem: NodeT_Ptr;
  end record;

  type SinglyLinkedList is protected
    impure function Count return integer;
    procedure AddFirst(item: ElementT);
    impure function GetAt(index: integer) return ElementT;
    procedure RemoveAt(index: integer);
    impure function Dump return string;
  end protected;
end package;

-- Implement the package body here
package body linked_list is
  -- Enter your code here
  type SinglyLinkedList is protected body
    variable head : NodeT_Ptr;

    impure function Count return integer is
      variable count: integer := 0;
      variable current: NodeT_Ptr;
    begin
      current := head;
      while current /= null loop
        count := count + 1;
        current := current.NextItem;
      end loop;

      return count;
    end function;

    procedure AddFirst(item: ElementT) is
      variable newNode: NodeT_Ptr;
    begin
      newNode := new NodeT'(item, head);
      head := newNode;
    end procedure;

    impure function GetAt(index: integer) return ElementT is
      variable current: NodeT_Ptr;
      variable i: integer := 0;
    begin
      current := head;
      while (current /= null) and (i < index) loop
        current := current.NextItem;
        i := i + 1;
      end loop;

      if current /= null then
        return current.Data;
      end if;

      Alert("Index out of bounds");
      return DEFAULT_VALUE;
    end function;

    procedure RemoveAt(index: integer) is
      variable current: NodeT_Ptr;
      variable prev: NodeT_Ptr;
      variable i: integer := 0;
    begin
      current := head;
      prev := null;

      while (current /= null) and (i < index) loop
        prev := current;
        current := current.NextItem;
        i := i + 1;
      end loop;

      if current /= null then
        if prev /= null then
          prev.NextItem := current.NextItem;
        else
          head := current.NextItem;
        end if;
        Deallocate(current);
      else
        Alert("Index out of bounds");
      end if;
    end procedure;

    impure function Dump return string is
      variable current: NodeT_Ptr;
      type stringAccess is access string;
      variable result: stringAccess;
    begin
      if Count = 0 then
        Alert("Empty List");
        return "<Empty List>";
      end if;

      current := head;
      result := new string'(ToStringF(current.Data));

      current := current.NextItem;
      while current /= null loop
        result :=  new string'(result.all & ToStringF(current.Data) & ", ");
        current := current.NextItem;
      end loop;

      return result.all;
    end function;
  end protected body;

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
    return "Number: " & integer'image(item.Number) & ", IsPrime: " & boolean'image(item.IsPrime);
  end function;

  -- Instantiate the linked_list package here, use PrimeRecT as generic type
  -- Enter your code here

  package PrimeRecT_list is new work.linked_list generic map( 
    ElementT => PrimeRecT,
    DEFAULT_VALUE => (Number => -1, IsPrime => false),
    ToStringF => ToString
  );
  use PrimeRecT_list.all;

begin

  stimuli_p: process is
    variable list: SinglyLinkedList;
  begin
    -- Implement your main testbench code here
    -- Enter your code here
    Log("**********************************");

    report list.Dump;
    AffirmIfEqual(list.Count, 0, "Count should be 0");
    
    -- try remove empty list
    list.removeAt(1);
    
    -- Add a few items
    list.addFirst((5, false));
    AffirmIfEqual(list.Count, 1, "Count should be 1");
    list.removeAt(0);
    report list.Dump;
    AffirmIfEqual(list.Count, 0, "Count should be 0");

    list.addFirst((5, true));
    list.addFirst((4, true));
    list.addFirst((3, true));
    list.addFirst((2, true));
    list.addFirst((1, false));
    -- 1-5 in order
    report list.Dump;
    
    report ToString(list.GetAt(0));
    report ToString(list.GetAt(1));
    report ToString(list.GetAt(2));
    report ToString(list.GetAt(3));
    report ToString(list.GetAt(4));

    list.removeAt(0);
    -- 2-5 in order
    report list.Dump;

    -- Fail
    report ToString(list.GetAt(10));
    
    -- Should Alert
    list.removeAt(4);
    -- 2-5 in order
    report list.Dump;

    list.removeAt(3);
    -- 2-4 in order
    report list.Dump;
    list.removeAt(1);
    -- 2,4
    report list.Dump;
    AffirmIfEqual(list.Count, 2, "Count should be 2");
    
    list.removeAt(0);
    list.removeAt(0);
    AffirmIfEqual(list.Count, 0, "Count should be 0");

    std.env.stop;
    wait ; 
  end process;

end architecture;
