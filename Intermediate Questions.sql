-- 1.Customer Segmentation: --
-- Identify high-value customers based on order frequency or total spending. - 

SELECT 
    cust_firstname,
    cust_lastname,
    cust_id,
    COUNT(order_id) AS order_count
FROM
    customers_data,
    orders_data
GROUP BY cust_firstname , cust_lastname , cust_id
ORDER BY order_count DESC; -- For order Frequency --

SELECT 
    item_data1.item_id,
    customers_data1.cust_firstname,
    customers_data1.cust_lastname,
    item_data1.item_price
FROM
    item_data1
        JOIN
    orders_data
        JOIN
    customers_data1 ON orders_data.item_id = item_data1.item_id = customers_data1.cust_id
ORDER BY item_data1.item_price DESC
LIMIT 1; -- For total spending --

 -- 2.Staff Performance:
--  Calculate average hours worked per employee.

SELECT staff_shift_id, TIMEDIFF(end_time, start_time) AS hours_worked
FROM shift_data;

WITH shift_hours AS (
  SELECT staff_shift_id, TIMEDIFF(end_time, start_time) AS hours_worked
  FROM shift_data
)
SELECT staff_shift_id, AVG(TIMEDIFF(end_time, start_time)) AS avg_hours_worked
FROM rota_data1 r
INNER JOIN shift_data ON r.shift_id = staff_shift_id
GROUP BY staff_shift_id
ORDER BY round(SEC_TO_TIME(avg_hours_worked),2) desc limit 3;


-- Menu Optimization --
-- Identify underperforming menu items.--

SELECT 
    i.item_name, COUNT(o.item_id) AS Total_orders
FROM
    orders_data1 o
        JOIN
    item_data1 i ON i.item_id = o.item_id
GROUP BY i.item_name
ORDER BY Total_orders ASC
LIMIT 3;









