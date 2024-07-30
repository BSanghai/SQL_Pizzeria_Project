-- BASIC LEVEL--
-- 1. Customer Analysis --
-- What is the total number of customers? --

select * from customers_data1;
SELECT 
    COUNT(cust_id) AS Total_customers
FROM
    customers_data1;

-- How many orders have been placed in the last month?--

Select * from orders_data1;
SELECT 
    created_at,
    DATE(created_at) AS order_date,
    TIME(created_at) AS order_date
FROM
    orders_data1;

ALTER TABLE orders_data
ADD order_date DATE,
ADD order_time TIME;

UPDATE orders_data 
SET 
    order_date = DATE(created_at),
    order_time = TIME(created_at);

SELECT 
    *
FROM
    orders_data1;

Alter table orders_data1
Drop column created_at;

SELECT 
    COUNT(quantity) AS Total_orders
FROM
    orders_data1
WHERE
    created_at<= DATE_SUB(CURDATE(), INTERVAL 1 MONTH);

SELECT 
    COUNT(quantity) AS Total_orders
FROM
    orders_data1;

-- What is the average order value? --

SELECT 
    *
FROM
    orders_data1;

SELECT 
    AVG(quantity) AS avg_order_value
FROM
    orders_data1;

DROP table inventory_data;
 
-- 2. Inventory Management: --
-- Which ingredients are running low on stock? --

SELECT 
    inventory_data1.Ingr_id,
    ingredients_data1.Ingr_id,
    ing_name,
    quantity
FROM
    inventory_data1,
    ingredients_data1
WHERE
    inventory_data1.Ingr_id = ingredients_data1.Ingr_id;

SELECT 
    ing_name, quantity, COUNT(*) AS Low_stock
FROM
    ingredients_data1,
    inventory_data1
GROUP BY ing_name , quantity
HAVING COUNT(*) <= 1;

-- What is the average order value of price? --

SELECT 
    AVG(item_price) AS avg_order_value
FROM
    item_data1;

 -- What is the total value of the inventory?--

SELECT 
    SUM(quantity) AS Total_inventory_quan
FROM
    inventory_data1;

SELECT 
    SUM(ing_price) AS Total_inventory_value
FROM
    ingredients_data1;

SELECT 
    ROUND(SUM(inventory_data1.quantity * ingredients_data1.ing_price),
            2) AS Total_invent_value
FROM
    inventory_data1
        JOIN
    ingredients_data1 ON inventory_data1.Ingr_id = ingredients_data1.Ingr_id;

 -- 3.Sales Analysis:--
 -- Which is the best-selling pizza?--
 
SELECT 
    item_name, row_id, SUM(quantity) AS total_sold
FROM
    item_data1,
    recipe_data1
GROUP BY item_name , row_id
ORDER BY total_sold DESC
LIMIT 1;

 -- What is the total revenue generated in the last quarter? --

SELECT 
    YEAR(created_at_datetime) AS sales_year,
    QUARTER(created_at_datetime) AS sales_quarter,
    SUM(quantity) AS total_revenue
FROM
    orders_data1
WHERE
    created_at_datetime <= DATE_ADD(DATE_SUB(NOW(), INTERVAL 4 QUARTER),
        INTERVAL 4 QUARTER)
GROUP BY sales_year , sales_quarter;


ALTER TABLE orders_data1
ADD COLUMN created_at_datetime DATETIME;

UPDATE orders_data1
SET created_at_datetime = STR_TO_DATE(created_at, '%d-%m-%Y %H:%i');



