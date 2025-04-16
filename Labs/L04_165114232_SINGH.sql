-- ***********************
-- Name: PARAS SINGH
-- ID: 165-114-232
-- Date: 7 FEB 2025
-- Purpose: Lab 4 DBS311
-- ***********************

--Q:1
--The HR department needs a list of Department IDs for departments that 
--do not contain the job ID of ST_CLERK> Use a set operator to create this report.
SELECT DISTINCT department_id 
FROM job_history
MINUS
SELECT DISTINCT department_id 
FROM job_history
WHERE job_id = 'ST_CLERK';

--Q:2
--Display cities that no warehouse is located in them. (use set operators to answer this question)
SELECT city   FROM locations  
MINUS  
SELECT l.city  FROM locations l  JOIN warehouses w ON l.location_id = w.location_id;  

--Q:3
--Display the category ID, category name, and the number of products in category 1, 2, and 5. 
--In your result, display first the number of products in category 5, then category 1 and then 2.
SELECT category_id, category_name, product_count FROM (
    SELECT p.category_id, pc.category_name, COUNT(p.product_id) AS product_count
    FROM products p
    JOIN product_categories pc ON p.category_id = pc.category_id
    WHERE p.category_id = 5
    GROUP BY p.category_id, pc.category_name
) 
UNION ALL
SELECT category_id, category_name, product_count FROM (
    SELECT p.category_id, pc.category_name, COUNT(p.product_id) AS product_count
    FROM products p
    JOIN product_categories pc ON p.category_id = pc.category_id
    WHERE p.category_id = 1
    GROUP BY p.category_id, pc.category_name
)
UNION ALL
SELECT category_id, category_name, product_count FROM (
    SELECT p.category_id, pc.category_name, COUNT(p.product_id) AS product_count
    FROM products p
    JOIN product_categories pc ON p.category_id = pc.category_id
    WHERE p.category_id = 2
    GROUP BY p.category_id, pc.category_name
);

SELECT p.category_id, pc.category_name, COUNT(p.product_id) AS product_count
FROM products p
JOIN product_categories pc ON p.category_id = pc.category_id
WHERE p.category_id IN (1, 2, 5)
GROUP BY p.category_id, pc.category_name
ORDER BY CASE 
    WHEN p.category_id = 5 THEN 1 
    WHEN p.category_id = 1 THEN 2 
    WHEN p.category_id = 2 THEN 3 
END;


--Q:4
--Display product ID for ordered products whose quantity in the inventory is greater than 5. 
--(You are not allowed to use JOIN for this question.)
SELECT product_id FROM order_items
INTERSECT
SELECT product_id FROM inventories WHERE quantity > 5;


--Q:5
--We need a single report to display all warehouses and the state that they are located in 
--and all states regardless of whether they have warehouses in them or not.
SELECT state FROM locations
UNION
SELECT l.state FROM locations l
JOIN warehouses w ON l.location_id = w.location_id;






