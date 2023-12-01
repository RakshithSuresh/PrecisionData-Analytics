-- UPDATE STATEMENT
UPDATE employees 
SET 
    first_name = 'John',
    last_name = 'Smith',
    birth_date = '1969-06-09'
WHERE
    emp_no = 987456123;

SELECT 
    *
FROM
    employees
WHERE
    emp_no = 987456123;

-- creating department duplicate table
-- select * from departments;
CREATE TABLE dept_dups (
    dept_no VARCHAR(255),
    dept_name CHAR(150)
);

-- copying the data from original to dups
insert into dept_dups
(
select * from departments
);

SELECT 
    *
FROM
    dept_dups
ORDER BY dept_no;

commit;/* commit used after the select statement above, so it will be saved as we see on that output*/

UPDATE departments
SET 
    dept_no = 'd01',
    dept_name = 'Quality Testing';

-- the above happened by mistake so if we run the rollback now, the saved data from the last commit will be recovered
rollback;
commit;

-- Change the “Business Analysis” department name to “Data Analysis”.
select * from departments;
UPDATE departments 
SET 
    dept_name = 'Data Analysis'
WHERE
    dept_no = 'd010';

