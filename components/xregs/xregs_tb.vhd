library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.riscv_pkg.all;

entity XREGS_tb is
end XREGS_tb;

architecture TB of XREGS_tb is
  component XREGS is
    port(
      clk, wren, rst : in std_logic;
      rs1, rs2, rd : in std_logic_vector(4 downto 0);
      data : in std_logic_vector(WSIZE-1 downto 0);
      ro1, ro2 : out std_logic_vector(WSIZE-1 downto 0)
    );
  end component;

  constant T : time := 4 ns;

  signal clk_s, wren_s, rst_s : std_logic := '0';
  signal rs1_s, rs2_s, rd_s : std_logic_vector(4 downto 0) := "00000";
  signal data_s : std_logic_vector(WSIZE-1 downto 0) := x"00000000";
  signal ro1_s, ro2_s : std_logic_vector(WSIZE-1 downto 0) := x"00000000";

  signal ongoing_test : std_logic := '1';

begin
  clk_s <= not clk_s after T/2 when ongoing_test = '1' else '0';

  DUT: XREGS port map(clk_s, wren_s, rst_s, rs1_s, rs2_s, rd_s, data_s, ro1_s, ro2_s);

  process
  begin
    -- writing to rd (A)
    wren_s <= '1';
    rd_s <= "00001";
    rs1_s <= "00001";
    data_s <= x"ABCDEF12";
    wait for T;
    assert(ro1_s = x"ABCDEF12") report "!=============ERROR WRITING TO RD (A)=============!" severity error;

    -- writing to rd (B)
    wren_s <= '1';
    rd_s <= "11111";
    rs2_s <= "11111";
    data_s <= x"ABBAABBA";
    wait for T;
    assert(ro2_s = x"ABBAABBA") report "!=============ERROR WRITING TO RD (B)=============!" severity error;

    -- reseting breg
    rst_s <= '1';
    rs1_s <= "00001";
    rs2_s <= "11111";
    wait for T;
    assert(ro1_s = x"00000000") report "!=============ERROR RESETING BREG(ro1)=============!" severity error;
    assert(ro2_s = x"00000000") report "!=============ERROR RESETING BREG(ro2)=============!" severity error;
    rst_s <= '0';

    -- writing to breg[0]
    wren_s <= '1';
    rd_s <= "00000";
    rs1_s <= "00000";
    data_s <= x"CADECADE";
    wait for T;
    assert(ro1_s = x"00000000") report "!=============ERROR WRITING TO BREG[0]=============!" severity error;

    ongoing_test <= '0';
    wait;
  end process;
end tb;
