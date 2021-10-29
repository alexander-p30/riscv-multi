library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.riscv_pkg.all;

entity XREGS is
	port (
		clk, wren, rst : in std_logic;
		rs1, rs2, rd : in std_logic_vector(4 downto 0);
		data : in std_logic_vector(WSIZE-1 downto 0);
		ro1, ro2 : out std_logic_vector(WSIZE-1 downto 0)
    );
end XREGS;

architecture XREGS_arch of XREGS is
	type BREG_TYPE is array (0 to 31) of std_logic_vector(WSIZE-1 downto 0);

  	signal breg : BREG_TYPE := (others=>(others=>'0'));
begin
  process(clk) is
  begin
  	if rising_edge(clk) then
    	if rst = '1' then
        	breg <= (others=>(others=>'0'));
    	elsif wren = '1' then
        	case rd is
            	when "00000" => NULL;
      			when others => breg(to_integer(unsigned(rd))) <= data;
    		end case;
        end if;
    end if;
  end process;

  process(breg, rs1, rs2) is
  begin
  	ro1 <= breg(to_integer(unsigned(rs1)));
  	ro2 <= breg(to_integer(unsigned(rs2)));
  end process;
end XREGS_arch;
