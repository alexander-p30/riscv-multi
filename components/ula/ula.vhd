library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.riscv_pkg.all;

entity ulaRV is
  generic (WSIZE : natural := 32);
  port (
         opcode : in std_logic_vector(3 downto 0);
        A, B : in std_logic_vector(WSIZE-1 downto 0);
        Z : out std_logic_vector(WSIZE-1 downto 0);
        cond : out std_logic
);
end ulaRV;

architecture ulaRV_arch of ulaRV is
  signal Ax, Bx : signed(WSIZE-1 downto 0);
  signal condx : boolean;
begin
  Ax <= signed(A);
  Bx <= signed(B);
  cond <= Z(0);

  ula: process(opcode, Ax, Bx) is
  begin
    case opcode is
      when "0000" => Z <= std_logic_vector(Ax + Bx);	-- add
      when "0001" => Z <= std_logic_vector(Ax - Bx);	-- sub
      when "0010" => Z <= A and B;	--and
      when "0011" => Z <= A or B; -- or
      when "0100" => Z <= A xor B;	-- xor
      when "0101" => Z <= std_logic_vector(Ax sll to_integer(Bx));	-- sll
      when "0110" => Z <= std_logic_vector(Ax srl to_integer(Bx));	-- srl
      when "0111" => Z <= std_logic_vector(shift_right(Ax, to_integer(Bx)));	-- sra
      when "1000" => if Ax < Bx then Z <= x"00000001"; else Z <= ZERO32; end if;	-- slt
      when "1001" => if unsigned(A) < unsigned(B) then Z <= x"00000001"; else Z <= ZERO32; end if;	--sltu
      when "1010" => if Ax >= Bx then Z <= x"00000001"; else Z <= ZERO32; end if;	-- sge
      when "1011" => if unsigned(A) >= unsigned(B) then Z <= x"00000001"; else Z <= ZERO32; end if;	-- sgeu
      when "1100" => if A = B then Z <= x"00000001"; else Z <= ZERO32; end if;	-- seq
      when "1101" => if A /= B then Z <= x"00000001"; else Z <= ZERO32; end if;	-- sne
      when others => NULL;
    end case;
  end process;
end ulaRV_arch;
