CREATE TABLE eda_campaign.marketing (
    id SERIAL,
    name_campaign VARCHAR(255),
    data_start DATE,
    data_end DATE,
    budget DECIMAL(10, 2),
    target VARCHAR(255),
    channels VARCHAR(255), 
    type_campaign VARCHAR(255), 
    conversion_rate DECIMAL(5, 2),
    impressions BIGINT
);



-- Stored procedure for imputation database

CREATE OR REPLACE PROCEDURE eda_campaign.input_data_campaign()
LANGUAGE plpgsql
AS $$
DECLARE
    i INT := 1;
    randomTarget INT;
    randomConversionRate DECIMAL(5, 2);
    randomImpressions BIGINT;
    randomBudget DECIMAL(10, 2);
    randomChannel VARCHAR(255);
    randomCampaignType VARCHAR(255);
    randomStartDate DATE;
    randomEndDate DATE;
    randomPublicTarget VARCHAR(255);
BEGIN
    LOOP
        EXIT WHEN i > 1000;
        
        -- Gerar valores aleatórios
        randomTarget := 1 + (i % 5);
        randomConversionRate := ROUND((RANDOM() * 30)::numeric, 2);
        randomImpressions := (1 + FLOOR(RANDOM() * 10)) * 1000000;

        -- Valores condicionais
        randomBudget := CASE WHEN RANDOM() < 0.8 THEN ROUND((RANDOM() * 100000)::numeric, 2) ELSE NULL END;

        -- Canais de divulgação
        randomChannel := CASE
            WHEN RANDOM() < 0.8 THEN
                CASE FLOOR(RANDOM() * 3)
                    WHEN 0 THEN 'Google'
                    WHEN 1 THEN 'Social media'
                    ELSE 'News Sites'
                END
            ELSE NULL
        END;

        -- Tipo de campanha
        randomCampaignType := CASE
            WHEN RANDOM() < 0.8 THEN
                CASE FLOOR(RANDOM() * 3)
                    WHEN 0 THEN 'Promotional'
                    WHEN 1 THEN 'Disclosure'
                    ELSE 'More Followers'
                END
            ELSE NULL
        END;

        -- Definir datas aleatórias dos últimos 4 anos
        randomStartDate := CURRENT_DATE - (1 + FLOOR(RANDOM() * 1460)) * INTERVAL '1 day';
        randomEndDate := randomStartDate + (1 + FLOOR(RANDOM() * 30)) * INTERVAL '1 day';

        -- Publico Alvo aleatório com possibilidade de "?"
        randomPublicTarget := CASE WHEN RANDOM() < 0.2 THEN '?' ELSE 'Public Target' || randomTarget END;

        -- Inserir registro
        INSERT INTO eda_campaign.marketing 
        (name_campaign, data_start, data_end, budget, target, channels, type_campaign, conversion_rate, impressions)
        VALUES 
        ('Campaign ' || i, randomStartDate, randomEndDate, randomBudget, randomPublicTarget, randomChannel, randomCampaignType, randomConversionRate, randomImpressions);

        i := i + 1;
    END LOOP;
END;
$$;


-- Executa a SP
call eda_campaign.input_data_campaign();


-- Verifica os dados
SELECT * FROM eda_campaign.marketing;

--Comments