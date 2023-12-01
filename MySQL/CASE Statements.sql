-- CASE STATEMENTS : used to execute according to the condition
SELECT 
    emp_no,
    first_name,
    last_name,
    CASE
        WHEN gender = 'M' THEN 'Male'
        ELSE 'Female'
    END AS gender
FROM
    employees;
    
-- another example
SELECT 
    e.emp_no,
    e.first_name,
    e.last_name,
    CASE
        WHEN dm.emp_no IS NOT NULL THEN 'Manager'
        ELSE 'Employee'
    END AS is_manager
FROM
    employees e
        LEFT JOIN
    dept_manager dm ON dm.emp_no = e.emp_no
WHERE
    e.emp_no > 109990;

-- IF : you can only have one condition unlike case statement
SELECT 
    emp_no,
    first_name,
    last_name,
    IF(gender = 'M', 'Male', 'Female') AS gender
FROM
    employees;

-- salary rise check : increase in salaries of dept_managers based on a multiple condition
SELECT 
    dm.emp_no,
    e.first_name,
    e.last_name,
    MAX(s.salary) - MIN(s.salary) AS salary_difference,
    CASE
        WHEN MAX(s.salary) - MIN(s.salary) > 30000 THEN 'Salary raised by $30000'
        WHEN MAX(s.salary) - MIN(s.salary) BETWEEN 20000 AND 30000 THEN 'salary raised between 20k$ and 30k$'
        ELSE 'salary was raised less than 20k$'
    END AS salary_raise
FROM
    dept_manager dm
        JOIN
    employees e ON e.emp_no = dm.emp_no
        JOIN
    salaries s ON s.emp_no = dm.emp_no
GROUP BY s.emp_no;

/*
Similar to the exercises done in the lecture, obtain a result set containing the employee number, first name, and 
last name of all employees with a number higher than 109990.
Create a fourth column in the query, indicating whether this employee is also a manager, 
according to the data provided in the dept_manager table, or a regular employee. 
*/
select * from employees limit 1;
SELECT 
    *
FROM
    dept_manager;
SELECT 
    dm.emp_no,
    e.first_name,
    e.last_name,
    CASE
        WHEN dm.emp_no IS NOT NULL THEN 'Manager'
        ELSE 'Employee'
    END AS is_Manager
FROM
    employees e
        LEFT JOIN
    dept_manager dm ON e.emp_no = dm.emp_no
WHERE
    e.emp_no > 109990;


/*
Extract a dataset containing the following information about the managers: employee number, first name, and last name. 
Add two columns at the end – one showing the difference between the maximum and minimum salary of that employee, and 
another one saying whether this salary raise was higher than $30,000 or NOT.

If possible, provide more than one solution.
*/
SELECT 
    dm.emp_no,
    e.first_name,
    e.last_name,
    MAX(s.salary) - MIN(s.salary) AS salary_difference,
    CASE
        WHEN MAX(s.salary) - MIN(s.salary) > 30000 THEN 'Salary raised by $30000'
        ELSE 'salary was not raised than 30k$'
    END AS salary_raise
FROM
    dept_manager dm
        JOIN
    employees e ON e.emp_no = dm.emp_no
        JOIN
    salaries s ON s.emp_no = dm.emp_no
GROUP BY s.emp_no;

/*
Extract the employee number, first name, and last name of the first 100 employees, and 
add a fourth column, called “current_employee” saying “Is still employed” if the employee is still working in the company, 
or “Not an employee anymore” if they aren’t.
Hint: You’ll need to use data from both the ‘employees’ and the ‘dept_emp’ table to solve this exercise. 
*/
-- select * from dept_emp;

SELECT 
    e.emp_no,
    e.first_name,
    e.last_name,
    CASE
        WHEN max(de.to_date) > SYSDATE() THEN 'Is still employed'
        ELSE 'Not an employee anymore'
    END AS is_Employee
FROM
    employees e
        JOIN
    dept_emp de ON e.emp_no = de.emp_no
group BY e.emp_no
LIMIT 100;






