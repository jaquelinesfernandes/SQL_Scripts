SELECT * FROM eda_campaign.marketing;

-- Total Valores Ausentes em todas a colunas

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


-- Caracteres especiais ('?') todas a colunas

SELECT *
FROM eda_campaign.marketing
WHERE 
    name_campaign LIKE '%?%' OR
    CAST(data_start AS VARCHAR) LIKE '%?%' OR
    CAST(data_end AS VARCHAR) LIKE '%?%' OR
    CAST(budget AS VARCHAR) LIKE '%?%' OR
    target LIKE '%?%' OR
    channels LIKE '%?%' OR
    type_campaign LIKE '%?%' OR
    CAST(conversion_rate AS VARCHAR) LIKE '%?%' OR
    CAST(impressions AS VARCHAR) LIKE '%?%';

-- Duplicatas
SELECT 
	name_campaign,
    data_start,
    data_end,
    budget,
    target,
    channels, 
    type_campaign, 
    conversion_rate,
    impressions,
    COUNT(*) as duplicates
FROM 
    eda_campaign.marketing
GROUP BY
    name_campaign,
    data_start,
    data_end,
    budget,
    target,
    channels, 
    type_campaign, 
    conversion_rate,
    impressions
HAVING 
    COUNT(*) > 1;


-- Duplicatas com todas as colunas, mas verificando somente duplicatas em algumas colunas
SELECT *
FROM eda_campaign.marketing
WHERE 
    (name_campaign, data_start, target, channels) IN (
        SELECT 
            name_campaign, 
            data_start, 
            target, 
            channels
        FROM 
            eda_campaign.marketing
        GROUP BY 
            name_campaign, 
            data_start, 
            target, 
            channels
        HAVING 
            COUNT(*) > 1
    );

-- Outliers valores numericos segundo regra padrão: media + 1.5 * desvio_padrão e media - 1.5 * desvio_padrão


WITH stats AS (
    SELECT
        AVG(budget) AS avg_budget,
        STDDEV(budget) AS stddev_budget,
        AVG(conversion_rate) AS avg_conversion_rate,
        STDDEV(conversion_rate) AS stddev_conversion_rate,
        AVG(impressions) AS avg_impressions,
        STDDEV(impressions) AS stddev_impressions
    FROM
        eda_campaign.marketing
)
SELECT
	id,
	name_campaign,
	data_start,
	data_end,
	budget,
	target,
	channels,
	conversion_rate,
	impressions
FROM
	eda_campaign.marketing,
	stats
WHERE
	budget < (avg_budget - 1.5 * stddev_budget) OR 
	budget > (avg_budget + 1.5 * stddev_budget) OR
	conversion_rate < (avg_conversion_rate - 1.5 * stddev_conversion_rate) OR 
	conversion_rate > (avg_conversion_rate + 1.5 * stddev_conversion_rate) OR
	impressions < (avg_impressions - 1.5 * stddev_impressions) OR 
	impressions > (avg_impressions + 1.5 * stddev_impressions);    


--Comments