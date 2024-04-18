-- Use the database
USE AdidasSales;

-- Check the current schema
SELECT *
FROM adidas_us_sales;
DESCRIBE adidas_us_sales;

-- Create a table to enforce schema
DROP TABLE IF EXISTS sales;

CREATE TABLE sales (
  id INT AUTO_INCREMENT PRIMARY KEY,
  retailer VARCHAR(30),
  retailer_id INT,
  region VARCHAR(20),
  state VARCHAR(20),
  city VARCHAR(30),
  product VARCHAR(50),
  unit_price DECIMAL(10, 2),
  units INT,
  invoice_date DATE,
  total_sales DECIMAL(15, 2),
  operating_profit DECIMAL(15, 2),
  operating_margin_perc DECIMAL(5, 2),
  sales_method VARCHAR(50)
);


-- Insert the original values into the new table
INSERT INTO sales (
  retailer,
  retailer_id,
  region,
  state,
  city,
  product,
  unit_price,
  units,
  invoice_date,
  total_sales,
  operating_profit,
  operating_margin_perc,
  sales_method
)
SELECT
  retailer,
  `Retailer Id` as retailer_id,
  region,
  state,
  city,
  product,
  CAST(REPLACE(REPLACE(`Price per Unit`, '$', ''), ',', '') AS DECIMAL(10, 2)) AS unit_price,
  CAST(REPLACE(`Units Sold`, ',', '') AS UNSIGNED) AS units,
  STR_TO_DATE(`Invoice Date`, '%m/%d/%Y') AS invoice_date,
  CAST(REPLACE(REPLACE(`Total Sales`, '$', ''), ',', '') AS DECIMAL(15, 2)) AS total_sales,
  CAST(REPLACE(REPLACE(`Operating Profit`, '$', ''), ',', '') AS DECIMAL(15, 2)) AS operating_profit,
  CAST(REPLACE(`Operating Margin`, '%', '') AS DECIMAL(5, 2)) AS operating_margin_perc,
  `Sales Method` as sales_method
FROM adidas_us_sales;

SELECT * 
FROM sales;

-- Date
SELECT min(invoice_date) as min_date, 
max(invoice_date) as max_date, 
count(distinct invoice_date) as distinct_dates
FROM sales;
-- This suggests that there are some dates missing

-- Then find out which dates are missing and 
-- see if it makes sense (data quality and business implication check)
WITH RECURSIVE date_range (all_date) AS (
    SELECT MIN(invoice_date) FROM sales
    UNION ALL
    SELECT all_date + INTERVAL 1 DAY 
    FROM date_range 
    WHERE all_date + INTERVAL 1 DAY <= (SELECT MAX(invoice_date) FROM sales)
)
SELECT date_range.all_date
FROM date_range
LEFT JOIN sales ON date_range.all_date = sales.invoice_date
WHERE sales.invoice_date IS NULL
ORDER BY date_range.all_date;
-- 2020-02-29, 2020-10-11 ~ 2020-10-16 (May need business judgements)

-- From a brief view, there is data quality issue
SELECT COUNT(*), SUM(CASE WHEN total_sales <> unit_price * units THEN 1 ELSE 0 END) AS Mismatch_Count
FROM sales;

-- The unit price multiply by units is not equal to the total sales
-- In this dataset, we want to update the profit margins and operating profit
SET SQL_SAFE_UPDATES = 0;

UPDATE sales
SET total_sales = unit_price * units,
operating_profit = total_sales * (operating_margin_perc / 100)
WHERE total_sales <> unit_price * units;

SET SQL_SAFE_UPDATES = 1;

SELECT * 
FROM sales;

-- Check if each region only contains one state and city
SELECT region,
COUNT(DISTINCT CONCAT(state, '-', city)) AS num_state_city_combos,
COUNT(DISTINCT state) as num_state, 
COUNT(DISTINCT city) as num_city
FROM sales
GROUP BY region;
-- Northeast, South, Southeast, and West had one state corresponding to 2 cities
