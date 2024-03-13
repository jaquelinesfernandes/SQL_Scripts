SELECT * FROM eda_campaign.marketing;

-- Label Encoding colunas 'target', 'channels' e 'type_campaign':

-- Cria a nova coluna 'public_target_encoded'
ALTER TABLE eda_campaign.marketing
ADD COLUMN public_target_encoded INT;

-- Verifica os valores únicos
SELECT DISTINCT target
FROM eda_campaign.marketing;

-- Carrega a nova coluna
UPDATE eda_campaign.marketing
SET public_target_encoded = 
    CASE target
        WHEN 'Public Target1' THEN 1
        WHEN 'Public Target2' THEN 2
        WHEN 'Public Target3' THEN 3
        WHEN 'Public Target4' THEN 4
        WHEN 'Public Target5' THEN 5
        WHEN 'Others' THEN 0
        ELSE NULL
    END;

-- Verificando dados:

SELECT DISTINCT public_target_encoded, COUNT (*) AS cont
FROM eda_campaign.marketing
GROUP BY public_target_encoded;


-- Cria a nova coluna 'channels_encoded'
ALTER TABLE eda_campaign.marketing
ADD COLUMN channels_encoded INT;

-- Verifica os valores únicos
SELECT channels, COUNT(*) as total_records
FROM eda_campaign.marketing
GROUP BY channels;

-- Carrega a nova coluna
UPDATE eda_campaign.marketing
SET channels_encoded = 
    CASE channels
        WHEN 'Google' THEN 1
        WHEN 'Social media' THEN 2
        WHEN 'News Sites' THEN 3
        ELSE NULL
    END;

SELECT DISTINCT channels_encoded, COUNT (*) AS cont
FROM eda_campaign.marketing
GROUP BY channels_encoded;


-- Cria a nova coluna 'type_campaign_encoded'
ALTER TABLE eda_campaign.marketing
ADD COLUMN type_campaign_encoded INT;

-- Verifica os valores únicos
SELECT type_campaign, COUNT(*) as total_records
FROM eda_campaign.marketing
GROUP BY type_campaign;

-- Carrega a nova coluna
UPDATE eda_campaign.marketing
SET type_campaign_encoded = 
    CASE type_campaign
        WHEN 'Promotional' THEN 1
        WHEN 'Disclosure' THEN 2
        WHEN 'More Followers' THEN 3
        ELSE NULL
    END;

SELECT DISTINCT type_campaign_encoded, COUNT (*) AS cont
FROM eda_campaign.marketing
GROUP BY type_campaign_encoded;

SELECT * FROM eda_campaign.marketing;


-- Drop das 3 colunas originais que foram codificadas

ALTER TABLE eda_campaign.marketing
DROP COLUMN target,
DROP COLUMN channels,
DROP COLUMN type_campaign;

-- Verifica valores ausentes 
SELECT
    COUNT(*) - COUNT(id) AS id_missing,
    COUNT(*) - COUNT(name_campaign) AS name_campaign_missing,
    COUNT(*) - COUNT(data_start) AS data_start_missing,
    COUNT(*) - COUNT(data_end) AS data_end_missing,
    COUNT(*) - COUNT(budget) AS budget_missing,
    COUNT(*) - COUNT(target) AS public_target_missing,
    COUNT(*) - COUNT(channels) AS channels_missing,
    COUNT(*) - COUNT(type_campaign) AS type_campaign_missing,
    COUNT(*) - COUNT(conversion_rate) AS conversion_rate_missing,
    COUNT(*) - COUNT(impressions) AS impressions_missing
FROM eda_campaign.marketing;


--Comments