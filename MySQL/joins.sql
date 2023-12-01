-- JOINS
use employees;

-- 
SELECT 
    *
FROM
    dept_manager_dup
ORDER BY dept_no;

SELECT 
    *
FROM
    dept_dups
ORDER BY dept_no;

-- inner join / join : extract dept_no, emp_no, dept_name. Inner join extract only records where values match in related columns. Null or single value in 2 columns will be ignored.
SELECT 
    m.dept_no, m.emp_no, d.dept_name
FROM
    dept_manager_dup AS m
        INNER JOIN
    dept_dups AS d ON m.dept_no = d.dept_no
ORDER BY m.dept_no;
    
-- Extract a list containing information about all managers’ employee number, first and last name, department number, and hire date.

select e.emp_no,e.first_name, e.last_name, m.dept_no, e.hire_date
from employees as e
inner join dept_manager as m
on e.emp_no = m.emp_no
order by e.emp_no;

-- duplicate rows- to remove the duplicate rows while joining, use GROUP BY amongst the column which has different values before order by as the best practice
insert into dept_manager_dup
VALUES (110228,'d003','1992-03-21','9999-01-01');

insert into dept_dups
values('d009', 'Customer Service');

-- left join/ left outer join: extracts common values from other table AND also, all the values from the left table
-- select * from dept_manager_dup order by dept_no;
-- select * from dept_dups;

SELECT 
    m.dept_no, m.emp_no, d.dept_name
FROM
    dept_manager_dup AS m
        LEFT JOIN
    dept_dups AS d ON m.dept_no = d.dept_no
    group by m.emp_no
ORDER BY m.dept_no;

/*
Join the 'employees' and the 'dept_manager' tables to return a subset of all the employees whose last name is Markovitch. 
See if the output contains a manager with that name.  

Hint: Create an output containing information corresponding to the following fields: ‘emp_no’, ‘first_name’, ‘last_name’, ‘dept_no’, ‘from_date’. 
Order by 'dept_no' descending, and then by 'emp_no'.
*/
-- select * from dept_manager;
select e.emp_no, e.first_name, e.last_name, dm.dept_no, dm.from_date
from employees e
left join dept_manager dm
on e.emp_no = dm.emp_no
where e.last_name = 'Markovitch'
order by dm.dept_no desc, e.emp_no;

-- right join/ right outer join : extracts common values from other table AND also, all the values from the right table

select e.emp_no, e.first_name, e.last_name, dm.dept_no, dm.from_date
from employees e
right join dept_manager dm
on e.emp_no = dm.emp_no
where e.last_name = 'Markovitch'
order by dm.dept_no desc, e.emp_no;

-- extract emp_no, names and salary of the employee whose salary > 145K
select e.emp_no, CONCAT(e.first_name, ' ', e.last_name) as FullName, s.salary
from employees e
join salaries s
on e.emp_no = s.emp_no
where s.salary > 145000
order by emp_no;

-- Select the first and last name, the hire date, 
-- and the job title of all employees whose first name is “Margareta” and have the last name “Markovitch”.
-- select * from titles;
select CONCAT(e.first_name, ' ', e.last_name) as FullName, t.title
from employees e
join titles t
on e.emp_no = t.emp_no
where e.first_name = 'Margareta' and e.last_name = 'Markovitch'
order by e.emp_no;

-- CROSS JOIN: it extracts all the values
-- select * from dept_manager;
-- select * from departments;
SELECT 
    dm.*, d.*
FROM
    dept_manager dm
        CROSS JOIN
    departments d
ORDER BY dm.emp_no , d.dept_no;

-- extract the same as above but don't display dept_no for the employee managing his own dept
SELECT 
    dm.*, d.*
FROM
     departments d
        CROSS JOIN
    dept_manager dm
    where d.dept_no <> dm.dept_no
ORDER BY dm.emp_no , d.dept_no;

-- with the above show the managers name and hire_date
SELECT 
    e.*, d.*
FROM
    departments d
        CROSS JOIN
    dept_manager dm
        JOIN
    employees e ON e.emp_no = dm.emp_no
WHERE
    d.dept_no <> dm.dept_no
ORDER BY dm.emp_no , d.dept_no;

-- Use a CROSS JOIN to return a list with all possible combinations between managers from the dept_manager table and department number 9.
select dm.*, d.*
from dept_manager dm
cross join departments d
where d.dept_no = 'd009'
order by dm.emp_no , d.dept_no;
-- select * from employees;
-- Return a list with the first 10 employees with all the departments they can be assigned to.
-- Hint: Don’t use LIMIT; use a WHERE clause 
select e.*, d.*
from employees e
cross join departments d
where e.emp_no < 10011
order by e.emp_no, d.dept_no;

-- joining more than 2 tables
-- extracting names,hire_date, from_date, dept_name of the managers from different tables
select e.first_name, e.last_name, e.hire_date, dm.from_date, d.dept_name
from employees e
join dept_manager dm on e.emp_no = dm.emp_no
join departments d on dm.dept_no = d.dept_no
order by d.dept_name;	

-- Select all managers’ first and last name, hire date, job title, start date, and department name.
-- select * from employees limit 1;
-- select * from titles where title='Manager' limit 1; 
-- select * from departments limit 1; 
-- select * from dept_manager limit 1;
-- select * from salaries limit 1;

select d.dept_name, t.title, e.first_name, e.last_name, e.hire_date, m.from_date as Start_Date
from employees as e
join dept_manager as m on e.emp_no = m.emp_no
join departments as d on m.dept_no = d.dept_no
join titles as t on t.emp_no = e.emp_no and t.from_date = m.from_date
order by d.dept_name;

-- obtain the name of all departments and calculate the average salary paid to each of the dept managers
-- dept_name | average_salary
select dept_name, avg(salary) as AverageSalary
from departments as d
join dept_manager as m on  m.dept_no = d.dept_no
join salaries as s on s.emp_no = m.emp_no
group by dept_name
order by AverageSalary desc;

-- How many male and how many female managers do we have in the ‘employees’ database?
select e.gender , count(gender)
from employees as e
join dept_manager as m on e.emp_no = m.emp_no
group by gender;

-- UNION and UNION ALL
drop table if exists employees_dup;
create table employees_dup(
emp_no int(11),
birth_date date,
first_name varchar(14),
last_name varchar(15),
gender enum('M','F'),
hire_date date
);
insert into employees_dup
 ( select e.* from employees e limit 20);
 
 -- inseting duplicate of first row
insert into employees_dup
 ( select e.* from employees e where emp_no = 10001);
 
 select * from employees_dup;
--  union all: combines all the data(including the duplicate row)
-- combining employees_dup and dept_manager with 5 same columns using union all(for the non common columns, creating as NULL value columns)
select e.emp_no, e.first_name, e.last_name, NULL as dept_no, NULL AS from_date
from employees_dup as e
where e.emp_no = 10001
UNION ALL
select null as emp_no, NULL as first_name, null as last_name, m.dept_no, m.from_date
from dept_manager m;

-- UNION : displays distinct row only
select e.emp_no, e.first_name, e.last_name, NULL as dept_no, NULL AS from_date
from employees_dup as e
where e.emp_no = 10001
UNION
select null as emp_no, NULL as first_name, null as last_name, m.dept_no, m.from_date
from dept_manager m;


SELECT

    *

FROM

    (SELECT

        e.emp_no,

            e.first_name,

            e.last_name,

            NULL AS dept_no,

            NULL AS from_date

    FROM

        employees e

    WHERE

        last_name = 'Denis' UNION SELECT

        NULL AS emp_no,

            NULL AS first_name,

            NULL AS last_name,

            dm.dept_no,

            dm.from_date

    FROM

        dept_manager dm) as a

ORDER BY -a.emp_no DESC;
/*
DESC is done so the output orders NON null values first. Try writing ASC instead of DESC and see how the null values output first.
The " - " sign modifies DESC and turns it into ASC for the column emp_no. Try writing "a.emp_no DESC" without the negative sign and notice how the "emp_no" column descends
*/

-- SELF JOIN

select * from emp_manager;
-- task is to extract data only of employees who are managers as well from the emp_manager table

SELECT 
    e1.*
FROM
    emp_manager e1
        JOIN
    emp_manager e2 ON e1.emp_no = e2.manager_no
WHERE
    e2.emp_no IN (SELECT 
            manager_no
        FROM
            emp_manager);
            
-- SQL Views : a virtual table  whose contents are obtained from an existing table (base tables)
-- Create a view that will extract the average salary of all managers registered in the database. Round this value to the nearest cent.
-- If you have worked correctly, after executing the view from the “Schemas” section in Workbench, you should obtain the value of 66924.27.

select * from salaries limit 10;
select * from dept_manager limit 10;

create or replace view v_avg_salary_of_managers as 
select round(avg(s.salary),2)
from salaries s
join dept_manager dm on s.emp_no = dm.emp_no;