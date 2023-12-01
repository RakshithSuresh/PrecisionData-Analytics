-- Temporary Tables: they hold temporary results during a mysql session. But once you restart/ start a new session, all the temp tables will be gone
-- obtain a list containing the highest salary values of all female employees
drop temporary table if exists highest_f_salary;
create temporary table highest_f_salary
SELECT 
    e.emp_no, MAX(s.salary) as highest_salary
FROM
    salaries s
        JOIN
    employees e ON s.emp_no = e.emp_no AND e.gender = 'F'
group by s.emp_no
limit 10;

-- select * from highest_f_salary;
select * from highest_f_salary where emp_no between 10069 and 10169;

/*
Exercise #1:
Store the highest contract salary values of all male employees in a temporary table called male_max_salaries.
*/
drop temporary table if exists highest_m_salary;
create temporary table highest_m_salary
SELECT 
    e.emp_no, MAX(s.salary) as highest_salary
FROM
    salaries s
        JOIN
    employees e ON s.emp_no = e.emp_no AND e.gender = 'M'
group by s.emp_no;

/*
Exercise #2:

Write a query that, upon execution, allows you to check the result set contained in the male_max_salaries temporary table you 
created in the previous exercise.
*/
select * from highest_m_salary;


-- how to use join on temp tables
-- create cte and join Temp tables
with cte as (SELECT 
    e.emp_no, MAX(s.salary) as highest_salary
FROM
    salaries s
        JOIN
    employees e ON s.emp_no = e.emp_no AND e.gender = 'F'
group by s.emp_no
limit 10)
select * from highest_f_salary f1 join cte c;

-- create a temp table containing 3 datetime values 1.current date and time
-- 2. a month earlier than current date and time 3.a year later than currend date and time 
drop table if exists dates;
create temporary table dates
select
NOW() as current_Date_and_time,
date_sub(now(), interval 1 month) as month_earlier,
date_sub(now(), interval -1 year) as year_later;
select * from dates;

-- using union all (cte and temp tables)(observe the change in date and time in CTE)
with cte as (select
NOW() as current_Date_and_time,
date_sub(now(), interval 1 month) as month_earlier,
date_sub(now(), interval -1 year) as year_later)
select * from dates union all select * from cte;

/*
Create a temporary table called dates containing the following three columns:

- one displaying the current date and time,
- another one displaying two months earlier than the current date and time, and a
- third column displaying two years later than the current date and time.
*/
-- drop table if exists dates;
create temporary table dates
select
NOW() as current_Date_and_time,
date_sub(now(), interval 2 month) as 2_month_earlier,
date_sub(now(), interval -2 year) as 2_year_later;

select * from dates;

