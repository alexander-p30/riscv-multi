library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

package riscv_pkg is
  -- general values
  constant T : time := 4 ns;
  constant WSIZE : natural := 32;
  constant ZERO32 : std_logic_vector(WSIZE-1 downto 0) := (others => '0');

  -- instruction types
  constant R_TYPE : std_logic_vector(6 downto 0) := "0110011";
  constant B_TYPE : std_logic_vector(6 downto 0) := "1100011";
  constant I_TYPE : std_logic_vector(6 downto 0) := "0010011";
  constant I_2_TYPE : std_logic_vector(6 downto 0) := "0000011";
  constant I_3_TYPE : std_logic_vector(6 downto 0) := "1100111";
  constant J_TYPE : std_logic_vector(6 downto 0) := "1101111";
  constant U_TYPE : std_logic_vector(6 downto 0) := "0110111";
  constant U_2_TYPE : std_logic_vector(6 downto 0) := "0010111";
  constant S_TYPE : std_logic_vector(6 downto 0) := "0100011";

  -- machine state
  constant STATE_0 : std_logic_vector(2 downto 0) := "000";
  constant STATE_1 : std_logic_vector(2 downto 0) := "001";
  constant STATE_2 : std_logic_vector(2 downto 0) := "010";
  constant STATE_3 : std_logic_vector(2 downto 0) := "011";
  constant STATE_4 : std_logic_vector(2 downto 0) := "100";

  -- components
  component GENERIC_REG is
    port (
      clk: in std_logic;
      we: in std_logic;
      reg_in: in std_logic_vector(WSIZE-1 downto 0);
      reg_out: out std_logic_vector(WSIZE-1 downto 0)
    );
  end component GENERIC_REG;

  component MUX2 is
    port (
      mux_A, mux_B : in std_logic_vector(WSIZE-1 downto 0);
      sel : in std_logic;
      mux_out : out std_logic_vector(WSIZE-1 downto 0)
    );
  end component MUX2;

  component MUX3 is
    port (
      mux_A, mux_B, mux_C : in std_logic_vector(WSIZE-1 downto 0);
      sel : in std_logic_vector(1 downto 0);
      mux_out: out std_logic_vector(WSIZE-1 downto 0)
    );
  end component MUX3;

  component MUX4 is
    port (
      mux_A, mux_B, mux_C, mux_D : in std_logic_vector(WSIZE-1 downto 0);
      sel : in std_logic_vector(1 downto 0);
      mux_out: out std_logic_vector(WSIZE-1 downto 0)
    );
  end component MUX4;

  component MEM_RV is
    port (
      clk : in std_logic;
      we : in std_logic;
      address : in std_logic_vector;
      datain : in std_logic_vector;
      dataout : out std_logic_vector
    );
  end component MEM_RV;

  component XREGS is
    port (
      clk, wren, rst : in std_logic;
      rs1, rs2, rd : in std_logic_vector(4 downto 0);
      data : in std_logic_vector(WSIZE-1 downto 0);
      ro1, ro2 : out std_logic_vector(WSIZE-1 downto 0)
      );
  end component XREGS;

  component genImm32 is
    port(
          instr: in std_logic_vector(WSIZE-1 downto 0);
          imm32: out signed(WSIZE-1 downto 0)
        );
  end component genImm32;

  component ulaRV is
    port (
      opcode : in std_logic_vector(3 downto 0);
      A, B : in std_logic_vector(WSIZE-1 downto 0);
      Z : out std_logic_vector(WSIZE-1 downto 0);
      cond : out std_logic
    );
  end component ulaRV;

  component PC is
    port (
      clk: in std_logic;
      we: in std_logic;
      pc_in: in std_logic_vector(WSIZE-1 downto 0);
      pc_out: out std_logic_vector(WSIZE-1 downto 0)
    );
  end component PC;

  component CTL is
    port (
      opcode : in std_logic_vector(6 downto 0);
      EscreveMEM, EscrevePCB, EscrevePC, IouD, OrigPC, Branch : out std_logic;
      Mem2Reg : out std_logic_vector(1 downto 0);
      EscreveReg : out std_logic;
      LeMem : out std_logic;
      EscreveIR : out std_logic;
      OrigULA_A, OrigULA_B : out std_logic_vector(1 downto 0);
      ULAop : out std_logic_vector(6 downto 0);
      current_state : in std_logic_vector(2 downto 0);
      next_state : out std_logic_vector(2 downto 0)
    );
  end component CTL;

  component CTL_STATE_REGISTER is
    port (
      clk : in std_logic;
      state_in : in std_logic_vector(2 downto 0);
      state_out : out std_logic_vector(2 downto 0)
    );
  end component CTL_STATE_REGISTER;

  component CTL_ULA is
    port (
      ULAop : in std_logic_vector(6 downto 0);
      current_ctl_state : in std_logic_vector(2 downto 0);
      funct3 : in std_logic_vector(2 downto 0);
      funct7 : in std_logic_vector(6 downto 0);
      op : out std_logic_vector(3 downto 0)
    );
  end component CTL_ULA;
end package riscv_pkg;
