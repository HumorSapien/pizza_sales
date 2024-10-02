-- Retreive the total numbers of orders placed

select count(order_id) as total_numbers_of_orders
from orders;

-- Calculate total revenue generated from pizza sales

SELECT round(CAST(sum(pizzas.price * order_details.quantity) AS numeric), 2) AS total_price
FROM pizzas
JOIN order_details 
ON pizzas.pizza_id = order_details.pizza_id;

-- Identify the highest-priced pizza.

select pizza_types.name, pizzas.price
from pizza_types 
join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
order by pizzas.price desc
limit 1;

-- Identify the most common pizza size ordered.

select pizzas.size, count(order_details.order_details_id) as total_orders
from pizzas 
join order_details
on pizzas.pizza_id = order_details.pizza_id
group by pizzas.size
order by total_orders desc
limit 1;

-- List the top 5 most ordered pizza types along with their quantities.

select pizza_types.name, 
sum(order_details.quantity) as most_ordered
from pizza_types 
join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by 1
order by most_ordered desc
limit 5;

-- Join the necessary tables to find the total quantity of each pizza category ordered.

select pizza_types.category, sum(order_details.quantity)
from pizza_types 
join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by 1;

-- Determine the distribution of orders by hour of the day.

select extract(hour from time) as hour,
count(order_id)
from orders
group by hour
order by count(order_id) desc;

-- Join relevant tables to find the category-wise distribution of pizzas.

select category, count(name)
from pizza_types
group by 1;

-- Group the orders by date and calculate the average number of pizzas ordered per day.

select round(cast(avg(pizzas_ordered)as numeric),1) as average_orders from
(select orders.date, sum(order_details.quantity) as pizzas_ordered
from orders
join order_details
on orders.order_id = order_details.order_id
group by 1) as order_data;

-- Determine the top 3 most ordered pizza types based on revenue.

SELECT pizza_types.name,round(CAST(sum(pizzas.price * order_details.quantity) AS numeric), 2) AS revenue
from pizza_types
join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by 1
order by revenue desc
limit 3;

-- Calculate the percentage contribution of each pizza type to total revenue.

select pizza_types.category,
(round(cast(sum(order_details.quantity * pizzas.price)as numeric),2) / (SELECT round(CAST(sum(pizzas.price * order_details.quantity) AS numeric), 2) AS total_price
FROM pizzas
JOIN order_details 
ON pizzas.pizza_id = order_details.pizza_id)) *100 as revenue
from pizza_types
join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by 1
order by revenue desc;

-- Analyze the cumulative revenue generated over time.

select date, sum(revenue) over(order by date) as cum_revenue 
from
(select orders.date, sum(order_details.quantity * pizzas.price) as revenue
from order_details
join pizzas
on order_details.pizza_id = pizzas.pizza_id
join orders
on orders.order_id = order_details.order_id
group by 1) as sales;