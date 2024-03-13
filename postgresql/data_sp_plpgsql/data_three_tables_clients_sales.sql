CREATE OR REPLACE PROCEDURE cap19.inserir_clientes_aleatorios(num_clientes INT)
LANGUAGE plpgsql
AS $$
DECLARE
    
    i INT;
    
    nome_aleatorio VARCHAR(255);
    endereco_aleatorio VARCHAR(255);
    cidade_aleatoria VARCHAR(255);

    lista_cidades TEXT[] := ARRAY['São Paulo', 
                                  'Rio de Janeiro', 
                                  'Belo Horizonte', 
                                  'Vitória', 
                                  'Porto Alegre', 
                                  'Salvador', 
                                  'Blumenau', 
                                  'Curitiba', 
                                  'Fortaleza', 
                                  'Manaus', 
                                  'Recife', 
                                  'Goiânia'
    ];
BEGIN
    FOR i IN 1..num_clientes LOOP
        
        -- Gera um nome aleatório no formato: Cliente_i_LETRA
        nome_aleatorio := 'Cliente_' || i || '_' || chr(trunc(65 + random()*25)::int);

        -- Na linha acima nós temos:
        -- random(): Gera um número aleatório entre 0 (inclusive) e 1 (exclusivo).
        -- random()*25: Multiplica o número aleatório por 25. O resultado está no intervalo de 0 a 24.999... .
        -- 65 + random()*25: Adiciona 65 ao resultado anterior. Agora, o resultado está no intervalo de 65 a 89.999... . Os números 65 a 90 correspondem aos códigos ASCII das letras maiúsculas A-Z.
        -- trunc(...): A função trunc remove a parte fracionária do número, resultando em um inteiro entre 65 e 89.
        -- ::int: É uma cast para o tipo inteiro, embora trunc já retorne um inteiro, garantindo que o resultado seja um número inteiro.
        -- chr(...): Converte o número inteiro de volta em um caractere, de acordo com a tabela ASCII. Isso resultará em uma letra maiúscula aleatória entre A e Z.

        -- Gera um endereço aleatório no formato: Rua LETRA, numero
        endereco_aleatorio := 'Rua ' || chr(trunc(65 + random()*25)::int) || ', ' || trunc(random()*1000)::text;

        -- Seleciona uma cidade aleatória
        SELECT INTO cidade_aleatoria 
            lista_cidades[trunc(random() * array_upper(lista_cidades, 1)) + 1] AS cidade;

        -- Na linha acima nós temos:
        -- random() gera um número aleatório entre 0 (inclusive) e 1 (exclusivo).
        -- array_upper(lista_cidades, 1) retorna o maior índice válido do array lista_cidades (ou seja, o tamanho do array).
        -- Multiplicar random() pelo tamanho do array resulta em um número no intervalo de 0 até o tamanho do array (mas não incluindo o limite superior).
        -- A função trunc é usada para arredondar o número para baixo para o inteiro mais próximo, resultando em um índice entre 0 e o tamanho do array menos 1.
        -- Adicionar 1 ajusta o índice para o intervalo de 1 até o tamanho do array, que são índices válidos em PostgreSQL (os arrays começam em 1, não em 0).

        -- Insere os dados na tabela 'clientes'
        INSERT INTO cap19.clientes (nome, endereco, cidade) VALUES
        (nome_aleatorio, endereco_aleatorio, cidade_aleatoria);

    END LOOP;
END;
$$;

-- Para executar a Stored Procedure e inserir um número específico de clientes, use:
CALL cap19.inserir_clientes_aleatorios(1000);


-- Cria a Stored Procedure 
CREATE OR REPLACE PROCEDURE cap19.inserir_interacoes_exemplo()
LANGUAGE plpgsql
AS $$
DECLARE

    -- Variáveis
    cliente RECORD;
    data_aleatoria DATE;
    
BEGIN

    -- Itera sobre cada cliente na tabela 'clientes'
    FOR cliente IN SELECT cliente_id FROM cap19.clientes LOOP
    
        -- Gera uma data aleatória entre 2021 e 2025
        data_aleatoria := '2021-01-01'::DATE + (trunc(random() * (365 * 5))::INT);

        -- Insere uma interação de exemplo para cada cliente com data aleatória
        INSERT INTO cap19.interacoes (cliente_id, tipo_interacao, descricao, data_hora) VALUES
        (cliente.cliente_id, 'Email', 'Email enviado com informações do produto', data_aleatoria),
        (cliente.cliente_id, 'Telefone', 'Chamada telefônica para acompanhamento', data_aleatoria),
        (cliente.cliente_id, 'Reunião', 'Reunião agendada para discussão de detalhes', data_aleatoria);

    END LOOP;
END;
$$;

-- Para executar a Stored Procedure, use:
CALL cap19.inserir_interacoes_exemplo();


-- Cria a Stored Procedure 
CREATE OR REPLACE PROCEDURE cap19.inserir_vendas_exemplo()
LANGUAGE plpgsql
AS $$
DECLARE

    -- Variáveis
    cliente RECORD;
    numero_vendas INT;
    quantidade_venda INT;
    valor_venda DECIMAL(10, 2);
    data_venda_aleatoria DATE;
    
BEGIN

    -- Itera sobre cada cliente na tabela 'clientes'
    FOR cliente IN SELECT cliente_id FROM cap19.clientes LOOP
    
        -- Gera entre 1 a 5 vendas para cada cliente
        numero_vendas := trunc(random() * 5 + 1)::INT; 

        -- Insere vendas aleatórias para o cliente
        FOR i IN 1..numero_vendas LOOP
        
            -- Gera um valor aleatório para a venda (Valores entre 500 e 10500)
            valor_venda := trunc(random() * 10000 + 500)::DECIMAL; 

            -- Gera uma quantidade aleatória para a venda
            quantidade_venda := trunc(random() * 10 + 1)::INT;

            -- Gera uma data de venda aleatória entre 2021 e 2025
            data_venda_aleatoria := '2021-01-01'::DATE + (trunc(random() * (365 * 5))::INT);

            -- Insere a venda na tabela 'vendas'
            INSERT INTO cap19.vendas (cliente_id, quantidade, valor_venda, data_venda) VALUES
            (cliente.cliente_id, quantidade_venda, valor_venda, data_venda_aleatoria);
            
        END LOOP;
    END LOOP;
END;
$$;

-- Para executar a Stored Procedure, use:
CALL cap19.inserir_vendas_exemplo();



--Comments