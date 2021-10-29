library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

use work.riscv_pkg.all;

entity MEM_RV is
  port (
    clk : in std_logic;
    we : in std_logic;
    address : in std_logic_vector;
    datain : in std_logic_vector;
    dataout : out std_logic_vector
  );
end entity MEM_RV;

architecture RTL of MEM_RV is
  Type mem_type is array (0 to (2**address'length)-1) of std_logic_vector(datain'range);
  signal read_address : std_logic_vector(address'range);

  impure function init_ram_hex return mem_type is
    file text_file : text open read_mode is "hex.txt";
    variable text_line : line;
    variable mem_content : mem_type;
  begin
    for i in 0 to (2**address'length)-1 loop
      readline(text_file, text_line);
      hread(text_line, mem_content(i));
    end loop;

    return mem_content;
  end function;

  signal mem : mem_type := init_ram_hex;

begin
  write: process(clk) begin
    if we = '1' then
      mem(to_integer(unsigned(address))/4) <= datain;
    end if;
    read_address <= address;
  end process;

  dataout <= mem(to_integer(unsigned(read_address))/4);
end RTL;

