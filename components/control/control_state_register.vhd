library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity CTL_STATE_REGISTER is
  port (
    clk : in std_logic;
    state_in : in std_logic_vector(2 downto 0);
    state_out : out std_logic_vector(2 downto 0) := "000"
  );
end entity CTL_STATE_REGISTER;

architecture CTL_STATE_REGISTER_arch of CTL_STATE_REGISTER is
begin
  process(clk) is
  begin
    if rising_edge(clk) then
      state_out <= state_in;
    end if;
  end process;
end CTL_STATE_REGISTER_arch;
