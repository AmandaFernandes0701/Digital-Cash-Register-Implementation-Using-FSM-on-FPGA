LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;  -- Importa a biblioteca correta para operações aritméticas

-- Entidade para dois displays de 7 segmentos
Entity display is
   port (
        entrada: in std_logic_vector(3 downto 0);  -- Valor de 4 bits
        saida_unidades: out std_logic_vector(6 downto 0);  -- Display das unidades
        saida_dezenas: out std_logic_vector(6 downto 0)  -- Display das dezenas
    );
end display;

architecture with_select_display of display is
    signal not_saida_unidades: std_logic_vector(6 downto 0);
    signal not_saida_dezenas: std_logic_vector(6 downto 0);
    signal unidades: unsigned(3 downto 0);  -- Alterado para tipo unsigned
    signal dezenas: unsigned(3 downto 0);   -- Alterado para tipo unsigned
begin

    -- Cálculo das unidades e dezenas
    unidades <= to_unsigned(to_integer(unsigned(entrada)) mod 10, 4);  -- Resto da divisão por 10
    dezenas <= to_unsigned(to_integer(unsigned(entrada)) / 10, 4);    -- Quociente da divisão por 10

    -- Decodificação das unidades
    with unidades select
        not_saida_unidades <= "1111110" when "0000",  -- 0
                              "0110000" when "0001",  -- 1
                              "1101101" when "0010",  -- 2
                              "1111001" when "0011",  -- 3
                              "0110011" when "0100",  -- 4
                              "1011011" when "0101",  -- 5
                              "1011111" when "0110",  -- 6
                              "1110000" when "0111",  -- 7
                              "1111111" when "1000",  -- 8
                              "1111011" when "1001",  -- 9
                              "0000000" when others;  -- Apagado para entradas inválidas

    -- Decodificação das dezenas
    with dezenas select
        not_saida_dezenas <= "1111110" when "0000",  -- 0
                             "0110000" when "0001",  -- 1
                             "1101101" when "0010",  -- 2
                             "1111001" when "0011",  -- 3
                             "0110011" when "0100",  -- 4
                             "1011011" when "0101",  -- 5
                             "1011111" when "0110",  -- 6
                             "1110000" when "0111",  -- 7
                             "1111111" when "1000",  -- 8
                             "1111011" when "1001",  -- 9
                             "0000000" when others;  -- Apagado para entradas inválidas

    -- Inversão para lógica ativa-baixa
    saida_unidades <= not (not_saida_unidades);
    saida_dezenas <= not (not_saida_dezenas);

end with_select_display;
