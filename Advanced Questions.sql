-- Advanced Level --
-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.


WITH revenue_data AS (
    SELECT
        i.item_cat,
        r.pizza_name,
        SUM(i.item_price * o.quantity) AS revenue,
        ROW_NUMBER() OVER(PARTITION BY i.item_cat ORDER BY SUM(i.item_price * o.quantity) DESC) AS rn
    FROM item_data1 i
    JOIN orders_data1 o ON i.item_id = o.item_id
    JOIN recipe_data1 r ON r.pizza_name = i.pizza_name
    WHERE i.item_cat = 'pizza'
    GROUP BY i.item_cat, r.pizza_name
)
SELECT
    item_cat,
    pizza_name,
    total_revenue
FROM (
    SELECT
        item_cat,
        pizza_name,
        SUM(revenue) AS total_revenue,
        ROW_NUMBER() OVER(PARTITION BY item_cat ORDER BY SUM(revenue) DESC) AS category_rn
    FROM revenue_data
    GROUP BY item_cat, pizza_name
) ranked_data
WHERE category_rn <= 3
ORDER BY item_cat, total_revenue DESC;

-- Analyze the cumulative revenue generated over time. --


SELECT 
    DATE(o.created_at) AS order_date,
    ROUND(SUM(i.item_price * o.quantity), 2) AS cumulative_revenue
FROM
    orders_data1 o
        JOIN
    item_data1 i ON o.item_id = i.item_id
GROUP BY DATE(o.created_at)
ORDER BY DATE(o.created_at);

-- Calculate the percentage contribution of each pizza type to total revenue.

WITH revenue_data AS (
    SELECT
        r.pizza_name,
        SUM(i.item_price * o.quantity) AS revenue
    FROM item_data1 i
    JOIN orders_data1 o ON i.item_id = o.item_id
    JOIN recipe_data1 r ON r.pizza_name = i.pizza_name
    WHERE i.item_cat = 'pizza'
    GROUP BY r.pizza_name
)
SELECT
    pizza_name,
    revenue,
    ROUND((revenue / (SELECT SUM(revenue) FROM revenue_data) * 100), 2) AS contribution_percentage
FROM revenue_data
ORDER BY contribution_percentage DESC;