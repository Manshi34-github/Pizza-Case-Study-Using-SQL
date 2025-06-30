# Pizza Sales Analysis – SQL Case Study

Welcome to my SQL case study project based on pizza sales data. The goal of this project is to extract valuable business insights from a pizza restaurant’s transactional data using SQL queries.

---

## Dataset Overview

The dataset contains four main tables:

| Table Name      | Description                                                              |
|-----------------|--------------------------------------------------------------------------|
| `orders`        | Contains `order_id`, `date`, and `time` of each order.                   |
| `order_details` | Line-item level data with `order_id`, `pizza_id`, and `quantity`.        |
| `pizzas`        | Contains `pizza_id`, `pizza_type_id`, `size`, and `price`.               |
| `pizza_types`   | Contains `pizza_type_id`, `name`, `category`, and `ingredients`.         |

---

## Problem Statement

This project is divided into three sections based on the complexity of insights:

### Basic Analysis

- Retrieve the total number of orders placed.
- Calculate the total revenue generated from pizza sales.
- Identify the highest-priced pizza.
- Find the most common pizza size ordered.
- List the top 5 most ordered pizza types and their quantities.

### Intermediate Analysis

- Find total quantity ordered per pizza category.
- Analyze the hourly distribution of orders.
- Find category-wise distribution of pizza types.
- Calculate average number of pizzas ordered per day.
- Determine the top 3 revenue-generating pizza types.

### Advanced Analysis

- Calculate % contribution of each pizza type to total revenue.
- Analyze cumulative revenue over time.
- Identify top 3 revenue-generating pizzas per category.

---

## Tools Used

- **SQL** (MySQL)
- **DBMS:** MySQL Workbench

---

## 📊 Key Insights

- Identified best-selling and most profitable pizzas.
- Observed peak order hours (helpful for inventory/staff planning).
- Determined most preferred categories and pizza sizes.
- Analyzed revenue trends over time and by category.
