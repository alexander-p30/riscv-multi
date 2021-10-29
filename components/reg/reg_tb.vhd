library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.riscv_pkg.all;

entity GENERIC_REG_tb is
end GENERIC_REG_tb;

architecture testbench of GENERIC_REG_tb is
  signal clk: std_logic := '0';
  signal ongoing_test: std_logic := '1';
  
  -- GENERIC_REG/GENERIC_REGBack
  signal reg_we: std_logic := '1';
  signal reg_in: std_logic_vector(WSIZE-1 downto 0) := x"00000000";
  signal reg_out, regb_out: std_logic_vector(WSIZE-1 downto 0) := x"00000000";
begin
  clk <= not clk after T/2 when ongoing_test = '1' else '0';

  e_reg: GENERIC_REG port map(
    clk => clk,
    we => reg_we,
    reg_in => reg_in,
    reg_out => reg_out
  );

  process is
  begin
     wait for T;

    reg_we <= '1';
    reg_in <= x"ABCDABCD";
    wait for T;
    assert(reg_out = x"ABCDABCD") report "!===========ERROR WRITE (A)===========!" severity error;

  	reg_we <= '1';
    reg_in <= x"FEFAFAFE";
    wait for T;
    assert(reg_out = x"FEFAFAFE") report "!===========ERROR WRITE (B)===========!" severity error;


    reg_we <= '0';
    reg_in <= x"12345678";
    wait for T;
    assert(reg_out = x"FEFAFAFE") report "!===========ERROR NOT WRITE (A)===========!" severity error;
    assert(reg_out /= reg_in) report "!===========ERROR NOT WRITE (A)===========!" severity error;

    ongoing_test <= '0';
    wait;
  end process;
end architecture;

