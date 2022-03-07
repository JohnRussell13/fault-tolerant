library ieee;
use ieee.std_logic_1164.all;

package dsong_pkg is     
    function math_map(x: in integer;
                    y: in integer;
                    z: in integer;
                    num_units: in integer)
            return integer;
     
    function comb(x: in integer;
                    y: in integer)
            return integer;
end package dsong_pkg;

package body dsong_pkg is

function math_map(x: in integer;
                y: in integer;
                z: in integer;
                num_units: in integer)
            return integer is
variable sum: integer := 0;
begin
    for i in (num_units-2) downto (num_units-1-x) loop
        for j in 1 to i loop
            sum := sum + j;
        end loop;
    end loop;
    
    for i in (y-(x+1)) downto 1 loop
        sum := sum + num_units - 1 - x - i;
    end loop;
    
    sum := sum + z - (y + 1);
    
    return sum;
end;
 

function comb(x: in integer;
                y: in integer)
            return integer is
variable res: integer := 1;
begin
    for i in x downto y+1 loop
        res := res * i;
    end loop;
    
    for i in x-y downto 1 loop
        res := res / i;
    end loop;
    
    return res;
end;
end package body dsong_pkg;