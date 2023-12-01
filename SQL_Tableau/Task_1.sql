use employees_mod;
-- number of male and female employees working in each year from 1990
SELECT 
    YEAR(de.from_date) AS calendar_year,
    e.gender,
    COUNT(de.emp_no) AS num_of_employees
FROM
    t_employees e
        JOIN
    t_dept_emp de ON e.emp_no = de.emp_no
GROUP BY calendar_year , e.gender
HAVING calendar_year >= 1990
ORDER BY calendar_year;