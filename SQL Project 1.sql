--Dataset is imported and a new table is created

CREATE TABLE investment_subset
(market varchar,
funding_total_usd bigint,
status varchar,
country_code varchar,
founded_year int,
seed numeric,
venture numeric,
equity_crowdfunding numeric,
undisclosed numeric,
convertible_note numeric,
debt_fincing numeric,
private_equity numeric);

--Table is updated for data cleaning

UPDATE investment_subset
SET market='Financial Services'
WHERE market='FincialServices'

ALTER TABLE investment_subset
RENAME COLUMN debt_fincing TO debt_financing

--Get the count,average,minimum,and maximum values of seed funding under Financial Services market

SELECT COUNT(seed), 
AVG(seed), 
MIN(seed), 
MAX(seed)
FROM investment_subset
WHERE market='Financial Services'
GROUP BY market

--Determine if there has been an instance where a company under Financial Services market received equity crowdfunding.
--Provide the details of these companies including country,year,status,and amount of equity crowdfunding acquired

SELECT market,country_code,founded_year,status,equity_crowdfunding 
FROM investment_subset
WHERE market='Financial Services' AND NOT equity_crowdfunding=0

--Determine significant outliers in total funding on companies under Financial Services (1)

SELECT market,funding_total_usd 
FROM investment_subset
WHERE market='Financial Services' AND funding_total_usd IS NOT NULL	
ORDER BY funding_total_usd DESC

--Details of outlier(2)

SELECT 
market,
country_code,
status,
founded_year,
funding_total_usd
FROM investment_subset
WHERE market='Financial Services'
AND funding_total_usd = (SELECT MAX(funding_total_usd) from investment_subset WHERE market='Financial Services')

--Exclude the outlier and provide full details of the Financial Services market on their sources of funds

SELECT 
	inv.market,
	inv.funding_total_usd,
	inv.equity_crowdfunding,
	inv.undisclosed,
	inv.convertible_note,
	inv.debt_financing,
	inv.private_equity
FROM 
	investment_subset inv,
    (SELECT MAX(funding_total_usd) mx FROM investment_subset WHERE market='Financial Services' AND funding_total_usd IS NOT NULL) inv2
WHERE 
	inv.market='Financial Services' 
	AND inv.funding_total_usd IS NOT NULL
    AND inv.funding_total_usd != mx
ORDER BY 
	inv.funding_total_usd DESC;

--The final output was exported from SQL to MS Excel