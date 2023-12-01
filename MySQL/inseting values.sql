-- INSERT VALUES
insert into employees
(
emp_no,
birth_date,
first_name,
last_name,
gender,
hire_date
)
VALUES(
12345678,
'1999-12-21',
'Rakshith',
'Suresh',
'M',
'2021-08-01'
);

SELECT 
    *
FROM
    employees
ORDER BY emp_no DESC
LIMIT 10;

-- Select ten records from the “titles” table to get a better idea about its content.
select * 
from titles
limit 10;

insert into employees
values(
999903,
'1997-09-14',
'Johnathon',
'Creek',
'M',
'1999-01-01'
);

-- Then, in the same table, insert information about employee number 999903. State that he/she is a “Senior Engineer”, who has started working in this position on October 1st, 1997.
insert into titles
(emp_no,title,from_date) values(
999903,
'Senior Engineer',
'1997-10-01'
);


-- At the end, sort the records from the “titles” table in descending order to check if you have successfully inserted the new record.
select * from titles
order by emp_no desc;

-- Insert information about the individual with employee number 999903 into the “dept_emp” table. He/She is working for
-- department number 5, and has started work on  October 1st, 1997; her/his contract is for an indefinite period of time.

select * from dept_emp order by emp_no desc limit 10;
insert into dept_emp
values(
999903,
'd005',
'1997-10-01',
'9999-01-01' 
);

-- creating a duplicate table and insertin data
select * from departments;
create table dep_dups(
dept_no varchar(255),
dept_name varchar(255)
);

insert into dep_dups
(select * from departments);

select * from dep_dups;
drop table dep_dups;

-- Create a new department called “Business Analysis”. Register it under number ‘d010’.
insert into departments
values(
'd010',
'Business Analysis'
);
-- checking data below
SELECT 
    *
FROM
    departments
WHERE
    dept_name = 'Business Analysis';

