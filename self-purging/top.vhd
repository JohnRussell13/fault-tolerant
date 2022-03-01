library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.dsong_pkg.all;

entity top is
    port(clk: in std_logic;
         rst: in std_logic;
         u: in std_logic_vector(size-1 downto 0);
         y: out std_logic_vector(size-1 downto 0));
end top;

architecture Behavioral of top is
    component fixed_fir
        port(clk_i : in std_logic;
            u_i : in std_logic_vector(size-1 downto 0);
            y_o : out std_logic_vector(size-1 downto 0));
    end component fixed_fir;
    
    component elem_sw
        port(clk: in std_logic;
             rst: in std_logic;
             c_mod: in std_logic_vector(size-1 downto 0);
             c_vot: in std_logic_vector(size-1 downto 0);
             c_esw: out std_logic_vector(size-1 downto 0));
    end component elem_sw;
    
    component voter
        port(clk: in std_logic;
             rst: in std_logic;
             c_esw: in std_array;
             c_vot: out std_logic_vector(size-1 downto 0));
    end component voter;
    
    signal c_mod: std_array; -- each unit result
    signal c_esw: std_array; -- each unit purged result
    signal c_vot: std_logic_vector (size-1 downto 0); -- final result
begin
    gen_modules: for i in 0 to num_units-1 generate
        unit_mod: fixed_fir port map(clk_i => clk,
                               u_i => u,
                               y_o => c_mod(i));
    end generate;
    
    gen_elem_sw: for i in 0 to num_units-1 generate
        unit_esw: elem_sw port map(clk => clk,
                               rst => rst,
                               c_mod => c_mod(i),
                               c_vot => c_vot,
                               c_esw => c_esw(i));
    end generate;
    
    gen_voter: voter port map(clk => clk,
                               rst => rst,
                               c_esw => c_esw,
                               c_vot => c_vot);
                               
    y <= c_vot;
end Behavioral;
