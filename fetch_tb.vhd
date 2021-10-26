library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.riscv_pkg.all;

entity fetch_tb is
  generic (WSIZE : natural := 32);
end fetch_tb;

architecture testbench of fetch_tb is
  signal clk: std_logic := '0';
  signal ongoing_test: std_logic := '1';

  -- PC/PCBack
  signal pc_we: std_logic := '1';
  signal pc_in, pc_out, pcb_out: std_logic_vector(WSIZE-1 downto 0) := (others => '0');

  -- ULA
  signal ula_A : std_logic_vector(WSIZE-1 downto 0) := (others => '0');
  signal ula_Z : std_logic_vector(WSIZE-1 downto 0) := (others => '0');
begin
  clk <= not clk after T/2 when ongoing_test = '1' else '0';
  pc_in <= ula_Z;

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

  e_ula: ulaRV port map(
    opcode => "0000",
    A => pc_out,
    B => std_logic_vector(to_unsigned(4, 32)),
    Z => ula_Z,
    cond => open
  );

  process is
  begin
    wait for T/4;

    pc_we <= '1';
    assert(ula_Z = x"00000004") report "!===========ERROR FETCH (A)===========!" severity error;
    assert(pc_out = x"00000000") report "!===========ERROR FETCH (B)===========!" severity error;
    wait for T;

  	pc_we <= '1';
    assert(ula_Z = x"00000008") report "!===========ERROR FETCH (C)===========!" severity error;
    assert(pc_out = x"00000004") report "!===========ERROR FETCH (D)===========!" severity error;
    assert(pcb_out = x"00000000") report "!===========ERROR FETCH (E)===========!" severity error;
    wait for T;


    assert(ula_Z = x"0000000C") report "!===========ERROR FETCH (F)===========!" severity error;
    assert(pc_out = x"00000008") report "!===========ERROR FETCH (G)===========!" severity error;
    assert(pcb_out = x"00000004") report "!===========ERROR FETCH (H)===========!" severity error;
    pc_we <= '0';
    wait for T;

    assert(ula_Z = x"0000000C") report "!===========ERROR FETCH (I)===========!" severity error;
    assert(pc_out = x"00000008") report "!===========ERROR FETCH (J)===========!" severity error;
    assert(pcb_out = x"00000008") report "!===========ERROR FETCH (K)===========!" severity error;
    wait for T;

    ongoing_test <= '0';
    wait;
  end process;
end architecture;

