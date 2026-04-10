--Synapse SQL
SELECT *
FROM OPENROWSET(
    BULK 'https://<storage_account>.dfs.core.windows.net/divanshsigmoid/gold/sales_summary/',
    FORMAT = 'DELTA'
) AS rows;

--Create View
CREATE VIEW sales_summary AS
SELECT *
FROM OPENROWSET(
    BULK 'https://<storage_account>.dfs.core.windows.net/divanshsigmoid/gold/sales_summary/',
    FORMAT = 'DELTA'
) AS rows;

--KPI Queries
-- 1.Total Sales
SELECT SUM(total_sales) AS total_sales
FROM OPENROWSET(
    BULK 'https://<storage_account>.dfs.core.windows.net/divanshsigmoid/gold/final_sales/',
    FORMAT = 'DELTA'
) AS rows;

-- 2.Sales by Product
SELECT product, SUM(total_sales) AS total_sales
FROM OPENROWSET(
    BULK 'https://<storage_account>.dfs.core.windows.net/divanshsigmoid/gold/final_sales/',
    FORMAT = 'DELTA'
) AS rows
GROUP BY product;

-- 3.Sales by City
SELECT city, SUM(total_sales) AS total_sales
FROM OPENROWSET(
    BULK 'https://<storage_account>.dfs.core.windows.net/divanshsigmoid/gold/final_sales/',
    FORMAT = 'DELTA'
) AS rows
GROUP BY city;

-- 4.Top Performing Product
SELECT TOP 1 product, SUM(total_sales) AS total_sales
FROM OPENROWSET(
    BULK 'https://<storage_account>.dfs.core.windows.net/divanshsigmoid/gold/final_sales/',
    FORMAT = 'DELTA'
) AS rows
GROUP BY product
ORDER BY total_sales DESC;

-- 5.City-wise Ranking
SELECT city, SUM(total_sales) AS total_sales
FROM OPENROWSET(
    BULK 'https://<storage_account>.dfs.core.windows.net/divanshsigmoid/gold/final_sales/',
    FORMAT = 'DELTA'
) AS rows
GROUP BY city
ORDER BY total_sales DESC;
