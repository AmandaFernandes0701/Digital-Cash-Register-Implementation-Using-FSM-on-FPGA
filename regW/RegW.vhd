LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

entity RegW is
    generic( W: integer := 4);
    port(
        clk, enable, reset : in std_logic;
        D : in std_logic_vector(W-1 downto 0);
        Q : out std_logic_vector (W-1 downto 0)
    );
end RegW;

architecture comportamental of RegW is
    signal reg: std_logic_vector(W-1 downto 0);
begin
    process(clk, reset) -- Sensível tanto ao clk quanto ao reset
    begin
        if (reset = '1') then
            reg <= (others => '0');  -- Quando o reset é ativo, limpa o registro
        elsif rising_edge(clk) then
            if enable = '1' then
                reg <= D;  -- Quando o enable está ativo, o valor de D é armazenado no reg
            end if;
        end if;
    end process;
    
    Q <= reg;  -- Atribuição de reg para Q fora do processo
    
end comportamental;
