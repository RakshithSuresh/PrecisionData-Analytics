/*IF NULL() and COALESCE() : They are used when null values are dispersed in your data table and 
 you would like to substitute the null values with another value.*/

use employees;
SELECT 
    *
FROM
    dept_dups
ORDER BY dept_no ASC;

-- altering table so that dept_name can take NULL Values
alter table dept_dups
change column dept_name dept_name varchar(40) null;

-- inserting 2 dept_no into table without the dept_name values
insert into dept_dups ( dept_no) values ('d010'),('d011');


/* 
The next adjustment we’ll have to make is adding a third column
called “Department manager”. It will indicate the manager of the
respective department. For now, we will leave it empty, and will add the NULL constraint. Finally, we will place it next to the
“Department name” column by typing “AFTER “Department name”.*/

alter table dept_dups
add column dept_manager varchar(100) null after dept_name;

commit;
-- IFNULL: it takes 2 parameters, 1st one for if not null and the second vice-versa
select dept_no, ifnull(dept_name, 'Department name not provided') as Dept_name
from dept_dups
order by dept_no desc;

-- coalesce : ifnull with more than 1 or 2 parameters
SELECT 
    dept_no,
    dept_name,
    COALESCE(dept_manager, dept_name, 'N/A') AS Dept_manager
FROM
    dept_dups
ORDER BY dept_no ASC;

/*
Select the department number and name from the ‘departments_dup’ table and
 add a third column where you name the department number (‘dept_no’) as ‘dept_info’. If ‘dept_no’ does not have a value, use ‘dept_name’.
*/ 
SELECT 
    dept_no,
    dept_name,
    COALESCE(dept_no, dept_name) AS dept_info
FROM
    dept_dups
ORDER BY dept_no ASC;

/*
Modify the code obtained from the previous exercise in the following way. 
Apply the IFNULL() function to the values from the first and second column, so that ‘N/A’ is displayed whenever a department number has no value, and
 ‘Department name not provided’ is shown if there is no value for ‘dept_name’.
*/
SELECT 
    IFNULL(dept_no, 'N/A') dept_no,
    IFNULL(dept_name,
            'Department name not provided') dept_name,
    COALESCE(dept_no, dept_name) AS dept_info
FROM
    dept_dups
ORDER BY dept_no ASC;

select * from dept_dups
order by dept_no asc;
-- excercise for the joins to alter some dataset
alter table dept_dups
drop column dept_manager;

alter table dept_dups
change column dept_no dept_no char(4) NULL,
change column dept_name dept_name varchar(40) NULL;

insert into dept_dups
(dept_name) values('Public Relations');

DELETE FROM dept_dups 
WHERE
    dept_no = 'd002';

CREATE TABLE dept_manager_dup (

  emp_no int(11) NOT NULL,

  dept_no char(4) NULL,

  from_date date NOT NULL,

  to_date date NULL

  );
  
  INSERT INTO dept_manager_dup

select * from dept_manager;

INSERT INTO dept_manager_dup (emp_no, from_date)

VALUES                (999904, '2017-01-01'),

                                (999905, '2017-01-01'),

                               (999906, '2017-01-01'),

                               (999907, '2017-01-01');

 

DELETE FROM dept_manager_dup 
WHERE
    dept_no = 'd001';
    
select * from dept_manager_dup;

