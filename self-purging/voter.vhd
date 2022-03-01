library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;
use work.dsong_pkg.all;

entity voter is
    port(clk: in std_logic;
         rst: in std_logic;
         c_esw: in std_array;
         c_vot: out std_logic_vector(size-1 downto 0));
end voter;

architecture Behavioral of voter is
    component maj3
    generic(size: integer := 8);
    port(a: in std_logic_vector(size-1 downto 0);
         b: in std_logic_vector (size-1 downto 0);
         c: in std_logic_vector (size-1 downto 0);
         d: out std_logic_vector (size-1 downto 0));
    end component maj3;
    
    signal temp: comb_array;
    signal swapped: inv_comb_array;
begin
    gen_maj3_0: for i in 0 to num_units-3 generate
        gen_maj3_1: for j in (i+1) to num_units-2 generate
            gen_maj_2: for k in (j+1) to num_units-1 generate
                unit_maj: maj3 generic map(size => size)
                            port map(a => c_esw(i),
                                       b => c_esw(j),
                                       c => c_esw(k),
                                       d => temp(math_map(i,j,k)));
            end generate;
        end generate;
    end generate;
    
    swap: process(temp)
    begin
        for i in 0 to comb-1 loop
            for j in size-1 downto 0 loop
                swapped(j)(i) <= temp(i)(j);
            end loop;
        end loop;
    end process;

    set: process(swapped)
    begin
        for i in size-1 downto 0 loop
            c_vot(i) <= or_reduce(swapped(i));
        end loop;
    end process;
end Behavioral;
