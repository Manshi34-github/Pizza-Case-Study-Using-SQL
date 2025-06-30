-- Step 1: Create the database
CREATE DATABASE pizza_project;

-- Step 2: Use the database
USE pizza_project;

-- Step 3: Explore the tables
SELECT * FROM order_details;     -- order_details_id, order_id, pizza_id, quantity
SELECT * FROM pizzas;            -- pizza_id, pizza_type_id, size, price
SELECT * FROM orders;            -- order_id, date, time
SELECT * FROM pizza_types;       -- pizza_type_id, name, category, ingredients

-- BASIC ANALYSIS

-- Total number of orders placed
SELECT COUNT(DISTINCT order_id) AS 'Total Orders' FROM orders;

-- Total revenue generated from pizza sales
SELECT CAST(SUM(od.quantity * p.price) AS DECIMAL(10,2)) AS 'Total Revenue'
FROM order_details od
JOIN pizzas p ON p.pizza_id = od.pizza_id;

-- Highest-priced pizza
SELECT TOP 1 pt.name AS 'Pizza Name', CAST(p.price AS DECIMAL(10,2)) AS 'Price'
FROM pizzas p
JOIN pizza_types pt ON pt.pizza_type_id = p.pizza_type_id
ORDER BY p.price DESC;

-- Most common pizza size ordered
SELECT p.size, COUNT(DISTINCT od.order_id) AS 'Number of Orders', SUM(od.quantity) AS 'Total Quantity Ordered'
FROM order_details od
JOIN pizzas p ON p.pizza_id = od.pizza_id
GROUP BY p.size
ORDER BY SUM(od.quantity) DESC;

-- Top 5 most ordered pizza types
SELECT TOP 5 pt.name AS 'Pizza', SUM(od.quantity) AS 'Total Ordered'
FROM order_details od
JOIN pizzas p ON p.pizza_id = od.pizza_id
JOIN pizza_types pt ON pt.pizza_type_id = p.pizza_type_id
GROUP BY pt.name
ORDER BY SUM(od.quantity) DESC;

-- INTERMEDIATE ANALYSIS

-- Total quantity of each pizza category ordered
SELECT pt.category, SUM(od.quantity) AS 'Total Quantity Ordered'
FROM order_details od
JOIN pizzas p ON p.pizza_id = od.pizza_id
JOIN pizza_types pt ON pt.pizza_type_id = p.pizza_type_id
GROUP BY pt.category
ORDER BY SUM(od.quantity) DESC;

-- Distribution of orders by hour
SELECT DATEPART(HOUR, time) AS 'Hour of Day', COUNT(DISTINCT order_id) AS 'No of Orders'
FROM orders
GROUP BY DATEPART(HOUR, time)
ORDER BY [No of Orders] DESC;

-- Category-wise distribution of pizzas
SELECT category, COUNT(DISTINCT pizza_type_id) AS 'No of Pizzas'
FROM pizza_types
GROUP BY category
ORDER BY [No of Pizzas] DESC;

--  Average number of pizzas ordered per day
WITH daily_orders AS (
  SELECT o.date, SUM(od.quantity) AS total_quantity
  FROM orders o
  JOIN order_details od ON od.order_id = o.order_id
  GROUP BY o.date
)
SELECT AVG(total_quantity) AS 'Avg Pizzas Per Day'
FROM daily_orders;

-- Top 3 pizza types based on revenue
SELECT TOP 3 pt.name, SUM(od.quantity * p.price) AS 'Revenue'
FROM order_details od
JOIN pizzas p ON p.pizza_id = od.pizza_id
JOIN pizza_types pt ON pt.pizza_type_id = p.pizza_type_id
GROUP BY pt.name
ORDER BY Revenue DESC;

-- ADVANCED ANALYSIS

-- % Contribution of each pizza type to total revenue
SELECT pt.name, 
  CONCAT(CAST(SUM(od.quantity * p.price) * 100.0 / 
    (SELECT SUM(quantity * price) FROM order_details od JOIN pizzas p ON p.pizza_id = od.pizza_id) 
  AS DECIMAL(10,2)), '%') AS 'Revenue Contribution'
FROM order_details od
JOIN pizzas p ON p.pizza_id = od.pizza_id
JOIN pizza_types pt ON pt.pizza_type_id = p.pizza_type_id
GROUP BY pt.name
ORDER BY [Revenue Contribution] DESC;

-- Cumulative revenue over time
WITH daily_revenue AS (
  SELECT o.date, SUM(od.quantity * p.price) AS Revenue
  FROM orders o
  JOIN order_details od ON o.order_id = od.order_id
  JOIN pizzas p ON p.pizza_id = od.pizza_id
  GROUP BY o.date
)
SELECT date, Revenue, SUM(Revenue) OVER (ORDER BY date) AS 'Cumulative Revenue'
FROM daily_revenue;

--  Top 3 pizzas by revenue within each category
WITH pizza_revenue AS (
  SELECT pt.category, pt.name, SUM(od.quantity * p.price) AS Revenue
  FROM order_details od
  JOIN pizzas p ON p.pizza_id = od.pizza_id
  JOIN pizza_types pt ON pt.pizza_type_id = p.pizza_type_id
  GROUP BY pt.category, pt.name
),
ranked_pizzas AS (
  SELECT *, RANK() OVER (PARTITION BY category ORDER BY Revenue DESC) AS rnk
  FROM pizza_revenue
)
SELECT category, name, Revenue
FROM ranked_pizzas
WHERE rnk <= 3
ORDER BY category, Revenue DESC;

