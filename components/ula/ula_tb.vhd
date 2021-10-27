LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.riscv_pkg.all;

ENTITY ula_tb IS
END ula_tb;

ARCHITECTURE tb_arch OF ula_tb IS
  component ulaRV is
    port(
      	opcode : in std_logic_vector(3 downto 0);
		A, B : in std_logic_vector(WSIZE-1 downto 0);
		Z : out std_logic_vector(WSIZE-1 downto 0);
		cond : out std_logic
    );
  end component;

  signal opcode_s : std_logic_vector(3 downto 0);
  signal A_s, B_s, Z_s : std_logic_vector(WSIZE-1 downto 0);
  signal cond_s : std_logic;

begin
 	DUT: ulaRV port map(opcode_s, A_s, B_s, Z_s, cond_s);

	process
    begin
    -- Testing add (A)
    opcode_s <= "0000";
    A_s <= x"00000001";
    B_s <= x"00000002";
    wait for 1 ns;
    assert(Z_s = x"00000003") report "!===========ERROR ADD (A)===========!" severity error;

    -- Testing add (B)
    opcode_s <= "0000";
    A_s <= x"F0F0F0F0";
    B_s <= x"0F0F0F0F";
    wait for 1 ns;
    assert(Z_s = x"FFFFFFFF") report "!===========ERROR ADD (B)===========!" severity error;

    -- Testing add (C)
    opcode_s <= "0000";
    A_s <= x"FFFFFFFF";
    B_s <= x"00000001";
    wait for 1 ns;
    assert(Z_s = x"00000000") report "!===========ERROR ADD (C)===========!" severity error;

    -- Testing add (D)
    opcode_s <= "0000";
    A_s <= x"11111111";
    B_s <= x"00000000";
    wait for 1 ns;
    assert(Z_s = x"11111111") report "!===========ERROR ADD (C)===========!" severity error;

    -- Testing add (E)
    opcode_s <= "0000";
    A_s <= x"00000000";
    B_s <= x"00000000";
    wait for 1 ns;
    assert(Z_s = x"00000000") report "!===========ERROR ADD (E)===========!" severity error;

    -- Testing sub (A)
    opcode_s <= "0001";
    A_s <= x"00000001";
    B_s <= x"00000002";
    wait for 1 ns;
    assert(Z_s = x"FFFFFFFF") report "!===========ERROR SUB (A)===========!" severity error;

    -- Testing sub (B)
    opcode_s <= "0001";
    A_s <= x"F0F0F0F0";
    B_s <= x"0F0F0F0F";
    wait for 1 ns;
    assert(Z_s = x"E1E1E1E1") report "!===========ERROR SUB (B)===========!" severity error;

    -- Testing sub (C)
    opcode_s <= "0001";
    A_s <= x"00000001";
    B_s <= x"FFFFFFFF";
    wait for 1 ns;
    assert(Z_s = x"00000002") report "!===========ERROR SUB (C)===========!" severity error;

    -- Testing sub (D)
    opcode_s <= "0001";
    A_s <= x"00000002";
    B_s <= x"00000001";
    wait for 1 ns;
    assert(Z_s = x"00000001") report "!===========ERROR SUB (D)===========!" severity error;

    -- Testing sub (E)
    opcode_s <= "0001";
    A_s <= x"00000002";
    B_s <= x"00000000";
    wait for 1 ns;
    assert(Z_s = x"00000002") report "!===========ERROR SUB (E)===========!" severity error;

    -- Testing and (A)
    opcode_s <= "0010";
    A_s <= x"10101010";
    B_s <= x"01010101";
    wait for 1 ns;
    assert(Z_s = x"00000000") report "!===========ERROR AND (A)===========!" severity error;

    -- Testing and (B)
    opcode_s <= "0010";
    A_s <= x"10101010";
    B_s <= x"11111111";
    wait for 1 ns;
    assert(Z_s = x"10101010") report "!===========ERROR AND (B)===========!" severity error;

    -- Testing and (C)
    opcode_s <= "0010";
    A_s <= x"00001010";
    B_s <= x"11111111";
    wait for 1 ns;
    assert(Z_s = x"00001010") report "!===========ERROR AND (C)===========!" severity error;

    -- Testing or (A)
    opcode_s <= "0011";
    A_s <= x"10101010";
    B_s <= x"01010101";
    wait for 1 ns;
    assert(Z_s = x"11111111") report "!===========ERROR OR (A)===========!" severity error;

    -- Testing or (B)
    opcode_s <= "0011";
    A_s <= x"10101010";
    B_s <= x"11111111";
    wait for 1 ns;
    assert(Z_s = x"11111111") report "!===========ERROR OR (B)===========!" severity error;

    -- Testing or (C)
    opcode_s <= "0011";
    A_s <= x"00001010";
    B_s <= x"11110000";
    wait for 1 ns;
    assert(Z_s = x"11111010") report "!===========ERROR OR (C)===========!" severity error;

    -- Testing xor (A)
    opcode_s <= "0100";
    A_s <= x"10101010";
    B_s <= x"01010101";
    wait for 1 ns;
    assert(Z_s = x"11111111") report "!===========ERROR XOR (A)===========!" severity error;

    -- Testing xor (B)
    opcode_s <= "0100";
    A_s <= x"10101010";
    B_s <= x"11111111";
    wait for 1 ns;
    assert(Z_s = x"01010101") report "!===========ERROR XOR (B)===========!" severity error;

    -- Testing xor (C)
    opcode_s <= "0100";
    A_s <= x"00001010";
    B_s <= x"11110000";
    wait for 1 ns;
    assert(Z_s = x"11111010") report "!===========ERROR XOR (C)===========!" severity error;

    -- Testing sll (A)
    opcode_s <= "0101";
    A_s <= x"01111111";
    B_s <= x"00000004";
    wait for 1 ns;
    assert(Z_s = x"11111110") report "!===========ERROR SLL (A)===========!" severity error;

    -- Testing sll (B)
    opcode_s <= "0101";
    A_s <= x"11111111";
    B_s <= x"00000010";
    wait for 1 ns;
    assert(Z_s = x"11110000") report "!===========ERROR SLL (B)===========!" severity error;

    -- Testing srl (A)
    opcode_s <= "0110";
    A_s <= x"01111111";
    B_s <= x"00000004";
    wait for 1 ns;
    assert(Z_s = x"00111111") report "!===========ERROR SRL (A)===========!" severity error;

    -- Testing srl (B)
    opcode_s <= "0110";
    A_s <= x"11110000";
    B_s <= x"00000010";
    wait for 1 ns;
    assert(Z_s = x"00001111") report "!===========ERROR SRL (B)===========!" severity error;

    -- Testing sra (A)
    opcode_s <= "0111";
    A_s <= x"01111111";
    B_s <= x"00000004";
    wait for 1 ns;
    assert(Z_s = x"00111111") report "!===========ERROR SRA (A)===========!" severity error;

    -- Testing sra (B)
    opcode_s <= "0111";
    A_s <= x"A1110000";
    B_s <= x"00000010";
    wait for 1 ns;
    assert(Z_s = x"FFFFA111") report "!===========ERROR SRA (B)===========!" severity error;


    -- Testing slt (A)
    opcode_s <= "1000";
    A_s <= x"FFFFFFFF";
    B_s <= x"00000001";
    wait for 1 ns;
    assert(cond_s = '1') report "!===========ERROR SLT (A)===========!" severity error;

    -- Testing slt (B)
    opcode_s <= "1000";
    A_s <= x"00000001";
    B_s <= x"00000002";
    wait for 1 ns;
    assert(cond_s = '1') report "!===========ERROR SLT (B)===========!" severity error;

    -- Testing slt (C)
    opcode_s <= "1000";
    A_s <= x"00000002";
    B_s <= x"00000002";
    wait for 1 ns;
    assert(cond_s = '0') report "!===========ERROR SLT (C)===========!" severity error;

    -- Testing slt (D)
    opcode_s <= "1000";
    A_s <= x"00000003";
    B_s <= x"00000002";
    wait for 1 ns;
    assert(cond_s = '0') report "!===========ERROR SLT (D)===========!" severity error;

    -- Testing sltu (A)
    opcode_s <= "1001";
    A_s <= x"FFFFFFFF";
    B_s <= x"00000001";
    wait for 1 ns;
    assert(cond_s = '0') report "!===========ERROR SLTU (A)===========!" severity error;

    -- Testing sltu (B)
    opcode_s <= "1001";
    A_s <= x"00000001";
    B_s <= x"00000002";
    wait for 1 ns;
    assert(cond_s = '1') report "!===========ERROR SLTU (B)===========!" severity error;

    -- Testing sltu (C)
    opcode_s <= "1001";
    A_s <= x"00000002";
    B_s <= x"00000002";
    wait for 1 ns;
    assert(cond_s = '0') report "!===========ERROR SLTU (C)===========!" severity error;

    -- Testing sltu (D)
    opcode_s <= "1001";
    A_s <= x"00000003";
    B_s <= x"00000002";
    wait for 1 ns;
    assert(cond_s = '0') report "!===========ERROR SLTU (D)===========!" severity error;

    -- Testing sge (A)
    opcode_s <= "1010";
    A_s <= x"FFFFFFFF";
    B_s <= x"00000001";
    wait for 1 ns;
    assert(cond_s = '0') report "!===========ERROR SGE (A)===========!" severity error;

    -- Testing sge (B)
    opcode_s <= "1010";
    A_s <= x"00000001";
    B_s <= x"00000002";
    wait for 1 ns;
    assert(cond_s = '0') report "!===========ERROR SGE (B)===========!" severity error;

    -- Testing sge (C)
    opcode_s <= "1010";
    A_s <= x"00000002";
    B_s <= x"00000002";
    wait for 1 ns;
    assert(cond_s = '1') report "!===========ERROR SGE (C)===========!" severity error;

    -- Testing sge (D)
    opcode_s <= "1010";
    A_s <= x"00000003";
    B_s <= x"00000002";
    wait for 1 ns;
    assert(cond_s = '1') report "!===========ERROR SGE (D)===========!" severity error;

    -- Testing sgeu (A)
    opcode_s <= "1011";
    A_s <= x"FFFFFFFF";
    B_s <= x"00000001";
    wait for 1 ns;
    assert(cond_s = '1') report "!===========ERROR SGEU (A)===========!" severity error;

    -- Testing sgeu (B)
    opcode_s <= "1011";
    A_s <= x"00000001";
    B_s <= x"00000002";
    wait for 1 ns;
    assert(cond_s = '0') report "!===========ERROR SGEU (B)===========!" severity error;

    -- Testing sgeu (C)
    opcode_s <= "1011";
    A_s <= x"00000002";
    B_s <= x"00000002";
    wait for 1 ns;
    assert(cond_s = '1') report "!===========ERROR SGEU (C)===========!" severity error;

    -- Testing sgeu (D)
    opcode_s <= "1011";
    A_s <= x"00000003";
    B_s <= x"00000002";
    wait for 1 ns;
    assert(cond_s = '1') report "!===========ERROR SGEU (D)===========!" severity error;

    -- Testing seq (A)
    opcode_s <= "1100";
    A_s <= x"FFFFFFFF";
    B_s <= x"00000001";
    wait for 1 ns;
    assert(cond_s = '0') report "!===========ERROR SEQ (A)===========!" severity error;

    -- Testing seq (B)
    opcode_s <= "1100";
    A_s <= x"00000001";
    B_s <= x"00000002";
    wait for 1 ns;
    assert(cond_s = '0') report "!===========ERROR SEQ (B)===========!" severity error;

    -- Testing seq (C)
    opcode_s <= "1100";
    A_s <= x"00000002";
    B_s <= x"00000002";
    wait for 1 ns;
    assert(cond_s = '1') report "!===========ERROR SEQ (C)===========!" severity error;

    -- Testing seq (D)
    opcode_s <= "1100";
    A_s <= x"00000003";
    B_s <= x"00000002";
    wait for 1 ns;
    assert(cond_s = '0') report "!===========ERROR SEQ (D)===========!" severity error;

    -- Testing sne (A)
    opcode_s <= "1101";
    A_s <= x"FFFFFFFF";
    B_s <= x"00000001";
    wait for 1 ns;
    assert(cond_s = '1') report "!===========ERROR SNE (A)===========!" severity error;

    -- Testing sne (B)
    opcode_s <= "1101";
    A_s <= x"00000001";
    B_s <= x"00000002";
    wait for 1 ns;
    assert(cond_s = '1') report "!===========ERROR SNE (B)===========!" severity error;

    -- Testing sne (C)
    opcode_s <= "1101";
    A_s <= x"00000002";
    B_s <= x"00000002";
    wait for 1 ns;
    assert(cond_s = '0') report "!===========ERROR SNE (C)===========!" severity error;

    -- Testing sne (D)
    opcode_s <= "1101";
    A_s <= x"00000003";
    B_s <= x"00000002";
    wait for 1 ns;
    assert(cond_s = '1') report "!===========ERROR SNE (D)===========!" severity error;

    wait;
 	end process;
end tb_arch;
