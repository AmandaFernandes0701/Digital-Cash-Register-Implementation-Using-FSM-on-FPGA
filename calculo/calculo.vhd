library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity calculo is
    generic (
        W : integer := 4 -- Largura padrão do vetor
    );
    port (
        CLK       : in  std_logic;                       -- Sinal de relógio
        RESET     : in  std_logic;                       -- Sinal de reset
        INPUT     : in  std_logic_vector(W-1 downto 0);  -- Entrada
        OPERATION : in  std_logic;                       -- '0' para soma, '1' para subtração
        ENABLE_CALC : in  std_logic;                     -- Habilita o cálculo
        OUTPUT    : out std_logic_vector(W-1 downto 0)   -- Saída do resultado
    );
end calculo;

architecture arch of calculo is

signal curr_value : std_logic_vector(W-1 downto 0) := (others => '0');
signal prev_value : std_logic_vector(W-1 downto 0) := (others => '0');
signal result     : std_logic_vector(W-1 downto 0) := (others => '0');

begin
process(CLK, RESET)
begin
    if RESET = '1' then
        -- Resetar valores internos
        curr_value <= (others => '0');
        prev_value <= (others => '0');
        result     <= (others => '0');
    elsif rising_edge(CLK) then
        if ENABLE_CALC = '1' then
            -- Realizar soma ou subtração
            if OPERATION = '0' then
                result <= std_logic_vector(unsigned(curr_value) + unsigned(INPUT)); -- Soma
            elsif OPERATION = '1' then
                result <= std_logic_vector(unsigned(curr_value) - unsigned(INPUT)); -- Subtração
            end if;
            
            -- Atualizar valores internos
            prev_value <= curr_value;
            curr_value <= INPUT;
        else
            -- Manter valor atual de result
            result <= result;
        end if;
    end if;
end process;

-- Atualizar a saída fora do processo
OUTPUT <= result;

end arch;
