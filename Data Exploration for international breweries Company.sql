# Data Exploration for Internatinal Breweries Company Using My SQL

#Skill used: Aggregate Function, Advanced filtering using operators, using wildcards

-- PROFIT ANALYSIS--
USE international_breweries;
SELECT * FROM breweries;
#1. Query that returns the Total Profit
SELECT 
    SUM(profit) AS TOTAL_GRAND_PROFIT
FROM
    breweries;

#2a. Query that returns the Total Profit when territories is Anglophone 
SELECT 
    SUM(profit) AS TOTAL_GRAND_PROFIT
FROM
    breweries
WHERE
    territories = 'ANGLOPHONE';

#2b. Query that returns the Total Profit when territories is Anglophone
SELECT 
    SUM(profit) AS TOTAL_GRAND_PROFIT
FROM
    breweries
WHERE
    territories = 'FRANCOPHONE';

#3 Query that returns the Country that generated Highest Profit in 2019
SELECT 
    country, SUM(profit) AS TOTAL_GRAND_PROFIT
FROM
    breweries
 WHERE years = 2019   
GROUP BY country
ORDER BY SUM(profit) DESC
LIMIT 1;

#4. Query that returns the Year with the highest Profit
SELECT 
    years, SUM(profit) AS TOTAL_GRAND_PROFIT
FROM
    breweries
GROUP BY years
ORDER BY SUM(profit) DESC
LIMIT 1;

#5. Query that returns the Month within the 3 years where the least Profit was generated
SELECT months, years, profit AS TotalGrandProfit
FROM
    breweries
GROUP BY months, years
ORDER BY TotalGrandProfit asc
LIMIT 1;

#6. Query that returns the minimum Profit in the month of December 2019
SELECT 
    months, years, profit
FROM
    breweries
WHERE
    years = 2018 AND months = 'December'
ORDER BY profit ASC
LIMIT 1;


#7. Query returns the particular brand generated the Highest Profit in Senegal
SELECT 
    brands, SUM(profit) AS TOTAL_GRAND_PROFIT
FROM
    breweries
WHERE
    country = 'SENEGAL'
GROUP BY brands
ORDER BY SUM(profit) DESC
LIMIT 1; 

-- BRAND ANALYSIS --

#1a. Query that returns  Top 3 Brands consumed in the Francophone countries in the last Two years
SELECT 
    years, territories, brands, SUM(quantity) AS TotalQuantity
FROM
    breweries
WHERE
    territories = 'Francophone'
        AND NOT years = 2017
GROUP BY years , brands
ORDER BY TotalQuantity DESC
LIMIT 3;

 #1b. Query that returns  Top 3 Brands consumed in the Anglophone countries in the last Two years.

 SELECT 
    years, territories, brands, SUM(quantity) AS TotalQuantity
FROM
    breweries
WHERE
    territories = 'Anglophone'
        AND NOT years = 2017
GROUP BY years , brands
ORDER BY TotalQuantity DESC
LIMIT 3;
 
 #2. Query that returns the Top 2 choice of consumer Brands in Ghana
 SELECT 
    brands, SUM(quantity)
FROM
    breweries
WHERE
    country = 'GHANA'
GROUP BY BRANDS
ORDER BY SUM(quantity) DESC
LIMIT 2;

#3. Query that returns the Favourite malt brand in Anglophone region between 2018 and 2019 
SELECT 
    brands, territories, years, SUM(quantity) AS TotalQuantity
FROM
    breweries
WHERE
    territories = 'Anglophone'
        AND NOT years = 2017
        AND (brands LIKE '%malt%')
GROUP BY brands , years
ORDER BY TotalQuantity DESC
LIMIT 1;

#4. Query that returns the Highest Brand consumed in Nigeria in 2019
 SELECT 
    years, brands, SUM(quantity)
FROM
    breweries
WHERE
    country = 'nigeria' AND years = 2019
GROUP BY brands
ORDER BY SUM(quantity) DESC
LIMIT 1;

#5. Query that returns the Favorite Brand consumed in South-South region in Nigeria
SELECT 
   region, brands, SUM(quantity) AS total_quantity
FROM
    breweries
WHERE
    country = 'nigeria'
        AND region = 'southsouth'
GROUP BY brands
ORDER BY SUM(quantity) DESC
LIMIT 1;

#6. Query that returns the Total quantity of Beer consumption in Nigeria

select country, sum(quantity) AS TotalQuantity 
FROM breweries
where country = 'Nigeria' AND brands NOT LIKE  '%malt%'
;

#7. Query that returns the Level of Budweiser Regional consumption in Nigeria  
SELECT 
    region, SUM(quantity) AS total_quantity
FROM
    breweries
WHERE
    brands = 'budweiser'
        AND country = 'nigeria'
GROUP BY region
ORDER BY SUM(quantity) DESC;

#8. Query that returns the Level of Budweiser regional consumption in Nigeria in 2019 
SELECT 
    region, SUM(quantity)
FROM
    breweries
WHERE
    brands = 'budweiser'
        AND country = 'nigeria'
        AND years = 2019
GROUP BY region
ORDER BY SUM(quantity) DESC;

-- COUNTRIES ANALYSIS --

#1. Query that returns the country with the highest consumption of beer
SELECT country, sum(quantity) AS TotalQuantity
FROM breweries
WHERE brands NOT LIKE  '%malt%'
GROUP BY country
ORDER BY TotalQuantity desc;


#2. Query that returns the Highest Sales personnel of Budweiser in Senegal.
SELECT 
    sales_id, SUM(quantity)
FROM
    breweries
WHERE
    brands = 'budweiser'
        AND country = 'senegal'
GROUP BY sales_id
ORDER BY  SUM(quantity) DESC
LIMIT 1;

#3. Query that returns the country with the highest profit of the fourth quarter in 2019

SELECT 
    country, SUM(profit)
FROM
    breweries
WHERE
    years = 2019 AND quarters = 'Q4'
GROUP BY country
ORDER BY SUM(profit) DESC;
#LIMIT 1;