library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

--------------------------------------------------
-- ALU 8-bit VHDL
--------------------------------------------------
entity arithmeticlogicunit is
  generic ( 
    N : natural := 1  -- number of bits for shift/rotate
  );
  Port (
    A, B      : in  STD_LOGIC_VECTOR(7 downto 0);  -- 8-bit inputs
    ALU_Sel   : in  STD_LOGIC_VECTOR(3 downto 0);  -- 4-bit selector
    ALU_Out   : out STD_LOGIC_VECTOR(7 downto 0);  -- 8-bit output
    Carryout  : out STD_LOGIC                     -- carry flag
  );
end arithmeticlogicunit;

architecture Behavioral of arithmeticlogicunit is
  signal ALU_Result : STD_LOGIC_VECTOR(7 downto 0);
  signal tmp        : STD_LOGIC_VECTOR(8 downto 0); -- for carry
begin

  process (A, B, ALU_Sel)
  begin
    case ALU_Sel is
      when "0000" => -- Addition
        ALU_Result <= A + B;

      when "0001" => -- Subtraction
        ALU_Result <= A - B;

      when "0010" => -- Multiplication
        ALU_Result <= std_logic_vector(to_unsigned(to_integer(unsigned(A)) * to_integer(unsigned(B)), 8));

      when "0011" => -- Division
        if B /= "00000000" then
          ALU_Result <= std_logic_vector(to_unsigned(to_integer(unsigned(A)) / to_integer(unsigned(B)), 8));
        else
          ALU_Result <= (others => '0'); -- prevent div-by-zero
        end if;

      when "0100" => -- Logical shift left
        ALU_Result <= std_logic_vector(unsigned(A) sll N);

      when "0101" => -- Logical shift right
        ALU_Result <= std_logic_vector(unsigned(A) srl N);

      when "0110" => -- Rotate left
        ALU_Result <= std_logic_vector(unsigned(A) rol N);

      when "0111" => -- Rotate right
        ALU_Result <= std_logic_vector(unsigned(A) ror N);

      when "1000" => -- AND
        ALU_Result <= A and B;

      when "1001" => -- OR
        ALU_Result <= A or B;

      when "1010" => -- XOR
        ALU_Result <= A xor B;

      when "1011" => -- NOR
        ALU_Result <= not (A or B);

      when "1100" => -- NAND
        ALU_Result <= not (A and B);

      when "1101" => -- XNOR
        ALU_Result <= A xnor B;

      when "1110" => -- A > B
        if unsigned(A) > unsigned(B) then
          ALU_Result <= x"01";
        else
          ALU_Result <= x"00";
        end if;

      when "1111" => -- A == B
        if A = B then
          ALU_Result <= x"01";
        else
          ALU_Result <= x"00";
        end if;

      when others =>
        ALU_Result <= (others => '0');
    end case;
  end process;

  -- Outputs
  ALU_Out <= ALU_Result;
  tmp <= ('0' & A) + ('0' & B);
  Carryout <= tmp(8); -- the 9th bit (carry out)

end Behavioral;
