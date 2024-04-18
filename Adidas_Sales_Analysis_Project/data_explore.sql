USE AdidasSales;

SELECT * 
FROM sales;

-- Explore and understand different attributes separately

-- ##########
-- Which specific group generate the most profits? the most profit per transaction?
-- ##########


-- ### Retailer
SELECT retailer, 
SUM(total_sales) as total_sales,
AVG(total_sales) as avg_sales, 
COUNT(retailer)/(SELECT count(id) FROM sales)*100.0 as prop_volumes,
SUM(total_sales)/(SELECT sum(total_sales) FROM sales)*100.0 as prop_sales
FROM sales
GROUP BY retailer
ORDER BY avg_sales DESC, prop_sales DESC, total_sales DESC, prop_volumes DESC;


-- ### Region
SELECT region,
SUM(total_sales) as total_sales,
AVG(total_sales) as avg_sales, 
COUNT(region)/(SELECT count(id) FROM sales)*100.0 as prop_volumes,
SUM(total_sales)/(SELECT sum(total_sales) FROM sales)*100.0 as prop_sales
FROM sales
GROUP BY region
ORDER BY avg_sales DESC, prop_sales DESC, total_sales DESC, prop_volumes DESC;


-- ## Products
SELECT product,
SUM(total_sales) as total_sales,
AVG(total_sales) as avg_sales, 
COUNT(product)/(SELECT count(id) FROM sales)*100.0 as prop_volumes,
SUM(total_sales)/(SELECT sum(total_sales) FROM sales)*100.0 as prop_sales
FROM sales
GROUP BY product
ORDER BY avg_sales DESC, prop_sales DESC, total_sales DESC, prop_volumes DESC;

-- ## Date
SELECT Quarter(invoice_date) as season,
SUM(total_sales) as total_sales,
AVG(total_sales) as avg_sales
FROM sales
GROUP BY Quarter(invoice_date);
-- Observe some seasonality patterns, but ignored the year

-- Examine year and quarter trends 
SELECT Year(invoice_date), Quarter(invoice_date),
SUM(total_sales) as total_sales,
AVG(total_sales) as avg_sales
FROM sales
GROUP BY Year(invoice_date), Quarter(invoice_date);

