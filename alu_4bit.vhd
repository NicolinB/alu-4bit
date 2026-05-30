-- ============================================================
-- alu_4bit.vhd
-- 4-bit Arithmetic Logic Unit
--
-- Operations (SEL = SW[9:7]):
--   000  ADD   A + B
--   001  SUB   A - B
--   010  AND   A and B
--   011  OR    A or  B
--   100  XOR   A xor B
--   101  NOT   not A
--   110  SHL   A << 1 (shift left)
--   111  SHR   A >> 1 (shift right)
--
-- DE10-Lite mapping:
--   SW[3:0]   -> A
--   SW[7:4]   -> B
--   SW[9:7]   -> SEL (operation)
--   LEDR[3:0] -> Result Y
--   LEDR[4]   -> Z  (zero flag)
--   LEDR[5]   -> S  (sign flag = MSB of result)
--   LEDR[6]   -> OV (overflow, only for ADD/SUB)
--   LEDR[7]   -> C  (carry out)
--
-- Author: Barbaros Nicolin
-- ============================================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu_4bit is
    port (
        SW   : in  STD_LOGIC_VECTOR(9 downto 0);
        LEDR : out STD_LOGIC_VECTOR(9 downto 0)
    );
end alu_4bit;

architecture Behavioral of alu_4bit is

    signal A   : STD_LOGIC_VECTOR(3 downto 0);
    signal B   : STD_LOGIC_VECTOR(3 downto 0);
    signal SEL : STD_LOGIC_VECTOR(2 downto 0);

    -- 5-bit result: bit 4 = carry out, bits 3:0 = result
    signal res5 : UNSIGNED(4 downto 0);

    signal Y  : STD_LOGIC_VECTOR(3 downto 0);
    signal C  : STD_LOGIC;   -- carry out
    signal Z  : STD_LOGIC;   -- zero flag
    signal S  : STD_LOGIC;   -- sign flag (= MSB)
    signal OV : STD_LOGIC;   -- overflow (ADD/SUB only)

begin

    -- Connect switches to signals
    A   <= SW(3 downto 0);
    B   <= SW(7 downto 4);
    SEL <= SW(9 downto 7);

    -- ALU combinational logic
    process(A, B, SEL)
    begin
        case SEL is
            when "000" =>   -- ADD
                res5 <= unsigned('0' & A) + unsigned('0' & B);

            when "001" =>   -- SUB
                res5 <= unsigned('0' & A) - unsigned('0' & B);

            when "010" =>   -- AND
                res5 <= '0' & unsigned(A and B);

            when "011" =>   -- OR
                res5 <= '0' & unsigned(A or B);

            when "100" =>   -- XOR
                res5 <= '0' & unsigned(A xor B);

            when "101" =>   -- NOT A
                res5 <= '0' & unsigned(not A);

            when "110" =>   -- Shift Left (A << 1, fill with 0)
                res5 <= '0' & unsigned(A(2 downto 0) & '0');

            when "111" =>   -- Shift Right (A >> 1, fill with 0)
                res5 <= '0' & unsigned('0' & A(3 downto 1));

            when others =>
                res5 <= (others => '0');
        end case;
    end process;

    -- Extract fields from 5-bit result
    Y <= std_logic_vector(res5(3 downto 0));
    C <= res5(4);

    -- Zero flag: set when result is 0000
    Z <= '1' when res5(3 downto 0) = "0000" else '0';

    -- Sign flag: MSB of result
    S <= res5(3);

    -- Overflow: meaningful only for ADD/SUB
    -- Positive + Positive = Negative → overflow
    -- Negative + Negative = Positive → overflow
    OV <= (not A(3) and not B(3) and res5(3)) or
          (A(3) and B(3) and not res5(3))
          when (SEL = "000" or SEL = "001") else '0';

    -- Map outputs to LEDs
    LEDR(3 downto 0) <= Y;
    LEDR(4)          <= Z;
    LEDR(5)          <= S;
    LEDR(6)          <= OV;
    LEDR(7)          <= C;
    LEDR(9 downto 8) <= "00";   -- unused LEDs off

end Behavioral;
