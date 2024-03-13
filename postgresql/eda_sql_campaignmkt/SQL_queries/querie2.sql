SELECT * FROM eda_campaign.marketing;

-- Valores unicos coluna target
SELECT DISTINCT target
FROM eda_campaign.marketing;


-- Update que substitua o caracter "?" na coluna target pelo valor "Others".

UPDATE eda_campaign.marketing
SET target = 'Others'
WHERE target = '?';


-- Total de registros de cada valor da coluna channels.

SELECT channels, COUNT(*) as total_records
FROM eda_campaign.marketing
GROUP BY channels;


-- Update que substitua os valores ausentes pela moda da coluna channels

SELECT channels
FROM eda_campaign.marketing
WHERE channels IS NOT NULL
GROUP BY channels
ORDER BY COUNT(*) DESC
LIMIT 1;

-- Update com a moda
UPDATE eda_campaign.marketing
SET channels = 'Social media'
WHERE channels IS NULL;

-- Total de registros de cada valor da coluna type_campaign.

SELECT type_campaign, COUNT(*) as total_records
FROM eda_campaign.marketing
GROUP BY type_campaign;


-- Valores ausentes na coluna type_campaign sejam erros de coleta de dados, então fazer o delete que remova os registros onde type_campaign com valor nulo.

DELETE FROM eda_campaign.marketing
WHERE type_campaign IS NULL;


-- Valores ausentes restantes:

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