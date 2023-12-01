use employees;
-- types of MySQL Variables
-- Local variables : created within a function and scope is limited within function

drop FUNCTION if exists f_emp_avg_salary;

DELIMITER $$
create function f_emp_avg_salary (p_emp_no integer) returns decimal(10,2)
begin
declare v_avg_salary DECIMAL(10,2); -- declare used only while creating a local variable  
begin
declare v_avg_salary_2 decimal(10,2);
end;
SELECT 
    AVG(s.salary)
INTO v_avg_salary FROM
    employees e
        JOIN
    salaries s ON e.emp_no = s.emp_no
WHERE
    e.emp_no = p_emp_no;
return v_avg_salary;
end $$
delimiter ;

select v_avg_salary;

-- session variable : created in a session, it carries to different SQL files within the same SQL Connection. Scope within the connection
-- creating session variable
set @s_var1 = 3;
select @s_var1; -- this can be used in different SQL files in the same SQL Connection

-- GLOBAL variable: it applies to all connections related to a specific server
-- setting the max connections to 100 in the server
set global max_connections = 100;

-- TRIGGERS
-- new employee promoted to manager- salary should increase by 20k than their highest salary
-- add a new record in the dept manager table
-- create trigger to apply modification to salaries table once a new entry has been added to dept_manager table
drop trigger if exists trig_ins_dept_mng;
delimiter $$
create trigger trig_ins_dept_mng
after insert on dept_manager
for each row
begin 
declare v_curr_salary int;
SELECT 
    MAX(salary)
INTO v_curr_salary FROM
    salaries
WHERE
    emp_no = New.emp_no;

if v_curr_salary is not null then
update salaries
set
to_date = sysdate()
where emp_no = new.emp_no and to_date = new.to_date;

insert into salaries
values (new.emp_no, v_curr_salary + 20000, new.from_date, new.to_date);
end if;
end $$
delimiter ;

-- inserting the new row to dept_manager
INSERT INTO dept_manager VALUES ('111534', 'd009', date_format(sysdate(), '%y-%m-%d'), '9999-01-01');

SELECT 
    *
FROM
    dept_manager
WHERE
    emp_no = 111534;
    
SELECT 
    *
FROM
    salaries
WHERE
    emp_no = 111534;


-- Create a trigger that checks if the hire date of an employee is higher than the current date. If true, set this date to be the current date. 
-- Format the output appropriately (YY-MM-DD).
drop trigger if exists check_date;
-- select * from employees limit 1;
delimiter $$
create trigger check_date
before insert on employees
for each row
begin
if new.hire_date > date_format(sysdate(), '%Y-%m-%d') then
set new.hire_date = date_format(sysdate(), '%Y-%m-%d');
end if;
end $$
delimiter ;

-- testing the trigger
INSERT employees VALUES ('999904', '1970-01-31', 'John', 'Johnson', 'M', '2025-01-01');  
select * from employees where emp_no = 999904;


-- MYSQL Indexes : increases speed of finding records we need
ALTER TABLE employees
DROP INDEX i_hire_date;

create index i_hire_date
on employees(hire_date);
SELECT 
    *
FROM
    employees
WHERE
    hire_date > '2000-01-01';

-- composite index : multiple columns
create index i_comp 
on employees(first_name , last_name);
SELECT 
    *
FROM
    employees
WHERE
    first_name = 'Georgi'
        AND last_name = 'Facello';
        
        
-- to check the indexes from table of a database
show index from departments from employees;

-- Select all records from the ‘salaries’ table of people whose salary is higher than $89,000 per annum.
-- Then, create an index on the ‘salary’ column of that table, and check if it has sped up the search of the same SELECT statement.
select * from salaries where salary > 89000;
create index i_salary on
salaries(salary);

