SELECT * FROM eda_campaign.marketing;

-- Valores ausentes
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

-- Detalhe valores asusentes coluna 'budget' 
SELECT *
FROM eda_campaign.marketing
WHERE budget IS NULL;

-- Valores nulos para budget com o target 'Others' devem ser deletados.

DELETE FROM eda_campaign.marketing
WHERE budget IS NULL AND target = 'Others';

SELECT *
FROM eda_campaign.marketing
WHERE budget IS NULL;

-- Preenchendo os valores ausentes da coluna 'budget' com a média da coluna, e segmentado pela coluna 'type_campaign'.

SELECT type_campaign, AVG(budget) as avg_budget
FROM eda_campaign.marketing
WHERE budget IS NOT NULL
GROUP BY type_campaign;

-- Agora o update:

UPDATE eda_campaign.marketing AS cm
SET budget = av.avg_budget
FROM (
    SELECT type_campaign, AVG(budget) as avg_budget
FROM eda_campaign.marketing
WHERE budget IS NOT NULL
GROUP BY type_campaign
) AS av
WHERE cm.type_campaign = av.type_campaign AND cm.budget IS NULL;


-- Valores ausentes
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