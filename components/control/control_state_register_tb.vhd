library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.riscv_pkg.all;

entity CTL_STATE_REGISTER_tb is
end CTL_STATE_REGISTER_tb;

architecture testbench of CTL_STATE_REGISTER_tb is
    signal clk : std_logic := '0';
    signal state_in : std_logic_vector(2 downto 0);
    signal state_out : std_logic_vector(2 downto 0);
    signal ongoing_test : std_logic := '1';
begin
  clk <= not clk after T/2 when ongoing_test = '1' else '0';

  e_ctl_state_register: CTL_STATE_REGISTER port map(
    clk => clk,
    state_in => state_in,
    state_out => state_out
  );

  process is
  begin
    state_in <= "000";
    wait for T;
    assert(state_out = "000") report "==========ERROR (A)==========" severity error;

    state_in <= "100";
    wait for T;
    assert(state_out = "100") report "==========ERROR (B)==========" severity error;

    state_in <= "011";
    wait for T;
    assert(state_out = "011") report "==========ERROR (C)==========" severity error;

    state_in <= "101";
    wait for T;
    assert(state_out = "101") report "==========ERROR (D)==========" severity error;

    ongoing_test <= '0';
    wait;
  end process;
end architecture;

