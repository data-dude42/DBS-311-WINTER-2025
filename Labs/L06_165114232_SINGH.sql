-- ***********************
-- Name: PARAS SINGH
-- ID: 165-114-232
-- Date: 9 march 2025
-- Purpose: Lab 6 DBS311
-- ***********************

--1.Write a store procedure that gets an integer number n and calculates and displays its factorial.
--Example:
--0! = 1
--2! = fact(2) = 2 * 1 = 1
--3! = fact(3) = 3 * 2 * 1 = 6
--. . .
--n! = fact(n) = n * (n-1) * (n-2) * . . . * 1

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

--2.	The company wants to calculate the employees’ annual salary:
--The first year of employment, the amount of salary is the base salary which is $10,000.
--Every year after that, the salary increases by 5%.
--Write a stored procedure named calculate_salary which gets an employee ID and for that employee calculates the salary based on the number of years the employee has been working in the company.  (Use a loop construct to calculate the salary).
--The procedure calculates and prints the salary.
--Sample output:
--First Name: first_name 
--Last Name: last_name
--Salary: $9999,99
--If the employee does not exists, the procedure displays a proper message.
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
 DBMS_OUTPUT.PUT_LINE('Salary: $' || TO_CHAR(v_salary, 'FM9999999.99'));


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


--3.Write a stored procedure named warehouses_report to print the warehouse ID, warehouse name, and the city where the warehouse is located in the following format for all warehouses:
--
--Warehouse ID:
--Warehouse name:
--City:
--State:
--
--If the value of state does not exist (null), display “no state”.
--The value of warehouse ID ranges from 1 to 9.
--You can use a loop to find and display the information of each warehouse inside the loop.
--(Use a loop construct to answer this question. Do not use cursors.) 
---------------------------------------------
CREATE OR REPLACE PROCEDURE warehouses_report
AS
    v_warehouse_name WAREHOUSES.WAREHOUSE_NAME%TYPE;
    v_city LOCATIONS.CITY%TYPE;
    v_state LOCATIONS.STATE%TYPE;

BEGIN
    -- Loop through warehouse IDs from 1 to 9
    FOR i IN 1..9 LOOP
        BEGIN
            -- Retrieve warehouse details with join on LOCATIONS
            SELECT w.WAREHOUSE_NAME, l.CITY, NVL(l.STATE, 'no state')
            INTO v_warehouse_name, v_city, v_state
            FROM WAREHOUSES w
            JOIN LOCATIONS l ON w.LOCATION_ID = l.LOCATION_ID
            WHERE w.WAREHOUSE_ID = i;

            -- Display warehouse details
            DBMS_OUTPUT.PUT_LINE('Warehouse ID: ' || i);
            DBMS_OUTPUT.PUT_LINE('Warehouse name: ' || v_warehouse_name);
            DBMS_OUTPUT.PUT_LINE('City: ' || v_city);
            DBMS_OUTPUT.PUT_LINE('State: ' || v_state);
            DBMS_OUTPUT.PUT_LINE('----------------------'); -- Separator for better readability

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('Warehouse ID: ' || i || ' not found.');
                DBMS_OUTPUT.PUT_LINE('----------------------');
        END;
    END LOOP;
END warehouses_report;
/
SET SERVEROUTPUT ON;
BEGIN
    warehouses_report;
END;
/



