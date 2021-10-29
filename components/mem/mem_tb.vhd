library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.riscv_pkg.all;

entity MEM_RV_tb is
end MEM_RV_tb;

architecture testbench of MEM_RV_tb is
  signal clk : std_logic := '0';
  signal we : std_logic := '0';
  signal address : std_logic_vector(7 downto 0);
  signal datain : std_logic_vector(WSIZE-1 downto 0);
  signal dataout : std_logic_vector(WSIZE-1 downto 0);

  signal ongoing_test : std_logic := '1';
begin
  clk <= not clk after T/2 when ongoing_test = '1' else '0';

  e_mem: MEM_RV port map(
    clk => clk,
    we => we,
    address => address,
    datain => datain,
    dataout => dataout
  );

  process is
  begin
    we <= '1';
    datain <= x"FFFFFFFF";
    address <= "11111111";
    wait for T/2;
    assert (dataout = x"FFFFFFFF") report "!============ERROR SYNC (A)============!";
    we <= '0';

    for i in 0 to 255 loop
      address <= std_logic_vector(to_unsigned(i,8));
      datain <= std_logic_vector(to_unsigned(i,30)) & "00";
      wait for T/4;
      report to_hstring(dataout);
    end loop;

    ongoing_test <= '0';
    wait;
  end process;
end architecture;

