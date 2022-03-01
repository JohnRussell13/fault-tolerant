library ieee;
use ieee.std_logic_1164.all;

package dsong_pkg is
    constant size: integer := 24;
    constant num_units: integer := 5;
    constant comb: integer := 10; -- 5!/(3!2!) maj3
    
    type std_array is array(0 to num_units-1) of std_logic_vector (size-1 downto 0);
    
    type comb_array is array(0 to comb-1) of std_logic_vector(size-1 downto 0);
    type inv_comb_array is array(size-1 downto 0) of std_logic_vector(0 to comb-1);
     
    function math_map(x: in integer;
                    y: in integer;
                    z: in integer)
            return integer;
end package dsong_pkg;

package body dsong_pkg is

function math_map(x: in integer;
                y: in integer;
                z: in integer)
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
 
end package body dsong_pkg;