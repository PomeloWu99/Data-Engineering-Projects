USE AdidasSales;

-- In this section, I try to answer some business questions.

-- 1. What are the sales difference between 2020 and 2021? In percentage?
SELECT 
YEAR(invoice_date) AS sales_year, 
SUM(total_sales) AS total_sales,
(LEAD(SUM(total_sales)) OVER (ORDER BY YEAR(invoice_date)) - SUM(total_sales)) AS sales_difference,
(LEAD(SUM(total_sales)) OVER (ORDER BY YEAR(invoice_date)) - SUM(total_sales))/SUM(total_sales)*100.0 AS percent_change
FROM sales
GROUP BY YEAR(invoice_date);
-- We can observe overall the sales increased 295% from 2020 to 2021.

-- 2. Is the sales growth differ across quarter?

-- Here I use cte just to make the code more readable
-- For simplicity purpose, we can replicate the code from 1
WITH year_quarter_sales AS
(SELECT Year(invoice_date) as sales_year, 
Quarter(invoice_date) as sales_quarter,
SUM(total_sales) as total_sales
FROM sales
GROUP BY Year(invoice_date), Quarter(invoice_date)
ORDER BY Year(invoice_date), Quarter(invoice_date)
)
SELECT 
sales_year,
sales_quarter,
total_sales AS sales_this_quarter,
LEAD(total_sales) OVER (ORDER BY sales_year, sales_quarter) AS sales_nxt_quarter,
(LEAD(total_sales) OVER (ORDER BY sales_year, sales_quarter) - total_sales)/ total_sales * 100 AS sales_growth_percentage
FROM year_quarter_sales;
-- This output is interesting. We can see significant increase from 2020 4th quarter to 2021 1st quarter.
-- Generally the 3rd to 4th quarter generate fewer sales.


-- 3. How do sales trends differ between regions?
-- Here we can compare the percent changes in sales within a region
SELECT region, YEAR(invoice_date) as sales_year, 
-- SUM(total_sales) - LAG(SUM(total_sales)) OVER(PARTITION BY region ORDER BY YEAR(invoice_date)) as sales_diff,
(SUM(total_sales) - LAG(SUM(total_sales)) OVER(PARTITION BY region ORDER BY YEAR(invoice_date)))/
LAG(SUM(total_sales)) OVER(PARTITION BY region ORDER BY YEAR(invoice_date))*100.0 as percent_change
FROM sales
GROUP BY 1, 2
ORDER BY percent_change DESC;

-- We can also check the change in the proportion of regional sales in the total sales
With sales_2020 AS (
SELECT 
region, SUM(total_sales) as sales_20,
SUM(total_sales)/(SELECT SUM(total_sales) FROM sales WHERE Year(invoice_date) = 2020)*100.0 as sales_prop
FROM sales
WHERE Year(invoice_date) = 2020
GROUP BY region
), sales_2021 AS (
SELECT 
region, SUM(total_sales) as sales_21,
SUM(total_sales)/(SELECT SUM(total_sales) FROM sales WHERE Year(invoice_date) = 2021)*100.0 as sales_prop
FROM sales
WHERE Year(invoice_date) = 2021
GROUP BY region
)
SELECT s0.region, 
s1.sales_prop - s0.sales_prop as growth_rate,
s0.sales_20, s0.sales_prop, s1.sales_21, s1.sales_prop
FROM sales_2020 s0
LEFT JOIN sales_2021 s1
ON s0.region = s1.region
ORDER BY growth_rate desc;

-- 4. Which products are most subjective to seasonal effects?
-- We can approach this by calculating normalized standard deviation
WITH monthly_sales AS ( 
SELECT product,
YEAR(invoice_date) AS sale_year,
MONTH(invoice_date) AS sale_month,
SUM(total_sales) AS monthly_total_sales
FROM sales
GROUP BY 1,2,3
), monthly_variation AS(
SELECT product,
STDDEV(monthly_total_sales)/AVG(monthly_total_sales) AS variation,
STDDEV(monthly_total_sales) AS sales_std_dev,
AVG(monthly_total_sales) AS average_monthly_sales
FROM monthly_sales
GROUP BY product
)
SELECT *
FROM monthly_variation
ORDER BY variation DESC;

-- Another follow-up question will be, each product sells the best at which month?
WITH monthly_sales AS ( 
SELECT product,
MONTH(invoice_date) AS sale_month,
SUM(total_sales) AS monthly_total_sales
FROM sales
GROUP BY 1,2
), ranked_months AS (
SELECT product,
sale_month,
monthly_total_sales,
RANK() OVER (PARTITION BY product ORDER BY monthly_total_sales DESC) AS month_rank
FROM monthly_sales
)
SELECT product,
sale_month,
monthly_total_sales
FROM ranked_months
WHERE month_rank = 1
ORDER BY product, sale_month;


-- 5. Which retailers are improving their sales performance? 
SELECT retailer, YEAR(invoice_date) as sales_year, 
-- SUM(total_sales) - LAG(SUM(total_sales)) OVER(PARTITION BY retailer ORDER BY YEAR(invoice_date)) as sales_diff,
(SUM(total_sales) - LAG(SUM(total_sales)) OVER(PARTITION BY retailer ORDER BY YEAR(invoice_date)))/
LAG(SUM(total_sales)) OVER(PARTITION BY retailer ORDER BY YEAR(invoice_date))*100.0 as percent_change
FROM sales
GROUP BY retailer, YEAR(invoice_date)
ORDER BY percent_change DESC
LIMIT 3; 


-- ######################################
-- Conclusions:
-- Significant sales growth from 2020 to 2021, at around 295.79%
-- The second and fourth quarter of a year seem to perform relatively worse than others.
-- Midwest has the most significant sales increase, 1.64x increase.
-- Midwest also increased its proportion in total sales whereas Northeast and West lost their portions.
-- All products are relatively similar to seasonal effects as seen in similar coefficient of variation.
-- Shoes are sold the best in July and August.
-- Khol's, Sports Direct, and Foot locker are the top three most increased retailers.
-- ######################################
-- Recommendations
-- Promotions in July and August, putting more efforts on Midwest
-- Expanding channels to Khol's, Sports Direct, and Foot locker


