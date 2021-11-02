library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity gen_imm_tb is
end gen_imm_tb;

architecture tb of gen_imm_tb is

  component genImm32 is
    port(
          instr: in std_logic_vector(31 downto 0);
          imm32: out signed(31 downto 0)
        );
  end component;

  signal instr_s : std_logic_vector(31 downto 0);
  signal imm32_s : signed(31 downto 0);

begin
  DUT: genImm32 port map(instr_s, imm32_s);

  process
  begin
    -- R_TYPE
    instr_s <= x"000002b3";
    wait for 1 ns;
    assert(imm32_s=x"0") report "!=============ERROR on R_Type 0=============!" severity error;

    -- I_TYPE
    instr_s <= x"01002283";
    wait for 1 ns;
    assert(imm32_s=x"10") report "!=============ERROR on I_Type 0=============!" severity error;

    instr_s <= x"f9c00313";
    wait for 1 ns;
    assert(imm32_s=x"FFFFFF9C") report "!=============ERROR on I_Type 1=============!" severity error;

    instr_s <= x"fff2c293";
    wait for 1 ns;
    assert(imm32_s=x"FFFFFFFF") report "!=============ERROR on I_Type 2=============!" severity error;

    instr_s <= x"01800067";
    wait for 1 ns;
    assert(imm32_s=x"00000018") report "!=============ERROR on I_Type 3=============!" severity error;

    -- U_TYPE
    instr_s <= x"00002437";
    wait for 1 ns;
    assert(imm32_s=x"00002000") report "!=============ERROR on U_Type 0=============!" severity error;

    -- S_TYPE
    instr_s <= x"02542e23";
    wait for 1 ns;
    assert(imm32_s=x"0000003C") report "!=============ERROR on S_Type 0=============!" severity error;

    -- SB_TYPE
    instr_s <= x"fe5290e3";
    wait for 1 ns;
    assert(imm32_s=x"FFFFFFE0") report "!=============ERROR on SB_Type 0=============!" severity error;

    -- UJ_TYPE
    instr_s <= x"00c000ef";
    wait for 1 ns;
    assert(imm32_s=x"0000000C") report "!=============ERROR on UJ_Type 0=============!" severity error;

    wait;
  end process;
end tb;
