library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.riscv_pkg.all;

entity PC_tb is
end PC_tb;

architecture testbench of PC_tb is
  constant T : time := 4 ns;
  signal clk: std_logic := '0';
  signal ongoing_test: std_logic := '1';
  
  -- PC/PCBack
  signal pc_we: std_logic := '1';
  signal pc_in: std_logic_vector(WSIZE-1 downto 0) := x"00000000";
  signal pc_out, pcb_out: std_logic_vector(WSIZE-1 downto 0) := x"00000000";
begin
  clk <= not clk after T/2 when ongoing_test = '1' else '0';

  e_pc: PC port map(
    clk => clk,
    we => pc_we,
    pc_in => pc_in,
    pc_out => pc_out
  );

  e_pcb: PC port map(
    clk => clk,
    we => '1',
    pc_in => pc_out,
    pc_out => pcb_out
  );

  process is
  begin
     wait for T;

    pc_we <= '1';
    pc_in <= x"ABCDABCD";
    wait for T;
    assert(pc_out = x"ABCDABCD") report "!===========ERROR WRITE (A)===========!" severity error;

  	pc_we <= '1';
    pc_in <= x"FEFAFAFE";
    wait for T;
    assert(pc_out = x"FEFAFAFE") report "!===========ERROR WRITE (B)===========!" severity error;
    assert(pcb_out = x"ABCDABCD") report "!===========ERROR WRITE (C)===========!" severity error;


    pc_we <= '0';
    pc_in <= x"12345678";
    wait for T;
    assert(pc_out = x"FEFAFAFE") report "!===========ERROR NOT WRITE (A)===========!" severity error;
    assert(pc_out /= pc_in) report "!===========ERROR NOT WRITE (A)===========!" severity error;
    assert(pcb_out = x"FEFAFAFE") report "!===========ERROR NOT WRITE (B)===========!" severity error;

    ongoing_test <= '0';
    wait;
  end process;
end architecture;

