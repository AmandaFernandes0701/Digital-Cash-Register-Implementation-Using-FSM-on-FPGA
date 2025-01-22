library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity tb_controladora is
end tb_controladora;

architecture behavior of tb_controladora is

    -- Declaração do componente
    component controladora is
        port (
            CLK            : in std_logic;              -- Relógio
            RESET          : in std_logic;              -- Reset
            INPUT          : in std_logic_vector(3 downto 0);  -- Entrada do valor
            OPERATION      : in std_logic;              -- '0' para soma, '1' para subtração
            BUTTON_PRESSED : in std_logic;             -- Identifica se o usuário confirmou o valor ou operação
            ENABLE_REG     : out std_logic;             -- Habilita o registrador
            ENABLE_CALC    : out std_logic;             -- Habilita o módulo de cálculo
            ENABLE_DISPLAY : out std_logic;             -- Habilita o display
            Q_REG          : in std_logic_vector(3 downto 0); -- Saída do registrador
            OUTPUT         : out std_logic_vector(3 downto 0)  -- Resultado da operação
        );
    end component;

    -- Declaração dos sinais
    signal CLK            : std_logic := '0';
    signal RESET          : std_logic := '0';
    signal INPUT          : std_logic_vector(3 downto 0) := (others => '0');
    signal OPERATION      : std_logic := '0';
    signal BUTTON_PRESSED : std_logic := '0';
    signal ENABLE_REG     : std_logic;
    signal ENABLE_CALC    : std_logic;
    signal ENABLE_DISPLAY : std_logic;
    signal Q_REG          : std_logic_vector(3 downto 0) := (others => '0');
    signal OUTPUT         : std_logic_vector(3 downto 0);
    signal flag_write     : std_logic := '0';  -- Flag para indicar quando escrever no arquivo

    -- Geração do relógio
    constant CLK_PERIOD : time := 10 ns;

    -- Arquivo de saída com caminho absoluto
    file output_file : text open write_mode is "C:/Users/Aluno/Projetos/Projeto1_Amanda_Thiago/output.txt";  -- Arquivo de saída para armazenar o valor calculado

begin
    -- Processo de geração de clock
    CLK_PROCESS : process
    begin
        CLK <= '0';
        wait for CLK_PERIOD / 2;
        CLK <= '1';
        wait for CLK_PERIOD / 2;
    end process;

    -- Instanciando o componente da controladora
    UUT: controladora
    port map (
        CLK => CLK,
        RESET => RESET,
        INPUT => INPUT,
        OPERATION => OPERATION,
        BUTTON_PRESSED => BUTTON_PRESSED,
        ENABLE_REG => ENABLE_REG,
        ENABLE_CALC => ENABLE_CALC,
        ENABLE_DISPLAY => ENABLE_DISPLAY,
        Q_REG => Q_REG,
        OUTPUT => OUTPUT
    );

    -- Processo de escrever os dados de saída no arquivo
    write_outputs : process
        variable line_buffer : line;
        variable output_value : std_logic_vector(3 downto 0);  -- Para armazenar o valor de saída
        variable input_value : std_logic_vector(3 downto 0);   -- Para armazenar o valor de entrada
        variable operation_str : string(1 to 1);  -- Para armazenar a operação
        variable input_value2 : std_logic_vector(3 downto 0);  -- Segundo valor de entrada
        variable result_value : std_logic_vector(3 downto 0);  -- Resultado
    begin
        wait until CLK = '0';
        while true loop
            if (flag_write = '1') then
                -- Captura os valores de entrada, operação e saída
                input_value := INPUT;  
                input_value2 := Q_REG;  -- Segundo valor (o valor do registrador ou entrada adicional)
                result_value := OUTPUT;
                
                -- Determina a operação (soma ou subtração)
                if OPERATION = '0' then
                    -- Escreve a operação no formato "x + y = d"
                    write(line_buffer, string'("Operação: "));
                    write(line_buffer, input_value);  -- Primeiro valor
                    write(line_buffer, string'(" + "));
                    write(line_buffer, input_value2);  -- Segundo valor
                    write(line_buffer, string'(" = "));
                    write(line_buffer, result_value);  -- Resultado
                else
                    -- Escreve a operação no formato "x - y = c"
                    write(line_buffer, string'("Operação: "));
                    write(line_buffer, input_value);  -- Primeiro valor
                    write(line_buffer, string'(" - "));
                    write(line_buffer, input_value2);  -- Segundo valor
                    write(line_buffer, string'(" = "));
                    write(line_buffer, result_value);  -- Resultado
                end if;
                
                writeline(output_file, line_buffer);  -- Escreve no arquivo
                --flag_write <= '0';  -- Desativa a flag após escrever
            end if;
            wait for CLK_PERIOD;
        end loop;
    end process;

    -- Processo de teste
    TEST_PROC: process
    begin
        -- Reset inicial
        RESET <= '1';
        wait for 20 ns;
        RESET <= '0';
        wait for 20 ns;

        -- Teste 1: Operação 3 + 2
        
        -- S0: Insere o primeiro valor (3)
        INPUT <= "0011";  -- 3 em binário
        BUTTON_PRESSED <= '1';
        wait for CLK_PERIOD;  -- Espera um ciclo de clock
        BUTTON_PRESSED <= '0';
        wait for CLK_PERIOD;

        -- S1: Insere o segundo valor (2)
        Q_REG <= "0010";  -- 2 em binário
        BUTTON_PRESSED <= '1';
        wait for CLK_PERIOD;  -- Espera um ciclo de clock
        BUTTON_PRESSED <= '0';
        wait for CLK_PERIOD;

        -- S2: Realiza a operação (3 + 2)
        OPERATION <= '0';  -- Operação de soma
        wait for CLK_PERIOD;  -- Espera um ciclo de clock para simular o cálculo

        -- S3: Exibe o resultado (5)
        flag_write <= '1';  -- Ativa a flag para gravar o resultado
        wait for CLK_PERIOD;
        flag_write <= '0';
        wait for 40 ns;  -- Deixa o resultado ser exibido no display
        -- O flag_write será desativado no processo de escrita (depois de gravar)

        -- Finaliza o teste 1
        -- Teste 2: Operação 3 - 2
        
        -- S0: Insere o primeiro valor (3)
        INPUT <= "0011";  -- 3 em binário
        BUTTON_PRESSED <= '1';
        wait for CLK_PERIOD;  -- Espera um ciclo de clock
        BUTTON_PRESSED <= '0';
        wait for CLK_PERIOD;

        -- S1: Insere o segundo valor (2)
        Q_REG <= "0010";  -- 2 em binário
        BUTTON_PRESSED <= '1';
        wait for CLK_PERIOD;  -- Espera um ciclo de clock
        BUTTON_PRESSED <= '0';
        wait for CLK_PERIOD;

        -- S2: Realiza a operação (3 - 2)
        OPERATION <= '1';  -- Operação de subtração
        wait for CLK_PERIOD;  -- Espera um ciclo de clock para simular o cálculo

        -- S3: Exibe o resultado (1)
        flag_write <= '1';  -- Ativa a flag para gravar o resultado
        wait for CLK_PERIOD;
        flag_write <= '0';
        wait for 40 ns;  -- Deixa o resultado ser exibido no display
        -- O flag_write será desativado no processo de escrita (depois de gravar)

        -- Finaliza o teste 2
        assert false report "Test completed." severity failure;
        wait;
    end process;

end behavior;
