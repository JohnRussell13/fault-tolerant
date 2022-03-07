library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;
use work.dsong_pkg.all;
use work.txt_util.all;

entity fix_fir_tb is
end fix_fir_tb;

architecture Behavioral of fix_fir_tb is
    constant size : integer := 24;
    constant num_units : integer := 3;
    signal clk_s : std_logic;
    signal rst_s : std_logic;
    signal uut_input_s : std_logic_vector(size-1 downto 0);
    signal uut_output_s : std_logic_vector(size-1 downto 0);

    constant per_c : time := 20ns;
    -- copy input file to PROJECT-NAME/PROJECT-NAME.sim/sim_1/behav/xsim
    file input_test_vector : text open read_mode is "input.txt";
    
    file output : text open write_mode is "output_forced.txt";

begin
    fir_under_test:
    entity work.top(behavioral)
    generic map(size=>size, num_units=>num_units)
    port map(clk=>clk_s,
             rst=>rst_s,
             u=>uut_input_s,
             y=>uut_output_s);
             
    clk_process:
    process
    begin
        clk_s <= '0';
        wait for per_c/2;
        clk_s <= '1';
        wait for per_c/2;
        print(output, hstr(uut_output_s));
    end process;
    
    rst_process: process
    begin
        rst_s <= '0', '1' after per_c/8, '0' after per_c/4;
        wait;
    end process;
    
    stim_process:
    process
        variable tv : line;
    begin
        uut_input_s <= (others=>'0');
        wait until falling_edge(clk_s);
        while not endfile(input_test_vector) loop
            readline(input_test_vector,tv);
            uut_input_s <= to_std_logic_vector(string(tv));
            wait until falling_edge(clk_s);
        end loop;
        report "verification done!" severity failure;
    end process;

end Behavioral;
