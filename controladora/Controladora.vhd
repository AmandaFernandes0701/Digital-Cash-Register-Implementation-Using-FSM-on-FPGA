library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity controladora is
    port (
        CLK             : in std_logic;                   -- Relógio
        RESET           : in std_logic;                   -- Reset
        INPUT           : in std_logic_vector(3 downto 0); -- Entrada do valor
        OPERATION       : in std_logic;                   -- '0' para soma, '1' para subtração
        BUTTON_PRESSED  : in std_logic;                   -- Identifica se o usuário confirmou o valor do número
		  BUTTON_OPERATOR_PRESSED  : in std_logic;          -- Identifica se o usuário confirmou o valor da operação
        ENABLE_REG      : out std_logic;                  -- Habilita o registrador
        ENABLE_CALC     : out std_logic;                  -- Habilita o módulo de cálculo
        ENABLE_DISPLAY  : out std_logic;                  -- Habilita o display
        Q_REG           : in std_logic_vector(3 downto 0); -- Saída do registrador
        OUTPUT          : out std_logic_vector(3 downto 0) -- Resultado da operação
    );
end controladora;

architecture fsm of controladora is
    -- Definindo os estados
    type state_type is (S0, S1, S2, S3);
    signal state, next_state : state_type;

    -- Instância do datapath
    COMPONENT datapath
        GENERIC (
            W : INTEGER := 4
        );
        PORT (
            clk                : IN  std_logic;                  -- Relógio
            reset              : IN  std_logic;                  -- Reset
            BUTTON_PRESSED     : IN  std_logic;                  -- Botão pressionado (confirmar número)
				BUTTON_OPERATOR_PRESSED     : IN  std_logic;         -- Botão pressionado (confirmar operador)
            valor_inserido     : IN  std_logic_vector(W-1 DOWNTO 0); -- Valor inserido
            operador           : IN  std_logic;                  
            display_unidades   : OUT std_logic_vector(6 DOWNTO 0); -- Unidades no display
            display_dezenas    : OUT std_logic_vector(6 DOWNTO 0); -- Dezenas no display
            resultado          : OUT std_logic_vector(W-1 DOWNTO 0) -- Resultado da operação
        );
    END COMPONENT;

    -- Sinal interno para com	unicação com o datapath
    signal resultado_datapath : std_logic_vector(3 downto 0);

begin

    -- Instância do datapath
    datapath_inst: datapath
        GENERIC MAP (W => 4)
        PORT MAP (
            clk                => CLK,
            reset              => RESET,
            BUTTON_PRESSED     => BUTTON_PRESSED,
				BUTTON_OPERATOR_PRESSED     => BUTTON_OPERATOR_PRESSED,
            valor_inserido     => INPUT,
				operador           => '0',
            display_unidades   => open,               -- Não usado diretamente
            display_dezenas    => open,               -- Não usado diretamente
            resultado          => resultado_datapath
        );

    -- Mapeando o resultado do datapath para a saída da controladora
    OUTPUT <= resultado_datapath;

    -- Processo da máquina de estados
    process(CLK, RESET)
    begin
        if RESET = '1' then
            state <= S0;
        elsif rising_edge(CLK) then
            state <= next_state;
        end if;
    end process;

    -- Definição da próxima transição de estado
    process (state, BUTTON_PRESSED, BUTTON_OPERATOR_PRESSED)
    begin
        next_state <= state;
        case state is
            when S0 =>
                if BUTTON_PRESSED = '1' then
                    next_state <= S1;
                end if;

            when S1 =>
                if BUTTON_OPERATOR_PRESSED = '1' then
                    next_state <= S2;
                end if;

            when S2 =>
                next_state <= S3;

            when S3 =>
                next_state <= S0;

            when others =>
                next_state <= S0;
        end case;
    end process;

    -- Lógica de controle das saídas
    process(state)
    begin
        ENABLE_REG      <= '0';
        ENABLE_CALC     <= '0';
        ENABLE_DISPLAY  <= '0';

        case state is
            when S0 =>  -- Habilita o registrador para inserção de valor
                ENABLE_REG <= '1';

            when S1 =>  -- Habilita o cálculo
					 ENABLE_REG <= '0';
                ENABLE_CALC <= '1';

            when S2 =>  -- Calcula o resultado
                ENABLE_CALC <= '1';

            when S3 =>  -- Exibe o resultado
                ENABLE_DISPLAY <= '1';

            when others =>
                -- Mantém os valores padrão
        end case;
    end process;

end fsm;
