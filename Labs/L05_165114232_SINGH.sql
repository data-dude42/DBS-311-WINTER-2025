-- ***********************
-- Name: PARAS SINGH
-- ID: 165-114-232
-- Date: 16 FEB 2025
-- Purpose: Lab 5 DBS311
-- ***********************
--Q:1Write a store procedure that get an integer number and prints
--The number is even.
--If a number is divisible by 2.
--Otherwise, it prints 
--The number is odd.
CREATE OR REPLACE PROCEDURE check_even_odd (p_num IN NUMBER) AS
BEGIN
    IF MOD(p_num, 2) = 0 THEN
        DBMS_OUTPUT.PUT_LINE('The number is even.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('The number is odd.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error! Something went wrong.');
END check_even_odd;
/
SET SERVEROUTPUT ON;
EXEC check_even_odd(2);
EXEC check_even_odd(5);

--Q:2----------------------------------------
--Create a stored procedure named find_employee. This procedure gets an employee number and prints the following employee information:
--First name 
--Last name 
--Email
--Phone 	
--Hire date 
--Job title
--
--The procedure gets a value as the employee ID of type NUMBER.
--See the following example for employee ID 107: 
--
--First name: Summer
--Last name: Payn
--Email: summer.payne@example.com
--Phone: 515.123.8181
--Hire date: 07-JUN-16
--Job title: Public Accountant
--
--The procedure display a proper error message if any error accours.

CREATE OR REPLACE PROCEDURE find_employee(
    emp_id IN EMPLOYEES.EMPLOYEE_ID%TYPE
)
IS
    v_first_name EMPLOYEES.FIRST_NAME%TYPE;
    v_last_name EMPLOYEES.LAST_NAME%TYPE;
    v_email EMPLOYEES.EMAIL%TYPE;
    v_phone EMPLOYEES.PHONE%TYPE;
    v_hire_date EMPLOYEES.HIRE_DATE%TYPE;
    v_manager_id EMPLOYEES.MANAGER_ID%TYPE;
    v_job_title EMPLOYEES.JOB_TITLE%TYPE;
    
BEGIN
    -- Retrieve employee details
    SELECT FIRST_NAME, LAST_NAME, EMAIL, PHONE, HIRE_DATE, MANAGER_ID, JOB_TITLE
    INTO v_first_name, v_last_name, v_email, v_phone, v_hire_date, v_manager_id, v_job_title
    FROM EMPLOYEES
    WHERE EMPLOYEE_ID = emp_id;

    -- Display Employee Information with first and last name on separate lines
    DBMS_OUTPUT.PUT_LINE('First Name: ' || v_first_name);
    DBMS_OUTPUT.PUT_LINE('Last Name: ' || v_last_name);
    DBMS_OUTPUT.PUT_LINE('Email: ' || v_email);
    DBMS_OUTPUT.PUT_LINE('Phone: ' || v_phone);
    DBMS_OUTPUT.PUT_LINE('Hire Date: ' || TO_CHAR(v_hire_date, 'DD-MON-YYYY'));
    DBMS_OUTPUT.PUT_LINE('Job Title: ' || v_job_title);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: No employee found with ID ' || emp_id);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END find_employee;
/
SET SERVEROUTPUT ON;
BEGIN
    find_employee(107);
END;
/


--Q:3--Every year, the company increases the price of all products in one category. For example, the company wants to increase the price (list_price) of products in category 1 by $5. Write a procedure named update_price_by_cat to update the price of all products in a given category and the given amount to be added to the current price if the price is greater than 0. The procedure shows the number of updated rows if the update is successful.
--The procedure gets two parameters:
--�	category_id IN NUMBER
--�	amount NUMBER(9,2)
--To define the type of variables that store values of a table� column, you can also write:
--variable_name table_name.column_name%type;
--The above statement defines a variable of the same type as the type of the table� column.
--category_id products.category_id%type;
--Or you need to see the table definition to find the type of the category_id column. Make sure the type of your variable is compatible with the value that is stored in your variable.
--To show the number of affected rows the update query, declare a variable named rows_updated of type NUMBER and use the SQL variable sql%rowcount to set your variable. Then, print its value in your stored procedure.
--Rows_updated := sql%rowcount;
--SQL%ROWCOUNT stores the number of rows affected by an INSERT, UPDATE, or DELETE.

CREATE OR REPLACE PROCEDURE update_price_by_cat (
    p_category_id IN PRODUCTS.CATEGORY_ID%TYPE,
    p_amount IN NUMBER
) AS
    v_rows_updated NUMBER;
BEGIN
    -- Update the product prices where the list_price is greater than 0
    UPDATE PRODUCTS
    SET LIST_PRICE = LIST_PRICE + p_amount
    WHERE CATEGORY_ID = p_category_id AND LIST_PRICE > 0;

    -- Store the number of rows affected
    v_rows_updated := SQL%ROWCOUNT;

    -- Display the number of updated rows
    DBMS_OUTPUT.PUT_LINE(v_rows_updated || ' rows updated.');

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error! No products found in category ' || p_category_id);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error! Something went wrong: ' || SQLERRM);
END update_price_by_cat;
/

SET SERVEROUTPUT ON;
EXEC update_price_by_cat(1, 5);



--Q:4Every year, the company increase the price of products whose price is less than the average price of all products by 1%. (list_price * 1.01). 
--Write a stored procedure named update_price_under_avg. 
--This procedure do not have any parameters. 
--You need to find the average price of all products and store it into a variable of the same type. 
--If the average price is less than or equal to $1000, update products� price by 2% if the price of the product is less than the calculated average. 
--If the average price is greater than $1000, update products� price by 1% if the price of the product is less than the calculated average. 
--The query displays an error message if any error occurs. Otherwise, it displays the number of updated rows.
CREATE OR REPLACE PROCEDURE update_price_under_avg AS
    v_avg_price PRODUCTS.LIST_PRICE%TYPE; -- Store the average price
    v_rows_updated NUMBER; -- Track the number of updated rows
BEGIN
    -- Calculate the average price of all products
    SELECT AVG(LIST_PRICE) INTO v_avg_price FROM PRODUCTS;

    -- Update product prices based on the average price condition
    IF v_avg_price <= 1000 THEN
        UPDATE PRODUCTS
        SET LIST_PRICE = LIST_PRICE * 1.02
        WHERE LIST_PRICE < v_avg_price;
    ELSE
        UPDATE PRODUCTS
        SET LIST_PRICE = LIST_PRICE * 1.01
        WHERE LIST_PRICE < v_avg_price;
    END IF;

    -- Store the number of affected rows
    v_rows_updated := SQL%ROWCOUNT;

    -- Display the number of updated rows
    DBMS_OUTPUT.PUT_LINE(v_rows_updated || ' rows updated.');

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error! Something went wrong: ' || SQLERRM);
END update_price_under_avg;
/

SET SERVEROUTPUT ON;
EXEC update_price_under_avg;

--Q:5The company needs a report that shows three category of products based their prices. The company needs to know if the product price is cheap, fair, or expensive. Let�s assume that
--?	If the list price is less than 
--o	(avg_price - min_price) / 2
--The product�s price is cheap.
--?	If the list price is greater than 
--o	(max_price - avg_price) / 2
--The product� price is expensive.
--?	If the list price is between 
--o	(avg_price - min_price) / 2
--o	and
--o	(max_price - avg_price) / 2
--o	the end values included
--The product�s price is fair.
--Write a procedure named product_price_report to show the number of products in each price category:
--The following is a sample output of the procedure if no error occurs:
--Cheap: 10
--Fair: 50
--Expensive: 18  
--The values in the above examples are just random values and may not match the real numbers in your result.
--The procedure has no parameter. First, you need to find the average, minimum, and maximum prices (list_price) in your database and store them into varibles avg_price, min_price, and max_price.
--You need more three varaibles to store the number of products in each price category:
--cheap_count
--fair_count
--exp_count


CREATE OR REPLACE PROCEDURE product_price_report AS
    v_avg_price PRODUCTS.LIST_PRICE%TYPE;  -- Store the average price
    v_min_price PRODUCTS.LIST_PRICE%TYPE;  -- Store the minimum price
    v_max_price PRODUCTS.LIST_PRICE%TYPE;  -- Store the maximum price
    v_cheap_count NUMBER := 0;  -- Count of cheap products
    v_fair_count NUMBER := 0;   -- Count of fair products
    v_exp_count NUMBER := 0;    -- Count of expensive products
    v_cheap_threshold NUMBER;
    v_exp_threshold NUMBER;
BEGIN
    -- Get min, max, and average price of products
    SELECT MIN(LIST_PRICE), MAX(LIST_PRICE), AVG(LIST_PRICE)
    INTO v_min_price, v_max_price, v_avg_price
    FROM PRODUCTS;

    -- Calculate price category thresholds
    v_cheap_threshold := (v_avg_price - v_min_price) / 2;
    v_exp_threshold := (v_max_price - v_avg_price) / 2;

    -- Count products in each category
    SELECT COUNT(*) INTO v_cheap_count FROM PRODUCTS WHERE LIST_PRICE < v_cheap_threshold;
    SELECT COUNT(*) INTO v_exp_count FROM PRODUCTS WHERE LIST_PRICE > v_exp_threshold;
    SELECT COUNT(*) INTO v_fair_count FROM PRODUCTS 
    WHERE LIST_PRICE BETWEEN v_cheap_threshold AND v_exp_threshold;

    -- Display category counts
    DBMS_OUTPUT.PUT_LINE('Cheap: ' || v_cheap_count);
    DBMS_OUTPUT.PUT_LINE('Fair: ' || v_fair_count);
    DBMS_OUTPUT.PUT_LINE('Expensive: ' || v_exp_count);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error! No product data found.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error! Something went wrong: ' || SQLERRM);
END product_price_report;
/

SET SERVEROUTPUT ON;
EXEC product_price_report;





--------------------------------------------------------LAB-06
CREATE OR REPLACE PROCEDURE calculate_factorial(
    n IN NUMBER
) 
AS
    result NUMBER := 1;
    i NUMBER;
BEGIN
    IF n < 0 THEN
        DBMS_OUTPUT.PUT_LINE('Factorial is not defined for negative numbers.');
        RETURN;
    END IF;

    FOR i IN REVERSE 1..n LOOP
        result := result * i;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE(n || '! = ' || result);

EXCEPTION
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Error: Too many rows encountered.');
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: No data found.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END calculate_factorial;
/
SET SERVEROUTPUT ON;

BEGIN
    calculate_factorial(5);
END;
/
---------------------------------------------
CREATE OR REPLACE PROCEDURE calculate_salary(
    p_employee_id IN NUMBER
)
AS
    v_first_name employees.first_name%TYPE;
    v_last_name employees.last_name%TYPE;
    v_years NUMBER;
    v_salary NUMBER := 10000; -- Base salary
BEGIN
    -- Retrieve employee details and years worked
    SELECT first_name, last_name, EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM hire_date)
    INTO v_first_name, v_last_name, v_years
    FROM employees
    WHERE employee_id = p_employee_id;

    -- Calculate salary with 5% annual increase
    FOR i IN 1..v_years LOOP
        v_salary := v_salary * 1.05;
    END LOOP;

    -- Display results
    DBMS_OUTPUT.PUT_LINE('First Name: ' || v_first_name);
    DBMS_OUTPUT.PUT_LINE('Last Name: ' || v_last_name);
    DBMS_OUTPUT.PUT_LINE('Salary: $' || TO_CHAR(v_salary, '9999.99'));

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: Employee not found.');
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Error: Multiple employees found.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END calculate_salary;
/
SET SERVEROUTPUT ON;
BEGIN
    calculate_salary(101);
END;
/
---------------------------------------------
CREATE OR REPLACE PROCEDURE warehouses_report 
AS
BEGIN
    -- Loop through the warehouses table for warehouse_id between 1 and 9
    FOR warehouse_rec IN (
        SELECT warehouse_id, warehouse_name, city, 
               NVL(state, 'no state') AS warehouse_state -- Ensure correct column alias
        FROM warehouses
        WHERE warehouse_id BETWEEN 1 AND 9
    ) LOOP
        -- Print warehouse details
        DBMS_OUTPUT.PUT_LINE('Warehouse ID: ' || warehouse_rec.warehouse_id);
        DBMS_OUTPUT.PUT_LINE('Warehouse Name: ' || warehouse_rec.warehouse_name);
        DBMS_OUTPUT.PUT_LINE('City: ' || warehouse_rec.city);
        DBMS_OUTPUT.PUT_LINE('State: ' || warehouse_rec.warehouse_state); -- Use correct alias
        DBMS_OUTPUT.PUT_LINE('---------------------------');
    END LOOP;
    
    -- Handle case when no warehouses exist
    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No warehouses found in the given range.');
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No warehouses found.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END warehouses_report;
/


SET SERVEROUTPUT ON;
BEGIN
    warehouses_report;
END;
/







