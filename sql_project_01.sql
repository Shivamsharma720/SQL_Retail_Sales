DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales(
	transactions_id INT PRIMARY KEY,
	sale_date DATE ,
	sale_time TIME,
	customer_id INT,
	gender VARCHAR(15),
	age  INT,
	category VARCHAR(15),
	quantiy INT,
	price_per_unit FLOAT,
	cogs FLOAT,
	total_sale	FLOAT
);	

SELECT * FROM retail_sales
LIMIT 10;

SELECT COUNT(*) FROM retail_sales;

--DATA CLEANING
SELECT * FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR 
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR 
	gender IS NULL
	OR 
	category IS NULL
	OR 
	quantiy IS NULL
	OR 
	price_per_unit IS NULL
	OR 
	cogs IS NULL
	OR 
	total_sale IS NULL;

--
DELETE FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR 
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR 
	gender IS NULL
	OR 
	category IS NULL
	OR 
	quantiy IS NULL
	OR 
	price_per_unit IS NULL
	OR 
	cogs IS NULL
	OR 
	total_sale IS NULL;

-- DATA EXPLORATION
--HOW MANY SALES WE HAVE?

SELECT COUNT(*) AS total_sales FROM retail_sales;

--HOW MANY UNIQUE CUSTOMER WE HAVE?
SELECT COUNT(DISTINCT(customer_id)) AS total_customer FROM retail_sales;

--WHAT TYPE OF UNIQUE CATEGORY WE HAVE?
SELECT DISTINCT(category) AS unique_category FROM retail_sales;

--DATA ANALYSIS  & BUSINESS KEY PROBLEMS & ANSWERS

--MY ANALYSIS & FINDINGS

--SALES MADE ON '2022-11-05'
SELECT * FROM retail_sales
WHERE sale_date='2022_11_05';

--transactions for clothing & quantity sold is more than 10 in month of nov-2022
SELECT category,SUM(quantiy) FROM retail_sales
WHERE category='Clothing' AND TO_CHAR(sale_date,'YYYY-MM')='2022-11'
GROUP BY category
HAVING SUM(quantiy)>10;

--total-sales for each category
SELECT category,SUM(total_sale) AS sale_by_category
FROM retail_sales
GROUP BY category;

--avg age of customer who has purchased item from the'beauty' category
SELECT ROUND(AVG(age),2) AS average_age FROM retail_sales
WHERE category='Beauty';

--Transaction where total_sale is greater than 1000
SELECT * FROM retail_sales
WHERE total_sale>1000;

--total number of transactions made by each gender in each category
SELECT gender,category ,count(transactions_id) AS transaction
FROM retail_sales
GROUP BY gender,category
ORDER BY count(transactions_id);

--average sale for each month,find out best selling month in each year
SELECT year,month,Avg_sales FROM
(
SELECT EXTRACT(YEAR FROM sale_date) AS year,
EXTRACT(MONTH FROM sale_date) AS month,
ROUND(AVG(total_sale)) AS Avg_sales,
RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date)ORDER BY AVG(total_sale) DESC) AS rank
FROM retail_sales
GROUP BY 1,2
)AS t1
WHERE rank=1;

--top 5 customer based on highest total_sales
SELECT customer_id,SUM(total_sale) AS sales
FROM retail_sales
GROUP BY customer_id
ORDER BY SUM(total_sale) DESC
LIMIT 5;

--unique customer who have purchased items from each category
SELECT category,COUNT(DISTINCT(customer_id))AS unique_customer
FROM retail_sales
GROUP BY category;

--SQL query for each shift and number of orders
WITH hourly_sale
AS
(
SELECT *,
    CASE 
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS shift
FROM retail_sales
)
SELECT COUNT(*),shift as total_orders
FROM hourly_sale

--END
GROUP BY shift
