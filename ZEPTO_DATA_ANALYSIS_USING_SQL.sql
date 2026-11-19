drop table if exists zepto;
create table zepto(
sku_id SERIAL PRIMARY KEY,
category VARCHAR(120),
name VARCHAR(150) NOT NULL,
mrp NUMERIC(8,2),
discountPercent NUMERIC(5,2),
availableQuantity INTEGER,
discountedSellingPrice NUMERIC(8,2),
weightedInGms INTEGER,
outOfStock BOOLEAN,
quantity INTEGER
);

--data exploration 
--count of row

SELECT COUNT (*)FROM zepto;

--sample data

SELECT * FROM zepto 
LIMIT 10;

--NULL VALUES
SELECT * FROM zepto
WHERE name IS NULL
OR
category IS NULL
OR
mrp IS NULL
OR
discountPercent IS NULL
OR
discountedSellingPrice IS NULL 
OR 
availableQuantity IS NULL 
OR
outOfStock IS NULL
OR
quantity IS NULL;

--Differnt product category

SELECT DISTINCT category
FROM zepto
ORDER BY category;

-- products in stock or outofstock
SELECT outOfStock, COUNT(sku_id)
FROM zepto 
GROUP BY outOfStock;

--product name present multiple times
SELECT name, COUNT(sku_id) as "number of SKUs"
FROM zepto
GROUP BY name
HAVING count(sku_id)>1
ORDER BY count(sku_id) DESC;

--DATA CLEANING 

-- product with price = 0
SELECT * FROM zepto
WHERE mrp = 0 OR discountedSellingPrice =0;

DELETE FROM zepto
WHERE mrp = 0;

--convert paise to rupees

UPDATE zepto 
SET mrp =mrp/100.0,
discountedSellingPrice = discountedSellingPrice / 100.0;

SELECT mrp, discountedSellingPrice FROM zepto

--find the top 10 best value product based on the discoun percentage
-- what are the product with high mrp but out of stock 
-- calculated  estimated revenue for each category
-- find all product where mrp is greater than 500 and discount is les than 10%
--identify the top 5 catgory offring the highest average discount percentage
--find the price per gram for product above 100g and sort by best value
--1
SELECT DISTINCT name, mrp , discountPercent
FROM zepto
ORDER BY discountPercent DESC
LIMIT 10;
--2
SELECT DISTINCT name,mrp
FROM zepto
WHERE outOfStock = TRUE and mrp >300
ORDER BY mrp DESC;

--3
SELECT category,
SUM(discountedSellingPrice * availableQuantity) AS total_revenue
FROM zepto
GROUP BY category
ORDER BY total_revenue;

--4
SELECT DISTINCT name ,mrp, discountPercent
FROM zepto
WHERE mrp>500 AND discountPercent<10
ORDER BY mrp DESC ,discountPercent DESC ;

--5
SELECT category,
ROUND(AVG(discountPercent),2) AS avg_discount
FROM zepto
GROUP BY category
ORDER BY avg_discount DESC 
LIMIT 5;

--6
SELECT  DISTINCT name ,weightedInGms,discountedSellingPrice,
ROUND(discountedSellingPrice/weightedInGms,2) AS price_per_gram
FROM zepto
WHERE weightedInGms >=100
ORDER BY price_per_gram;

--7Group the product into category like low ,medium ,bulk .

SELECT DISTINCT name ,weightedInGms,
CASE WHEN weightedInGms < 1000 THEN 'low'
     WHEN weightedInGms <5000 THEN 'medium'
	 ELSE 'bulk'
	 END AS weight_category
FROM zepto;

--8 wthat is the total inventory weight per category

SELECT  category,
SUM(weightedInGms* availableQuantity) AS total_weight
FROM zepto 
GROUP BY category
ORDER BY total_weight;

