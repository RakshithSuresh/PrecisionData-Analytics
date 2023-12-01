-- AGGREGATE FUNCTIONS : they gather data from many rows of a table, then aggregate into a single value
-- COUNT, SUM, MIN(), MAX(), AVG()

SELECT 
    *
FROM
    salaries
ORDER BY salary DESC
LIMIT 10;


-- COUNT(DISTINCT)
-- how many start dates are in the DB?
SELECT 
    COUNT(DISTINCT from_date)
FROM
    salaries;

-- COUNT(*): to count the null values also

SELECT 
    COUNT(DISTINCT dept_no)
FROM
    dept_emp;
    
-- SUM
SELECT 
    SUM(salary) AS Total
FROM
    salaries;
SELECT 
    *
FROM
    salaries
LIMIT 10;
-- What is the total amount of money spent on salaries for all contracts starting after the 1st of January 1997?
SELECT 
    SUM(salary)
FROM
    salaries
WHERE
    from_date > '1997-01-01';

-- MIN and MAX
-- highest salary
SELECT 
    MAX(salary)
FROM
    salaries;
-- lowest salary
SELECT 
    MIN(salary)
FROM
    salaries;
    
-- highest and lowest employee number in database
SELECT 
    MAX(emp_no), MIN(emp_no)
FROM
    employees;

-- average 
SELECT 
ROUND(AVG(salary),2)
FROM
    salaries;

-- What is the average annual salary paid to employees who started after the 1st of January 1997?
-- Round the average amount of money spent on salaries for all contracts that started after the 1st of January 1997 to a precision of cents.
SELECT 
    ROUND(AVG(salary),2)
FROM
    salaries
WHERE
    from_date > '1997-01-01';