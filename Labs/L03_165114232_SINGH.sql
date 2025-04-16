-- ***********************
-- Name: Paras Singh
-- ID: 165114232
-- Date: 30 Jan. 2025
-- Purpose: Lab 3 DBS311
-- ***********************

--Q:1-------------------------------------------------------------------------------
--Write a SQL query to display the last name and hire date of all employees who were
--hired before the employee with ID 107 got hired. Sort the result by the hire date.

select last_name, hire_date from employees where hire_date <= 
(select hire_date from employees where employee_id=107);

--Q:2----------------------------------------------------------------------------------
--Write a SQL query to display customer name and credit limit for customers with lowest
--credit limit. Sort the result by customer name.

select name, credit_limit from customers where credit_limit = 
(select min(credit_limit) from customers);

--Q:3-------------------------------------------------------------------------------------
--Write a SQL query to display the product ID, product name, and list price of the highest
--paid product(s) in each category. Sort by category ID
select category_id,product_id, product_name,list_price from products where list_price = any
(select max(list_price) from products group by category_id)
order by category_id;

--Q:4-------------------------------------------------------------------------------
--Write a SQL query to display the category name of the most expensive (highest list
--price) product(s)
select category_name from product_categories
join products
on
product_categories.category_id=products.category_id
where list_price=(select max(list_price) from products);

--Q:5--------------------------------------------------------------------------------
--Write a SQL query to display product name and list price for products in category 1
--which have the list price less than the lowest list price in ANY category. 
--Sort the output by top list prices first and then by the product name.

select product_name, list_price from products where category_id = 1
and list_price< any(select min(list_price) from products group by category_id)
order by list_price, product_name;

--Q:6-----------------------------------------------------------------------------------
--Display product ID, product name, and category ID for products of the category(s) that
--the lowest price product belongs to.
select product_id, product_name, category_id from products
where
category_id=(select category_id from products where list_price= any
(select min(list_price) from products ));





















