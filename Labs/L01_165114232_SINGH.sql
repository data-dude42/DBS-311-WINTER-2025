-- ***********************
-- Name: Paras Singh
-- ID: 165114232
-- Date: 23 Jan. 2025
-- Purpose: Lab 2 DBS311
-- ***********************
--Q1: For each job title display the number of employees.
SELECT job_title, COUNT(employee_id) AS employee_count
FROM employees
GROUP BY job_title
--------------------------------------------------------------------------------------------------------------------------------------------------
--Q2: Display the Highest, Lowest and Average customer credit limits. 
--Name these results High, Low and Avg. Add a column that shows the difference between the highest and lowest credit limits.
--Use the round function to display two digits after the decimal point.
SELECT MAX(CREDIT_LIMIT)as high, MIN(CREDIT_LIMIT)as Low, round(AVG(CREDIT_LIMIT),2)as Avg,
(max(credit_limit)- Min(credit_limit)) as difference
FROM CUSTOMERS;
--------------------------------------------------------------------------------------------------------------------------------------------------
--Q3: Display the order id and the total order amount for orders with the total amount over $1000,000. 
select order_id, sum(quantity * unit_price)from order_items
group by order_id
having sum(quantity* unit_price)> 100000;

--------------------------------------------------------------------------------------------------------------------------------------------------
--Q4: Display the warehouse id, warehouse name, and the total number of products for each warehouse. 
select w.warehouse_id, w.warehouse_name,
sum(i.Quantity) as total
from warehouses w
left join 
inventories i
on
w.warehouse_id = i.warehouse_id
group by w.warehouse_id, w.warehouse_name;

--------------------------------------------------------------------------------------------------------------------------------------------------
--Q5: For each customer display the number of orders issued by the customer. 
--If the customer does not have any orders, the result show display 0.
select c.customer_id, c.name,count(o.order_id) from 
customers c
left join
orders o
on
c.customer_id = o.customer_id
group by 
c.customer_id, c.name;

--------------------------------------------------------------------------------------------------------------------------------------------------
--Q6: Write a SQL query to show the total and the average sale amount for each category.
select p.category_id,
SUM(oi.quantity * oi.unit_price) AS total_sale_amount,
ROUND(AVG(oi.quantity * oi.unit_price),2) AS avg_sale_amount
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.category_id;

--------------------------------------------------------------------------------------------------------------------------------
--LAB-03--
select hire_date from employees where employee_id=4;
--Q-1---
select last_name, hire_date from employees where hire_date <= 
(select hire_date from employees where employee_id=107);

--Q-2
select min(credit_limit) from customers;

select name, credit_limit from customers where credit_limit = 
(select min(credit_limit) from customers);

--Q-3









