library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity maj3 is
    generic(size: integer := 8);
    port(a: in std_logic_vector(size-1 downto 0);
         b: in std_logic_vector (size-1 downto 0);
         c: in std_logic_vector (size-1 downto 0);
         d: out std_logic_vector (size-1 downto 0));
end maj3;

architecture Behavioral of maj3 is
begin
    d <= ((a and b) or (b and c)) or (c and a);
end Behavioral;
