-- set @@global.sql_mode := replace(@@global.sql_mode, 'ONLY_FULL_GROUP_BY', '');
-- stored routines : used to store set of code which can be called at any point of time
use employees;
drop procedure if exists select_employees;
-- changing the delimiter to $$
delimiter $$
create procedure select_employees()
begin
select * from employees
limit 1000;
end $$
delimiter ;
call select_employees();

-- stored procedure with user input
drop procedure if exists emp_avg_salary;

delimiter $$
create procedure emp_avg_salary(in p_emp_no INTEGER)
begin
select e.emp_no , e.first_name, e.last_name, avg(s.salary)
from employees e join salaries s on e.emp_no = s.emp_no
where e.emp_no = p_emp_no;
end $$
delimiter ;

call emp_avg_salary(11300);

-- stored procedure with an output parameter
drop procedure if exists emp_avg_salary_out;

delimiter $$
create procedure emp_avg_salary_out(in p_emp_no INTEGER, out p_avg_salary decimal(10,2))
begin
select avg(s.salary) into p_avg_salary
from employees e join salaries s on e.emp_no = s.emp_no
where e.emp_no = p_emp_no;
end $$
delimiter ;



-- Create a procedure called ‘emp_info’ that uses as parameters the first and the last name of an individual, and returns their employee number.
drop procedure if exists emp_info;

delimiter $$
create procedure emp_info(in p_first_name varchar(255), in p_last_name  varchar(255), out p_emp_no integer)
begin
SELECT 
    e.emp_no
INTO p_emp_no FROM
    employees e
WHERE
    e.first_name = p_first_name
        AND e.last_name = p_last_name
LIMIT 1;
end $$
delimiter ;
-- select * from employees limit 2;

-- variables
-- creating a variable with value 0
set @v_avg_salary = 0;
-- calling procedure and assigning the variable with the output parameter
call employees.emp_avg_salary_out(11300, @v_avg_salary);
select @v_avg_salary;

-- Create a variable, called ‘v_emp_no’, where you will store the output of the procedure you created in the last exercise.
-- Call the same procedure, inserting the values ‘Aruna’ and ‘Journel’ as a first and last name respectively.
-- Finally, select the obtained output.

set @v_emp_no = 0;
call emp_info('Aruna', 'Journel', @v_emp_no);
SELECT @v_emp_no;

-- USER DEFINED FUNCTIONS : another stored routines
-- different syntax than the stored procedure
drop FUNCTION if exists f_emp_avg_salary;
-- SET GLOBAL log_bin_trust_function_creators = 1;


DELIMITER $$
-- no need to use in for input as it only takes only inputs and returns specifying the datatype of the returned variable
create function f_emp_avg_salary (p_emp_no integer) returns decimal(10,2)
-- if you get 1418 error then you can add (deterministic no sql reads sql data ) this after the create function line
begin
-- declaring the varibale
declare v_avg_salary DECIMAL(10,2);
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
-- selecting the function
select f_emp_avg_salary(11300);

/*
Create a function called ‘emp_info’ that takes for parameters the first and last name of an employee, 
and returns the salary from the newest contract of that employee.

Hint: In the BEGIN-END block of this program, you need to declare and
use two variables – v_max_from_date that will be of the DATE type, and v_salary, that will be of the DECIMAL (10,2) type.
Finally, select this function.
*/
drop function if exists f_emp_info;
-- select * from employees limit 1;
-- select * from salaries limit 1;
delimiter $$
create function f_emp_info(p_first_name varchar(255), p_last_name  varchar(255)) returns decimal(10,2)
begin
declare v_max_from_date date;
declare v_salary decimal(10,2);
SELECT 
    MAX(from_date)
INTO v_max_from_date FROM
    employees e
        JOIN
    salaries s ON e.emp_no = s.emp_no
WHERE
    e.first_name = p_first_name
        AND e.last_name = p_last_name;

SELECT 
    s.salary
INTO v_salary FROM
    employees e
        JOIN
    salaries s ON e.emp_no = s.emp_no
WHERE
    e.first_name = p_first_name
        AND e.last_name = p_last_name
        AND s.from_date = v_max_from_date;
        return v_salary;
 end$$
delimiter ;
-- testing the output
SELECT f_emp_info('Aruna', 'Journel') as 'Salary from the latest contract';
