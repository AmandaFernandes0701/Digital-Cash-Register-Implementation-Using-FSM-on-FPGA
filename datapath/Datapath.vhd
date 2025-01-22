LIBRARY IEEE;
USE ieee.std_logic_1164.all;

ENTITY datapath IS
    GENERIC (
        W : INTEGER := 4  -- Largura dos dados (pode ser ajustado conforme necessário)
    );
    PORT (
        -- Sinais de controle e de entrada
        clk                : IN  std_logic;                  -- Relógio (entrada)
        reset              : IN  std_logic;                  -- Sinal de reset (entrada)
        BUTTON_PRESSED     : IN  std_logic;                  -- Sinal que identifica se o botão foi pressionado (confirmar número)
		  BUTTON_OPERATOR_PRESSED     : IN  std_logic;         -- Sinal que identifica se o botão foi pressionado (confirmar operador)

        -- Entradas de dados
        valor_inserido     : IN  std_logic_vector(W-1 DOWNTO 0);   -- Valor inserido pelo usuário (entrada)
        operador    : IN  std_logic;
		  
        -- Saídas de dados
        display_unidades   : OUT std_logic_vector(6 DOWNTO 0);   -- Display das unidades (saída)
        display_dezenas    : OUT std_logic_vector(6 DOWNTO 0);   -- Display das dezenas (saída)
        resultado          : OUT std_logic_vector(W-1 DOWNTO 0)  -- Resultado da operação (saída)
    );
END ENTITY datapath;

ARCHITECTURE rtl OF datapath IS

    -- Componentes que serão instanciados no datapath
    COMPONENT RegW
        GENERIC (
            W : INTEGER := 4
        );
        PORT (
            clk     : IN std_logic;
            reset   : IN std_logic;
            enable  : IN std_logic;
            D       : IN std_logic_vector(W-1 DOWNTO 0);
            Q       : OUT std_logic_vector(W-1 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT Reg1
        GENERIC (
            W : INTEGER := 1
        );
        PORT (
            clk     : IN std_logic;
            enable  : IN std_logic;
            D       : IN std_logic;
            Q       : OUT std_logic
        );
    END COMPONENT;

    COMPONENT calculo
        GENERIC (
            W : INTEGER := 4
        );
        PORT (
            CLK       : IN std_logic;
            RESET     : IN std_logic;
            OPERATION : IN std_logic;
				ENABLE_CALC : IN std_logic;
            INPUT     : IN std_logic_vector(W-1 DOWNTO 0);
            OUTPUT    : OUT std_logic_vector(W-1 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT display
        PORT (
            entrada          : IN std_logic_vector(3 DOWNTO 0);
            saida_unidades   : OUT std_logic_vector(6 DOWNTO 0);
            saida_dezenas    : OUT std_logic_vector(6 DOWNTO 0)
        );
    END COMPONENT;

    -- Sinais internos para interconexão entre os componentes
    SIGNAL Sig_Number       : std_logic_vector(3 DOWNTO 0);
    SIGNAL Sig_Operation    : std_logic;
    SIGNAL resultado_internal : std_logic_vector(W-1 DOWNTO 0); -- Sinal interno para armazenar o resultado

BEGIN 

    -- Instância do Registrador para salvar o valor inserido
    Reg_E: RegW
        GENERIC MAP (W => 4)
        PORT MAP (
            clk => clk,
            reset => reset,
            enable => BUTTON_PRESSED,
            D => valor_inserido,
            Q => Sig_Number
        );
        
    -- Instância do Registrador para salvar a operação
    Reg_C: Reg1
        GENERIC MAP (W => 1)
        PORT MAP (
            clk => clk,
            enable => BUTTON_PRESSED,
            D => operador,
            Q => Sig_Operation
        );
        
    -- Instância do Componente de cálculo (soma ou subtração)
    ComponenteCalculoInst: calculo
        GENERIC MAP (W => 4)
        PORT MAP (
            CLK => clk,
            RESET => reset,
            INPUT => valor_inserido,
				ENABLE_CALC => BUTTON_OPERATOR_PRESSED,
            OPERATION => Sig_Operation,
            OUTPUT => resultado_internal -- Ligação ao sinal interno
        );

    -- Atribuição final do sinal interno à saída
    resultado <= resultado_internal;

    -- Instância do Display para mostrar as unidades e as dezenas
    BCD: display
        PORT MAP (
            entrada => resultado_internal(3 DOWNTO 0), -- Passando parte do valor calculado
            saida_unidades => display_unidades,
            saida_dezenas => display_dezenas
        );

END rtl;
