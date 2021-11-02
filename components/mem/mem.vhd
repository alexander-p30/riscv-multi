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
    file text_file : text open read_mode is "text_hex.txt";
    file data_file : text open read_mode is "data_hex.txt";
    variable current_line : line;
    variable mem_content : mem_type;
    variable i : integer := 0;
  begin

    while not endfile(text_file) loop
      readline(text_file, current_line);
      hread(current_line, mem_content(i));
      i := i + 1;
    end loop;

    i := 2047;

    while not endfile(data_file) loop
      readline(data_file, current_line);
      hread(current_line, mem_content(i));
      i := i + 1;
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

