-- Stored Procedure para carregar os dados
CREATE OR REPLACE PROCEDURE cap21.carrega_dados()
LANGUAGE plpgsql
AS $$
BEGIN
    -- Inserindo dados na tabela Autores
    FOR i IN 1..100 LOOP
        INSERT INTO cap21.autores (Nome, Nacionalidade)
        VALUES ('Autor ' || i, 'Nacionalidade ' || i);
    END LOOP;

    -- Inserindo dados na tabela Livros
    FOR i IN 1..300 LOOP
        INSERT INTO cap21.livros (Titulo, AnoPublicacao, Genero)
        VALUES ('Livro ' || i, 2000 + (i % 20), 'Genero ' || (i % 5));
    END LOOP;

    -- Associando autores e livros de maneira simplificada, com preço e data de lançamento
    FOR i IN 1..1500000 LOOP
        BEGIN
            INSERT INTO cap21.autoreslivros (AutorID, LivroID, Preco, DataLancamento)
            VALUES (
                (SELECT AutorID FROM cap21.autores ORDER BY RANDOM() LIMIT 1), -- Seleciona um AutorID aleatório
                (SELECT LivroID FROM cap21.livros ORDER BY RANDOM() LIMIT 1), -- Seleciona um LivroID aleatório
                ROUND((RANDOM() * 200)::numeric, 2), -- Gera um preço aleatório entre 0 e 200
                ('2010-01-01'::date + (RANDOM() * (3650))::int * '1 day'::interval)::date -- Gera uma data de lançamento aleatória no intervalo de 10 anos
            );
        EXCEPTION WHEN unique_violation THEN
            -- Ignora a violação de chave primária e continua. Nosso objetivo é apenas criar dados fictícios de exemplo.
        END;
    END LOOP;
END;
$$;
-- Executa a SP
CALL cap21.carrega_dados();

--Not Comments