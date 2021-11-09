library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

use work.riscv_pkg.all;

entity CTL is
  port (
    opcode : in std_logic_vector(6 downto 0);

    -- PC
    EscrevePCB, EscrevePC, IouD, OrigPC, Branch, is_lui : out std_logic;

    -- XREGS
    Mem2Reg : out std_logic_vector(1 downto 0);
    EscreveReg : out std_logic;

    -- MEM/IR
    EscreveMEM : out std_logic;
    LeMem : out std_logic;
    EscreveIR : out std_logic;

    -- ULA
    OrigULA_A, OrigULA_B : out std_logic_vector(1 downto 0);
    ULAop : out std_logic_vector(6 downto 0);

    -- state-machine
    current_state : in std_logic_vector(2 downto 0) := STATE_0;
    next_state : out std_logic_vector(2 downto 0)
  );
end entity CTL;

architecture CTL_arch of CTL is
  procedure fetch(
    signal EscreveMEM, EscrevePCB, EscrevePC, EscreveIR, IouD, OrigPC, LeMem, EscreveReg, is_lui : out std_logic;
    signal ULAop : out std_logic_vector(6 downto 0);
    signal OrigULA_A, OrigULA_B : out std_logic_vector(1 downto 0);
    signal next_state : out std_logic_vector(2 downto 0)
  ) is
  begin
    IouD <= '0';
    is_lui <= '0';
    LeMem <= '1';
    EscreveMEM <= '0';
    EscreveIR <= '1';
    EscreveReg <= '0';
    OrigULA_A <= "01";
    OrigULA_B <= "01";
    ULAop <= R_TYPE;
    OrigPC <= '0';
    EscrevePC <= '1';
    EscrevePCB <= '1';
    next_state <= STATE_1;
  end fetch;

  procedure decode(
    signal ULAop : out std_logic_vector(6 downto 0);
    signal Branch, EscrevePCB, EscrevePC, EscreveIR : out std_logic;
    signal OrigULA_A, OrigULA_B : out std_logic_vector(1 downto 0);
    signal next_state : out std_logic_vector(2 downto 0)
  ) is
  begin
    OrigULA_A <= "10";
    OrigULA_B <= "11";
    Branch <= '0';
    EscrevePC <= '0';
    EscrevePCB <= '0';
    EscreveIR <= '0';
    ULAop <= R_TYPE;
    next_state <= STATE_2;
  end decode;

  procedure ex_R_type(
    signal ULAop : out std_logic_vector(6 downto 0);
    signal OrigULA_A, OrigULA_B : out std_logic_vector(1 downto 0);
    signal next_state : out std_logic_vector(2 downto 0)
  ) is
  begin
    OrigULA_A <= "00";
    OrigULA_B <= "00";
    ULAop <= R_TYPE;
    next_state <= STATE_3;
  end ex_R_type;

  procedure ex_I_type(
    signal ULAop : out std_logic_vector(6 downto 0);
    signal OrigULA_A, OrigULA_B : out std_logic_vector(1 downto 0);
    signal next_state : out std_logic_vector(2 downto 0)
  ) is
  begin
    OrigULA_A <= "00";
    OrigULA_B <= "10";
    ULAop <= I_TYPE;
    next_state <= STATE_3;
  end ex_I_type;

  procedure ex_S_I2_type(
    signal ULAop : out std_logic_vector(6 downto 0);
    signal OrigULA_A, OrigULA_B : out std_logic_vector(1 downto 0);
    signal next_state : out std_logic_vector(2 downto 0)
  ) is
  begin
    OrigULA_A <= "00";
    OrigULA_B <= "10";
    ULAop <= opcode;
    next_state <= STATE_3;
  end ex_S_I2_type;

  procedure ex_BEQ(
    signal ULAop : out std_logic_vector(6 downto 0);
    signal OrigULA_A, OrigULA_B : out std_logic_vector(1 downto 0);
    signal OrigPC, Branch : out std_logic;
    signal next_state : out std_logic_vector(2 downto 0)
  ) is
  begin
    OrigULA_A <= "00";
    OrigULA_B <= "00";
    OrigPC <= '1';
    Branch <= '1';
    ULAop <= opcode;
    next_state <= STATE_0;
  end ex_BEQ;

  procedure ex_JAL(
    signal Mem2Reg : out std_logic_vector(1 downto 0);
    signal EscrevePC, EscreveReg, OrigPC : out std_logic;
    signal next_state : out std_logic_vector(2 downto 0)
  ) is
  begin
    EscrevePC <= '1';
    EscreveReg <= '1';
    OrigPC <= '1';
    Mem2Reg <= "01";
    next_state <= STATE_0;
  end ex_JAL;

  procedure ex_U_type(
    signal is_lui : out std_logic;
    signal ULAop : out std_logic_vector(6 downto 0);
    signal OrigULA_A, OrigULA_B : out std_logic_vector(1 downto 0);
    signal next_state : out std_logic_vector(2 downto 0)
  ) is
  begin
    if opcode = "0110111" then is_lui <= '1'; else is_lui <= '0'; end if;
    OrigULA_A <= "01";
    OrigULA_B <= "10";
    ULAop <= opcode;
    next_state <= STATE_3;
  end ex_U_type;

  procedure wb_RIU_type(
    signal EscreveReg, is_lui : out std_logic;
    signal Mem2Reg : out std_logic_vector(1 downto 0);
    signal next_state : out std_logic_vector(2 downto 0)
  ) is
  begin
    is_lui <= '0';
    EscreveReg <= '1';
    Mem2Reg <= "00";
    next_state <= STATE_0;
  end wb_RIU_type;

  procedure wb_S_I2_type(
    signal EscreveMEM, LeMem, IouD : out std_logic;
    signal next_state : out std_logic_vector(2 downto 0)
  ) is
  begin
    case opcode is
      when S_TYPE =>
        EscreveMEM <= '1';
        LeMem <= '0';
        next_state <= STATE_0;
      when I_2_TYPE =>
        EscreveMEM <= '0';
        LeMem <= '1';
        next_state <= STATE_4;
      when others =>
        NULL;
    end case;
    IouD <= '1';
  end wb_S_I2_type;

  procedure wb_ls_2_reg(
    signal EscreveReg : out std_logic;
    signal Mem2Reg : out std_logic_vector(1 downto 0);
    signal next_state : out std_logic_vector(2 downto 0)
  ) is
  begin
    EscreveReg <= '1';
    Mem2Reg <= "10";
    next_state <= STATE_0;
  end wb_ls_2_reg;

begin
  process(current_state) is
  begin
    case current_state is
---------------------------------------------------------- fetch
      when STATE_0 =>
        fetch(
          EscreveMEM => EscreveMEM,
          is_lui => is_lui,
          EscreveReg => EscreveReg,
          EscrevePCB => EscrevePCB,
          EscrevePC => EscrevePC,
          EscreveIR => EscreveIR,
          IouD => IouD,
          OrigPC => OrigPC,
          LeMem => LeMem,
          ULAop => ULAop,
          OrigULA_A => OrigULA_A,
          OrigULA_B => OrigULA_B,
          next_state => next_state
        );
---------------------------------------------------------- decode
      when STATE_1 =>
        decode(
          Branch => Branch,
          EscreveIR => EscreveIR,
          EscrevePCB => EscrevePCB,
          EscrevePC => EscrevePC,
          ULAop => ULAop,
          OrigULA_A => OrigULA_A,
          OrigULA_B => OrigULA_B,
          next_state => next_state
        );
---------------------------------------------------------- execute
      when STATE_2 =>
        case opcode is
          when R_TYPE =>
            ex_R_type(
              ULAop => ULAop,
              OrigULA_A => OrigULA_A,
              OrigULA_B => OrigULA_B,
              next_state => next_state
            );
          when I_TYPE =>
            ex_I_type(
              ULAop => ULAop,
              OrigULA_A => OrigULA_A,
              OrigULA_B => OrigULA_B,
              next_state => next_state
            );
          when S_TYPE | I_2_TYPE =>
            ex_S_I2_type(
              ULAop => ULAop,
              OrigULA_A => OrigULA_A,
              OrigULA_B => OrigULA_B,
              next_state => next_state
            );
          when B_TYPE =>
              ex_BEQ(
                ULAop => ULAop,
                OrigULA_A => OrigULA_A,
                OrigULA_B => OrigULA_B,
                OrigPC => OrigPC,
                Branch => Branch,
                next_state => next_state
              );
          when J_TYPE =>
              ex_JAL(
                EscrevePC => EscrevePC,
                Mem2Reg => Mem2Reg,
                EscreveReg => EscreveReg,
                OrigPC => OrigPC,
                next_state => next_state
              );
          when  U_TYPE | U_2_TYPE =>
            ex_U_type(
              is_lui => is_lui,
              ULAop => ULAop,
              OrigULA_A=> OrigULA_A,
              OrigULA_B=> OrigULA_B,
              next_state => next_state
            );
          when others => NULL;
        end case;
---------------------------------------------------------- write-back
      when STATE_3 =>
        case opcode is
          when R_TYPE | I_TYPE | U_TYPE | U_2_TYPE =>
            wb_RIU_type(
              is_lui => is_lui,
              EscreveReg => EscreveReg,
              Mem2Reg => Mem2Reg,
              next_state => next_state
            );
          when S_TYPE | I_2_TYPE =>
            wb_S_I2_type(
              EscreveMEM => EscreveMEM,
              LeMem => LeMem,
              IouD => IouD,
              next_state => next_state
            );
          when others => NULL;
        end case;
---------------------------------------------------------- write-back lw
      when STATE_4 =>
        wb_ls_2_reg(
          EscreveReg => EscreveReg,
          Mem2Reg => Mem2Reg,
          next_state => next_state
        );
----------------------------------------------------------
      when others => NULL;
    end case;
  end process;
end CTL_arch;
