create database Walmartsales;
show tables;
desc sales;

SELECT * FROM sales;

-- -----------------CHANGE COLUMN NAMES----------------------------

ALTER TABLE sales
CHANGE `Customer type` Customer_type TEXT;

ALTER TABLE sales
CHANGE `Tax 5%` VAT DOUBLE;

ALTER TABLE sales
CHANGE `gross margin percentage` GrossMarginP DOUBLE;

ALTER TABLE sales
CHANGE `gross income` gross_income DOUBLE;

ALTER TABLE sales
CHANGE `Unit price` Unit_price DOUBLE;

ALTER TABLE sales
CHANGE cogs cogs DOUBLE AFTER Quantity;

-- ------------------------ TIME_OF_DAY --------------------------------

ALTER TABLE sales
ADD COLUMN time_of_day VARCHAR(10) DEFAULT NULL;

SET SQL_SAFE_UPDATES=0;

UPDATE sales
SET time_of_day = CASE 
                    WHEN HOUR(Time) < 12 THEN 'Morning'
                    WHEN HOUR(Time) < 18 THEN 'Afternoon'
                    ELSE 'Evening'
                 END;
SELECT * FROM sales;

-- --------------------- DAY_NAME --------------------------------------

ALTER TABLE sales
ADD COLUMN day_name VARCHAR(10) DEFAULT NULL;

UPDATE sales
SET day_name = DAYNAME(STR_TO_DATE(Date, '%m/%d/%Y'));

-- ----------------------- MONTH_NAME ----------------------------------
ALTER TABLE sales
ADD COLUMN month_name VARCHAR(10) DEFAULT NULL;

UPDATE sales
SET month_name = MONTHNAME(STR_TO_DATE(Date, '%m/%d/%Y'));

-- ----------------------------- Generic Question -----------------------------
-- 1. How many unique cities does the data have?

SELECT DISTINCT City 
FROM sales;

-- 2. In which city is each branch?

SELECT DISTINCT Branch,City
FROM sales;

-- ------------------------------- PRODUCT ----------------------------
SELECT * FROM sales;

-- 1.How many unique product lines does the data have?---------

SELECT DISTINCT Product_line AS unique_product_line
FROM sales;

-- 2.What is the most common payment method?--------

SELECT Payment,COUNT(Payment) AS frequently
FROM sales
GROUP BY Payment
ORDER BY frequently DESC
LIMIT 1;

-- 3. What is the most selling product line?

SELECT Product_line,COUNT(Product_line) AS no_of_sales
FROM sales
GROUP BY Product_line
ORDER BY no_of_sales DESC;

-- 4. What is the total revenue by month?

SELECT 
     month_name AS month,
     SUM(Total) AS revenue
FROM sales
GROUP BY month
ORDER BY revenue DESC;

-- 5. What month had the largest COGS?-----------------

SELECT 
       month_name AS month,
       SUM(cogs) AS cogs
FROM sales
GROUP BY month
ORDER BY cogs DESC
LIMIT 1;

-- 6. What product line had the largest revenue?-------------

SELECT
      Product_line,
      SUM(Total) AS highest_revenue
FROM sales
GROUP BY Product_line
ORDER BY highest_revenue DESC;

-- 7. What is the city with the largest revenue?-----------

SELECT 
      City,
      SUM(Total) AS highest_revenue
FROM sales
GROUP BY City
ORDER BY highest_revenue DESC;

-- 8.What product line had the largest VAT?----------------

SELECT 
      Product_line,
      MAX(VAT) AS VAT
FROM sales
GROUP BY Product_line
ORDER BY VAT DESC;

/*9.Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater
 than average sales*/
 ALTER TABLE sales
 ADD COLUMN Product_status VARCHAR(10) DEFAULT NULL;
 
ALTER TABLE sales
CHANGE Product_status Product_status VARCHAR(10) AFTER Product_line;

UPDATE sales
SET product_status= CASE
                       WHEN Total > 322.9 THEN 'Good'
                       ELSE 'Bad'
					END;
SELECT AVG(Total) FROM sales;
 

  -- 10. Which branch sold more products than average product sold?-------------
SELECT 
	Branch,
    SUM(Quantity) AS products_sold
FROM sales
GROUP BY Branch
HAVING SUM(Quantity) > (SELECT AVG(Quantity) FROM sales)
ORDER BY products_sold DESC;

 -- 11. What is the most common product line by gender?------
 SELECT 
       Gender,
       Product_line,
       COUNT(Gender) AS ct
FROM sales
GROUP BY Gender,Product_line
ORDER BY ct DESC;

-- 12. What is the average rating of each product line?---------

SELECT 
       Product_line,
       AVG(Rating) AS avg_rating
FROM sales
GROUP BY Product_line
ORDER BY avg_rating DESC;

/*----------------------- sales------------------------------------------*/
 -- 1. Number of sales made in each time of the day per weekday --------
SELECT 
      time_of_day,
      COUNT(*) AS total_sales
FROM sales
WHERE day_name='Monday'
GROUP BY time_of_day
ORDER BY total_sales;

--  2. Which of the customer types brings the most revenue?------------------
SELECT 
      Customer_type,
      SUM(Total) AS revenue
FROM sales
GROUP BY Customer_type
ORDER BY revenue DESC;

--  3. Which city has the largest tax percent/ VAT (Value Added Tax)?----------
SELECT 
      City,
      MAX(VAT) AS largest_tax
FROM sales
GROUP BY City
ORDER BY largest_tax DESC;

-- - 4. Which customer type pays the most in VAT?-----------
SELECT 
      Customer_type,
      MAX(VAT) AS largest_tax
FROM sales
GROUP BY Customer_type
ORDER BY largest_tax DESC;

-- ---------------CUSTOMER---------------------------------------------
-- 1. How many unique customer types does the data have?---------------------

SELECT DISTINCT Customer_type
FROM sales;

--  2. How many unique payment methods does the data have?

SELECT DISTINCT Payment
FROM sales;

-- 3. What is the most common customer type?

SELECT Customer_type,COUNT(*) AS no_of_customers
FROM sales
GROUP BY Customer_type;

-- 4. Which customer type buys the most?
SELECT 
      Customer_type,
      COUNT(*) AS no_of_customers
FROM sales
GROUP BY Customer_type;

-- 5. What is the gender of most of the customers?

SELECT Gender,COUNT(*) AS num_of_customers
FROM sales
GROUP BY Gender;

-- 6. What is the gender distribution per branch?

SELECT Branch,Gender, COUNT(*) AS count_per_gender
FROM sales
GROUP BY Branch, Gender
ORDER BY Branch;

--  7. Which time of the day do customers give most ratings?

SELECT time_of_day,COUNT(Rating) AS no_of_ratings
FROM sales
GROUP BY time_of_day
ORDER BY no_of_ratings DESC;

--  8. Which time of the day do customers give most ratings per branch?

SELECT Branch,time_of_day,COUNT(Rating) AS no_of_ratings
FROM sales
WHERE Branch='A'
GROUP BY time_of_day
ORDER BY no_of_ratings DESC;

-- 9. Which day of the week has the best avg ratings?-----------

SELECT 
	  day_name,
      AVG(Rating) AS avg_ratings
FROM sales
GROUP BY day_name
ORDER BY avg_ratings DESC;

-- 10. Which day of the week has the best average ratings per branch?-----

SELECT Branch,day_name,AVG(Rating) AS no_of_ratings
FROM sales
WHERE Branch='A'
GROUP BY day_name
ORDER BY no_of_ratings DESC;

SELECT day_name,COUNT(*) AS no_of_sales
FROM sales
GROUP BY day_name
ORDER BY no_of_sales DESC;



/*****************************************************************
== My Conclusions after looking into the results of the queries ==

-- 1.The analysis reveals that the 'Food and Beverages' category generates the highest revenue among all product lines.

-- 2.The data indicates that sales are high for fashion accessories.

-- 3.The city with the largest revenue is Naypyitaw.

-- 4.On Saturdays, sales tend to be higher.

-- 5.The most common payment method observed is eWallet.

-- 6.The total revenue for January is the highest among all months.

--7.The product line with the largest VAT is Fashion and Accessories.

--8.Branch 'A' sold more products than average product sold.
*********************************************************************/