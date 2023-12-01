-- DELETE STATEMENT
SELECT 
    *
FROM
    employees;
commit;

SELECT 
    *
FROM
    employees
WHERE
    emp_no = 999903;

DELETE FROM employees 
WHERE
    emp_no = 999903;
    
 rollback;

-- Remove the department number 10 record from the “departments” table.
delete from departments
where dept_no = 'd010';

select * from departments
order by dept_no;

rollback;

-- DROP, TRUNCATE and DELETE
-- DROP : deletes permanently, won't recover
-- TRUNCATE : its delete without where, but structure will remain intact, auto-increment values will be resetd
-- DELETE : auto-increment doesn't apply
