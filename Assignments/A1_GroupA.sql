-- ***********************
-- Student1 Name: PARAS SINGH Student1 ID: 165-114-232
-- Student2 Name: AMARDEEP BRAR Student2 ID: 172-282-220
-- Student3 Name: GAGANPREET KAUR Student3 ID: 112-125-232
-- Date: 9 FEB 2025                                       
-- Purpose: Assignment 1 - DBS311
-- ***********************
--Q:1
--Display the employee number, full employee name, job title, and hire date of all 
--employees hired in September with the most recently hired employees displayed first. 
SELECT employee_id, 
       first_name || ' ' || last_name AS full_name, 
       job_title, 
       TO_CHAR(hire_date, 'Month DDth "of" YYYY') AS formatted_hire_date
FROM employees
WHERE EXTRACT(MONTH FROM hire_date) = 9
ORDER BY hire_date DESC;

--Q:2
--The company wants to see the total sale amount per sales person (salesman) for all orders. 
--Assume that online orders do not have any sales representative. For online orders (orders with no salesman ID), consider the salesman ID as 0. 
--Display the salesman ID and the total sale amount for each employee. 
--Sort the result according to employee number.

SELECT COALESCE(salesman_id, 0) AS salesman_id, 
       '$'||TO_CHAR(SUM(quantity * unit_price), '999,999,999.99') AS total_sales
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY salesman_id
ORDER BY salesman_id;

--Q:3
--Display customer Id, customer name and total number of orders for customers that the 
--value of their customer ID is in values from 35 to 45. Include the customers with no orders in your report if their customer ID falls in the range 35 and 45.  
--Sort the result by the value of total orders. 

SELECT c.customer_id, 
       c.name AS customer_name, 
       COUNT(o.order_id) AS total_orders
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE c.customer_id BETWEEN 35 AND 45
GROUP BY c.customer_id, c.name
ORDER BY total_orders;

--Q:4
--Display customer ID, customer name, and the order ID and the order date of all orders for customer whose ID is 44.
--Show also the total quantity and the total amount of each customer�s order.
--Sort the result from the highest to lowest total order amount.

SELECT o.customer_id, 
       c.name AS customer_name, 
       o.order_id, 
       TO_CHAR(o.order_date, 'DD-MON-YY') AS order_date,  
       SUM(oi.quantity) AS total_quantity, 
       SUM(oi.quantity * oi.unit_price) AS total_amount
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.customer_id = 44
GROUP BY o.customer_id, c.name, o.order_id, o.order_date
ORDER BY total_amount DESC;

--Q:5
--Display customer Id, name, total number of orders, the total number of items ordered, and the total order amount for customers who have more than 30 orders. 
--Sort the result based on the total number of orders.
SELECT c.customer_id, 
       c.name AS customer_name, 
       COUNT(o.order_id) AS total_orders, 
       SUM(oi.quantity) AS total_items, 
       TO_CHAR(SUM(oi.quantity * oi.unit_price), 'FM$999,999,999.00') AS total_amount  -- Dollar sign and commas
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.name
HAVING COUNT(o.order_id) > 30
ORDER BY total_orders ASC;


--Q:6
--Display Warehouse Id, warehouse name, product category Id, product category name, and the lowest product standard cost for this combination.
--In your result, include the rows that the lowest standard cost is less then $200.
--Also, include the rows that the lowest cost is more than $500.
--Sort the output according to Warehouse Id, warehouse name and then product category Id, and product category name.

SELECT 
    W.WAREHOUSE_ID AS "Warehouse ID",
    W.WAREHOUSE_NAME AS "Warehouse Name",
    PC.CATEGORY_ID AS "Product Category ID",
    PC.CATEGORY_NAME AS "Product Category Name",
    TO_CHAR(MIN(P.STANDARD_COST), 'FM$999,999,999.00') AS "Lowest Standard Cost"  
FROM WAREHOUSES W
JOIN INVENTORIES I ON W.WAREHOUSE_ID = I.WAREHOUSE_ID
JOIN PRODUCTS P ON I.PRODUCT_ID = P.PRODUCT_ID
JOIN PRODUCT_CATEGORIES PC ON P.CATEGORY_ID = PC.CATEGORY_ID
GROUP BY W.WAREHOUSE_ID, W.WAREHOUSE_NAME, PC.CATEGORY_ID, PC.CATEGORY_NAME
HAVING MIN(P.STANDARD_COST) < 200 OR MIN(P.STANDARD_COST) > 500
ORDER BY W.WAREHOUSE_ID, W.WAREHOUSE_NAME, PC.CATEGORY_ID, PC.CATEGORY_NAME;


--Q:7
--Display the total number of orders per month. Sort the result from January to December
SELECT TO_CHAR(order_date, 'Month') AS month_name, 
       COUNT(order_id) AS total_orders
FROM orders
GROUP BY TO_CHAR(order_date, 'Month'), EXTRACT(MONTH FROM order_date)
ORDER BY EXTRACT(MONTH FROM order_date);

--Q:8
--Display product Id, product name for products that their list price is more than any highest product standard cost per warehouse outside Americas regions.
--(You need to find the highest standard cost for each warehouse that is located outside the Americas regions. Then you need to return all products that their list price is higher than any highest standard cost of those warehouses.)
--Sort the result according to list price from highest value to the lowest.
SELECT p.product_id, 
       p.product_name, 
       TO_CHAR(p.list_price, '$999,999,999.99') AS list_price
FROM products p
WHERE p.list_price > COALESCE((
    SELECT MAX(p2.standard_cost) 
    FROM products p2 
    JOIN warehouses w ON p2.category_id = w.warehouse_id
    JOIN locations l ON w.location_id = l.location_id
    JOIN countries c ON l.country_id = c.country_id
    JOIN regions r ON c.region_id = r.region_id
    WHERE TRIM(LOWER(r.region_name)) NOT LIKE 'americas'
), 0)
ORDER BY p.list_price DESC;


--Q:9
--Write a SQL statement to display the most expensive and the cheapest product (list price). Display product ID, product name, and the list price.
SELECT product_id, 
       product_name, 
       TO_CHAR(list_price, '$999,999,999.99') AS list_price
FROM products
WHERE list_price = (SELECT MAX(list_price) FROM products)
   OR list_price = (SELECT MIN(list_price) FROM products);

--Q:10
--Write a SQL query to display the number of customers with total order amount over the average amount of all orders
SELECT COUNT(DISTINCT customer_id) AS customer_count
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.customer_id
HAVING SUM(oi.quantity * oi.unit_price) > 
       (SELECT AVG(total_amount) FROM 
            (SELECT SUM(quantity * unit_price) AS total_amount 
             FROM order_items 
             GROUP BY order_id));
             
             
             