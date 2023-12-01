-- CTE - common table expressions
-- find the female employees whose salary is 
with cte AS(
select avg(salary) as Avg_salary from salaries)
SELECT 
-- taking the total sum of females whose avg salary is higher than the company avg
    sum(case
    when s.salary > c.Avg_salary then 1
    else 0 end) as no_f_salaries_abv_avg,
    -- counting total no. of female employee salaries
    count(s.salary) as total_no_f_salaries
FROM
    salaries s
        JOIN
        employees e on e.emp_no = s.emp_no and e.gender = 'F'
        cross join
        cte c;
        
 /*
Exercise #1:

Use a CTE (a Common Table Expression) and a SUM() function in the SELECT statement in a query to find out how many male employees 
have never signed a contract with a salary value higher than or equal to the all-time company salary average.
 */
 with cte AS(
select avg(salary) as Avg_salary from salaries)
SELECT 
-- taking the total sum of males whose avg salary is higher than the company avg
    sum(case
    when s.salary < c.Avg_salary then 1
    else 0 end) as no_m_salaries_below_avg,
    -- counting total no. of female employee salaries
    count(s.salary) as total_no_m_salaries
FROM
    salaries s
        JOIN
        employees e on e.emp_no = s.emp_no and e.gender = 'M'
        cross join
        cte c;
        
/*
Exercise #2:
do same thing but not with CTE but just joins
*/
SELECT 
    SUM(CASE
        WHEN s.salary < a.avg_salary THEN 1
        ELSE 0
    END) AS no_m_below_avg,
    COUNT(s.salary) AS total_no_m_salaries
FROM
    (SELECT 
        AVG(salary) AS avg_salary
    FROM
        salaries s) a
        JOIN
    salaries s
        JOIN
    employees e ON s.emp_no = e.emp_no AND e.gender = 'M';

/*
Exercise #4:

Use a cross join in a query to find out how many male employees have never signed a contract with a salary value higher than or equal to the all-time company salary average (i.e. to obtain the same result as in the previous exercise).
*/
WITH cte AS (

SELECT AVG(salary) AS avg_salary FROM salaries

)

SELECT 
    SUM(CASE
        WHEN s.salary < c.avg_salary THEN 1
        ELSE 0
    END) AS no_salaries_below_avg_w_sum,
    COUNT(s.salary) AS no_of_salary_contracts
FROM
    salaries s
        JOIN
    employees e ON s.emp_no = e.emp_no AND e.gender = 'M'
        CROSS JOIN
    cte c;
    
    
-- using multiple subclauses in a with clause
-- no. of female employees whose highest ever salary is more than the company avg salary
with cte as (SELECT avg(salary) as avg_salary from salaries),
cte2 as 
(select s.emp_no, max(salary) as max_f_Salary
from salaries s 
join employees e on e.emp_no = s.emp_no and gender = 'F'
group by s.emp_no 
)
select sum(case when c2.max_f_salary > c1.avg_salary then 1 else 0 end)  as highest_f_sal_abv_avg,
-- count(case when c2.max_f_salary > c1.avg_salary then c2.max_f_salary else null end)
count(e.emp_no) as total_no_f_salary
from employees e
join cte2 c2 on c2.emp_no = e.emp_no
cross join cte c1;

-- Percentage
with cte_avg_salary as (SELECT avg(salary) as avg_salary from salaries),
cte_highest_salary as 
(select s.emp_no, max(salary) as max_f_Salary
from salaries s 
join employees e on e.emp_no = s.emp_no and gender = 'F'
group by s.emp_no 
)
select sum(case when c2.max_f_salary > c1.avg_salary then 1 else 0 end) as highest_f_sal_abv_avg,
count(e.emp_no) as total_no_salary,
concat(round((sum(case when c2.max_f_salary > c1.avg_salary then 1 else 0 end)/COUNT(e.emp_no))*100,2),'%') as '% percentage'
from employees e
join cte_highest_salary c2 on c2.emp_no = e.emp_no
cross join cte_avg_salary c1;

/*
Exercise #1:
Use two common table expressions and a SUM() function in the SELECT statement of a query to obtain the number of male employees whose 
highest salaries have been below the all-time average.
*/
with cte_avg_salary as (select avg(Salary) as avg_salary from salaries),
cte_highest_salary as(
select s.emp_no, max(s.Salary) as max_m_salary
from salaries s
join employees e on s.emp_no = e.emp_no
and e.gender = 'M'
group by s.emp_no)
select sum(case when c2.max_m_salary < c1.avg_salary then 1 else 0 end) as highest_m_sal_bel_avg,
count(e.emp_no) as total_no_salary
from employees e
join cte_highest_salary c2 on e.emp_no = c2.emp_no
cross join cte_avg_salary c1;

/*
Exercise #2:
Use two common table expressions and a COUNT() function in the SELECT statement of a query to obtain the number of male employees whose
 highest salaries have been below the all-time average.
*/
with cte_avg_salary as (select avg(Salary) as avg_salary from salaries),
cte_highest_salary as(
select s.emp_no, max(s.Salary) as max_m_salary
from salaries s
join employees e on s.emp_no = e.emp_no
and e.gender = 'M'
group by s.emp_no)
select count(case when c2.max_m_salary < c1.avg_salary then c2.max_m_salary else null end) as highest_m_sal_bel_avg,
count(e.emp_no) as total_no_salary
from employees e
join cte_highest_salary c2 on e.emp_no = c2.emp_no
cross join cte_avg_salary c1;

-- retrieve the highest contact salary values of all employees hired in 2000 or later
with emp_hired_after_2000 as (select * from employees where hire_date > '2000-01-01'),
highest_salary as (Select e.emp_no, max(s.salary) from salaries s join emp_hired_after_2000 e on s.emp_no = e.emp_no group by e.emp_no order by e.emp_no)
select * from highest_salary;
-- jist is that we can only refer to previous CTEs,  vice versa is not possible