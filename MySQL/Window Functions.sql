-- Window Functions : perform calculation for the record, using other records associated with specified one from table
-- aggregate and non-aggregate window functions
-- ROW_NUMBER()
use employees;
-- extracting the salary from highest to lowest and partitoning by row numbers
select 
emp_no, salary, 
row_number() over(partition by emp_no order by salary desc) as row_num
from salaries;

-- another way of writing window functions using window names(preferred)
select 
emp_no, salary, 
row_number() over w as row_num
from salaries
window w as (partition by emp_no order by salary desc);

/*
Exercise #1 :

Write a query that upon execution, assigns a row number to all managers we have information for in the "employees" database (regardless of their department).
Let the numbering disregard the department the managers have worked in. Also, let it start from the value of 1. Assign that value to the manager with the lowest employee number.
*/

-- select * from dept_manager;
select emp_no, dept_no,
row_number () over w1 as row_num
from dept_manager
window w1 as (order by emp_no asc); 

/*
Exercise #2:

Write a query that upon execution, assigns a sequential number for each employee number registered in the "employees" table. 
Partition the data by the employee's first name and order it by their last name in ascending order (for each partition).
*/
select emp_no, first_name, last_name, 
row_number() over(partition by first_name order by last_name asc) as row_num
from employees;

/*
excercise 1: Obtain a result set containing the salary values each manager has signed a contract for. To obtain the data, refer to the "employees" database.
Use window functions to add the following two columns to the final output:

- a column containing the row number of each row from the obtained dataset, starting from 1.
- a column containing the sequential row numbers associated to the rows for each manager,
where their highest salary has been given a number equal to the number of rows in the given partition, and their lowest - the number 1.

Finally, while presenting the output, make sure that the data has been ordered by the values in the first of the row number columns, 
and then by the salary values for each partition in ascending order.
*/
select dm.emp_no,salary,
row_number() over() as row_num1,
row_number() over w2 as row_num2
from
 dept_manager dm join salaries s on dm.emp_no = s.emp_no
  window w2 as (partition by emp_no order by salary desc)
 order by row_num1, emp_no, salary ASC;

-- set @@global.sql_mode := replace(@@global.sql_mode, 'ONLY_FULL_GROUP_BY', '');

/*
Obtain a result set containing the salary values each manager has signed a contract for. To obtain the data, refer to the "employees" database.
Use window functions to add the following two columns to the final output:

- a column containing the row numbers associated to each manager, where their highest salary has been given a number equal to the number of rows in the given partition, and their lowest - the number 1.
- a column containing the row numbers associated to each manager, where their highest salary has been given the number of 1, and the lowest - a value equal to the number of rows in the given partition.

Let your output be ordered by the salary values associated to each manager in descending order.
*/

 select dm.emp_no, s.salary,
row_number() over(PARTITION BY emp_no ORDER BY salary ASC) as row_num1,
row_number() over(PARTITION BY emp_no ORDER BY salary DESC) as row_num2
from dept_manager dm	
join salaries s on s.emp_no = dm.emp_no;

/*
Write a query that provides row numbers for all workers from the "employees" table, partitioning the data by their first names and 
ordering each partition by their employee number in ascending order.

NB! While writing the desired query, do *not* use an ORDER BY clause in the relevant SELECT statement. 
At the same time, do use a WINDOW clause to provide the required window specification.
*/

select emp_no,first_name,
row_number() over w as row_num
from employees e
window w as (partition by e.first_name order by emp_no);

-- partition by vs group by
/*
Exercise #1:

Find out the lowest salary value each employee has ever signed a contract for. To obtain the desired output, use a subquery containing a window function, 
as well as a window specification introduced with the help of the WINDOW keyword.

Also, to obtain the desired result set, refer only to data from the “salaries” table.
*/
select a.emp_no, a.salary from
(select emp_no,salary,
row_number() over w as row_num
from salaries s
window w as (partition by emp_no order by s.salary asc)) as a
where row_num = 1;

/*
Again, find out the lowest salary value each employee has ever signed a contract for. 
Once again, to obtain the desired output, use a subquery containing a window function. 
This time, however, introduce the window specification in the field list of the given subquery.

To obtain the desired result set, refer only to data from the “salaries” table.
*/

select a.emp_no, a.salary from
(select emp_no,salary,
row_number() over (partition by emp_no order by s.salary asc) as row_num
from salaries s) as a
where row_num = 1;

/*
Exercise #3:

Once again, find out the lowest salary value each employee has ever signed a contract for. 
This time, to obtain the desired output, avoid using a window function. Just use an aggregate function and a subquery.

To obtain the desired result set, refer only to data from the “salaries” table.
*/
select a.emp_no, min(a.salary) from
(select emp_no, salary 
from salaries)a
group by emp_no;

/*
Exercise #4:
Find out the second-lowest salary value each employee has ever signed a contract for. 
To obtain the desired output, use a subquery containing a window function, as well as a window specification introduced with the help of the WINDOW keyword.
 Moreover, obtain the desired result set without using a GROUP BY clause in the outer query.

To obtain the desired result set, refer only to data from the “salaries” table.
*/
select a.emp_no, a.salary as min_salary from
(select emp_no,salary,
row_number() over (partition by emp_no order by s.salary asc) as row_num
from salaries s) as a
where row_num = 2;

-- Ranking window functions(video 270)	
-- to rank the row according to their values
-- ranking an employee salary, count the same rank if he/she worked for same salary in different contracts
select 
emp_no, salary, dense_rank() over w as rank_num
from salaries
where emp_no = 11839
window w as  (partition by emp_no order by salary desc); 

/*
Exercise #1:
Write a query containing a window function to obtain all salary values that employee number 10560 has ever signed a contract for.
Order and display the obtained salary values from highest to lowest.
*/
select
emp_no, salary, row_number() over w as row_num
from salaries
where emp_no = 10560
window w as  (partition by emp_no order by salary desc); 

/*
Exercise #2:
Write a query that upon execution, displays the number of salary contracts that each manager has ever signed while working in the company.
*/
select dm.emp_no, count(salary) as no_of_salary_contracts
from salaries s
join dept_manager dm on s.emp_no = dm.emp_no
group by dm.emp_no
order by dm.emp_no;

/*
Exercise #3:

Write a query that upon execution retrieves a result set containing all salary values that employee 10560 has ever signed a contract for. 
Use a window function to rank all salary values from highest to lowest in a way that equal salary values bear the same rank and
 that gaps in the obtained ranks for subsequent rows are allowed.
*/

select
emp_no, salary, rank() over w as rank_num
from salaries
where emp_no = 10560
window w as  (partition by emp_no order by salary desc); 


/* BIG TASK*/
select d.dept_no, d.dept_name, dm.emp_no, rank() over w as dpt_salary_ranking, s.salary, s.from_date as salary_from_date, s.to_date as salary_to_date, dm.from_date as dept_manager_from_date, dm.to_date as dept_manager_to_date
from departments d
join dept_manager dm on d.dept_no = dm.dept_no
join salaries s on dm.emp_no = s.emp_no
-- making sure the salary contract is between the manager position days
and s.from_date between dm.from_date and dm.to_date
and s.to_date between dm.from_date and dm.to_date
window w as (partition by dm.dept_no order by s.salary desc);

/*
Exercise #1:
Write a query that ranks the salary values in descending order of all contracts signed by employees numbered between 10500 and 10600 inclusive. 
Let equal salary values for one and the same employee bear the same rank. Also, allow gaps in the ranks obtained for their subsequent rows.

Use a join on the “employees” and “salaries” tables to obtain the desired result.
*/

select e.emp_no, rank() over w as employee_salary_ranking, s.salary
from employees e
join salaries s on e.emp_no = s.emp_no
where e.emp_no between 10500 and 10600
window w as (partition by e.emp_no order by salary desc);

/*
Exercise #2:
Write a query that ranks the salary values in descending order of the following contracts from the "employees" database:
- contracts that have been signed by employees numbered between 10500 and 10600 inclusive.
- contracts that have been signed at least 4 full-years after the date when the given employee was hired in the company for the first time.
In addition, let equal salary values of a certain employee bear the same rank. Do not allow gaps in the ranks obtained for their subsequent rows.
Use a join on the “employees” and “salaries” tables to obtain the desired result.
*/

SELECT 
    s.emp_no, dense_rank() over w as salary_ranking , s.salary, e.hire_date, s.from_date,(year(s.from_date)- year(e.hire_date)) as year_from_start
FROM
    employees e
        JOIN
    salaries s ON s.emp_no = e.emp_no
    and YEAR(s.from_date) - YEAR(e.hire_date) >= 5
    where e.emp_no BETWEEN 10500 AND 10600
WINDOW w as (PARTITION BY e.emp_no ORDER BY s.salary DESC);

-- LAG and LEAD window functions
-- LAG returns the value from a specified column of a record that preceds the current row
-- LEAD returns the value from a specified column of a record that follows the current row

SELECT 
    emp_no,
    salary,
    LAG(salary) over w as previous_salary,
    LEAD(salary) over w as next_salary,
    salary - LAG(salary) over w as diff_salary_current_previous,
    LEAD(salary) over w - salary  as diff_salary_next_previous 
FROM
    salaries
    where emp_no = 10001
    WINDOW w as (order by salary asc);

/*
Exercise #1:
Write a query that can extract the following information from the "employees" database:
- the salary values (in ascending order) of the contracts signed by all employees numbered between 10500 and 10600 inclusive
- a column showing the previous salary from the given ordered list
- a column showing the subsequent salary from the given ordered list
- a column displaying the difference between the current salary of a certain employee and their previous salary
- a column displaying the difference between the next salary of a certain employee and their current salary

Limit the output to salary values higher than $80,000 only.
Also, to obtain a meaningful result, partition the data by employee number.
*/

SELECT 
    emp_no, salary,
    lag(salary) over w as previous_salary,
    lead(salary) over w as next_salary,
    salary - lag(salary) over w as diff_current_previous,
    lead(Salary) over w - salary as diff_next_current
FROM
    salaries
    where emp_no between 10500 and 10600
    and salary > 80000
    window w as (partition by emp_no order by salary asc);

/*
Exercise #2:

The MySQL LAG() and LEAD() value window functions can have a second argument, 
designating how many rows/steps back (for LAG()) or forth (for LEAD()) we'd like to refer to with respect to a given record.

With that in mind, create a query whose result set contains data arranged by the salary values associated to each employee number (in ascending order). 
Let the output contain the following six columns:
- the employee number
- the salary value of an employee's contract (i.e. which we’ll consider as the employee's current salary)
- the employee's previous salary
- the employee's contract salary value preceding their previous salary
- the employee's next salary
- the employee's contract salary value subsequent to their next salary
Restrict the output to the first 1000 records you can obtain.
*/
SELECT 
    emp_no,
    salary,
    lag(salary) over w as pre_salary,
    lag(salary,2) over w as pre2_salary,
    lead(salary) over w as next_salary,
    lead(salary,2) over w as next2_salary
FROM
    salaries
    window w as (partition by emp_no order by salary asc)
    limit 1000;
    
    
-- aggregate functions
select sysdate();
SELECT 
    s1.emp_no, s.salary, s.from_date, s.to_date
FROM
    salaries s
        JOIN
    (SELECT 
        emp_no, MAX(from_date) AS from_date
    FROM
        salaries
    GROUP BY emp_no) s1 ON s1.emp_no = s.emp_no
WHERE
    s.to_date > SYSDATE()
        AND s.from_Date = s1.from_Date;
        
        
/*
exercise 1:
Create a query that upon execution returns a result set containing the employee numbers, contract salary values, start, 
and end dates of the first ever contracts that each employee signed for the company.

To obtain the desired output, refer to the data stored in the "salaries" table.
*/        
SELECT 
    s1.emp_no, s.salary, s.from_date, s.to_date
FROM
    salaries s
        JOIN
    (SELECT 
        emp_no, Min(from_date) AS from_date
    FROM
        salaries
    GROUP BY emp_no) s1 ON s1.emp_no = s.emp_no
WHERE
s.from_Date = s1.from_Date;

-- all time average salary paid in department the employee is currently working in
-- select * from dept_emp limit 1000;
-- select
-- de2.emp_no, d.dept_name, s2.salary, avg(s2.salary) over w as avg_salary_per_department
-- from(
-- SELECT 
--     de.emp_no, de.dept_no, de.from_date, de.to_date
-- FROM
--     dept_emp de
--         JOIN
--     (SELECT 
--         emp_no, MAX(from_date) AS from_date
--     FROM
--         dept_emp
--     GROUP BY emp_no) de1 ON de1.emp_no = de.emp_no
-- WHERE
--     de.to_date > SYSDATE()
--         AND de.from_Date = de1.from_Date) de2
--         join
--        ( SELECT 
--     s1.emp_no, s.salary, s.from_date, s.to_date
-- FROM
--     salaries s
--         JOIN
--     (SELECT 
--         emp_no, MAX(from_date) AS from_date
--     FROM
--         salaries
--     GROUP BY emp_no) s1 ON s1.emp_no = s.emp_no
-- WHERE
--     s.to_date > SYSDATE()
--         AND s.from_Date = s1.from_Date)s2 on s2.emp_no = de2.emp_no
--         join
--         departments d on d.dept_no = de2.dept_no
--         group by de2.dept_no, d.dept_name
--         window w as (partition by de2.dept_no)
--         order by de2.emp_no;









