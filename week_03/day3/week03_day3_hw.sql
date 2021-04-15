/*Question 1.
Are there any pay_details records lacking both a local_account_no and iban number?*/

SELECT 
	COUNT(id) AS missing_acc_iban
FROM pay_details 
WHERE local_account_no IS NULL AND iban IS NULL;

/*ANSWER: There are 0 pay_details records lacking both a local_account_no and iban number*/




/*Question 2. 
Get a table of employees first_name, last_name and country, ordered alphabetically first by country and then by last_name (put any NULLs last).*/

SELECT
	country,
	first_name,
	last_name
FROM employees 
ORDER BY country, last_name NULLS LAST;




/*Question 3.
Find the details of the top ten highest paid employees in the corporation.*/
 
SELECT *
FROM employees 
ORDER BY salary DESC NULLS LAST 
LIMIT 10;




/*Question 4.
Find the first_name, last_name and salary of the lowest paid employee in Hungary.*/

SELECT
	first_name,
	last_name,
	salary
FROM employees 
WHERE country = 'Hungary'
ORDER BY salary NULLS LAST ;




/*Question 5.
Find all the details of any employees with a ‘yahoo’ email address?*/

SELECT *
FROM employees 
WHERE email ILIKE '%yahoo%';



/*Question 6.
Obtain a count by department of the employees who started work with the corporation in 2003.*/

SELECT 
	department,
	COUNT(id) AS num_employees
FROM employees 
WHERE start_date BETWEEN '2003-01-01' AND '2003-12-31'
GROUP BY department
ORDER BY num_employees;




/*Question 7.
Obtain a table showing department, fte_hours and the number of employees in each department who work each fte_hours pattern.
Order the table alphabetically by department, and then in ascending order of fte_hours. */

SELECT 
	department, 
	fte_hours, 
	COUNT(id) AS num_employees
FROM employees 
GROUP BY department, fte_hours
ORDER BY departmentS ASC NULLS LAST, fte_hours ASC NULLS LAST;




/*Question 8.
Provide a breakdown of the numbers of employees enrolled, not enrolled, and with unknown enrollment status in the corporation pension scheme.*/

SELECT 
	pension_enrol AS pension_enrolled,
	count(id) AS num_employees
FROM employees 
GROUP BY pension_enrol ;

/*Why is the Boolean value displaying as [ ] and [v]? */





/*Question 9. 
What is the maximum salary among those employees in the ‘Engineering’ department who work 1.0 full-time equivalent hours (fte_hours)?*/

SELECT 
	MAX(salary) AS max__eng_salary
FROM employees 
WHERE department = 'Engineering' AND fte_hours = 1.0
GROUP BY fte_hours ;



/*Question 10.
Get a table of country, number of employees in that country, and the average salary of employees in that country
for any countries in which more than 30 employees are based. Order the table by average salary descending.*/

SELECT 
	country,
	COUNT(id) AS num_employees,
	ROUND(AVG(salary)) as ave_salary
FROM employees 
GROUP BY country 
HAVING COUNT(id) > 30
ORDER BY ave_salary DESC NULLS LAST;




/*Question 11.
Return a table containing each employees first_name, last_name, full-time equivalent hours (fte_hours), salary, 
and a new column effective_yearly_salary which should contain fte_hours multiplied by salary.*/

SELECT 
	first_name,
	last_name,
	fte_hours,
	salary,
	salary * fte_hours AS effective_yearly_salary
FROM employees ;




/*Question 12.
Find the first name and last name of all employees who lack a local_tax_code.*/

SELECT 
	e.first_name,
	e.last_name,
	p.local_tax_code 
FROM employees as e
LEFT JOIN pay_details as p
ON e.pay_detail_id = p.id 
WHERE p.local_tax_code IS NULL;




/*Question 13.
The expected_profit of an employee is defined as (48 * 35 * charge_cost - salary) * fte_hours, where charge_cost depends upon the team to which the employee belongs.
Get a table showing expected_profit for each employee. */

SELECT 
	e.first_name,
	e.last_name,
	e.salary,
	e.fte_hours,
	t.charge_cost, 
	(48 * 35 * CAST(t.charge_cost AS INTEGER)- e.salary) * e.fte_hours AS expected_profit
FROM employees as e
LEFT JOIN teams as t
ON e.team_id = t.id 
ORDER BY expected_profit DESC NULLS LAST;


 

/*Question 14.
Obtain a table showing any departments in which there are two or more employees lacking a stored first name. 
Order the table in descending order of the number of employees lacking a first name, and then in alphabetical order by department.*/

SELECT 
	department,
	count(id) AS num_employees
FROM employees 
WHERE first_name IS NULL
GROUP BY department 
HAVING count(id) >= 2
ORDER BY num_employees DESC, department;




/*Question 15.
[Bit Tougher] Return a table of those employee first_names shared by more than one employee, together with a count of the number of times each first_name occurs.
Omit employees without a stored first_name from the table. Order the table descending by count, and then alphabetically by first_name.*/

SELECT 
	first_name, 
	COUNT(id) AS num_employees
FROM employees 
WHERE first_name IS NOT NULL 
GROUP BY first_name 
HAVING COUNT(id) > 1
ORDER BY COUNT(id) DESC, first_name;




/*Question 16.
[Tough] Find the proportion of employees in each department who are grade 1. */

WITH dept_total_emps AS (
	SELECT 
 		department,
 		CAST(COUNT(id) AS REAL) AS num_employees
	FROM employees 
	GROUP BY department
)
SELECT 
 	e.department AS department,
 	d.num_employees AS total_employees,
 	COUNT(e.id) AS num_grade1,
 	100 * COUNT(e.id)/d.num_employees AS percentage_grade1
FROM employees as e
INNER JOIN dept_total_emps as d 
ON e.department = d.department
WHERE grade = 1
GROUP BY e.department, d.num_employees 
ORDER BY e.department;



WITH grade_1_count AS (
	 	SELECT 
			 department,
	 		COUNT(id) AS count_grade_1
	 	FROM employees
	 	WHERE grade = 1
	 	GROUP BY department
	 	),
	 department_count AS (
	 	SELECT 
	 		department,
	 		count(id) AS count_all
	 	FROM employees
	 	GROUP BY department
	 	)
SELECT 
	dc.department,
	g.count_grade_1,
	dc.count_all,
	g.count_grade_1/dc.count_all AS propn_grade_1
FROM department_count AS dc
INNER JOIN grade_1_count AS g
ON dc.department = g.department


SELECT 
 department,
 SUM(CAST(grade = 1 AS INT)) AS g1_count,
 COUNT(id) AS num_employees,
 SUM(CAST(grade = 1 AS INT))/CAST(COUNT(id) AS REAL) AS g1_propn
FROM employees 
GROUP BY department 





/* 2 Extension
Some of these problems may need you to do some online research on SQL statements we haven’t seen in the lessons up until now… 
Don’t worry, we’ll give you pointers, and it’s good practice looking up help and answers online, data analysts and programmers do this all the time!
 If you get stuck, it might also help to sketch out a rough version of the table you want on paper (the column headings and first few rows are usually enough).
Note that some of these questions may be best answered using CTEs or window functions: have a look at the optional lesson included in today’s notes!*/

/*
Question 17.
[Tough] Get a list of the id, first_name, last_name, department, salary and fte_hours of employees in the largest department. 
Add two extra columns showing the ratio of each employee’s salary to that department’s average salary, and each employee’s fte_hours to that department’s average fte_hours.*/


/* First attempt using CTEs */

WITH dept_total_emps AS (
	SELECT 
 		department,
 		COUNT(id) AS num_employees,
 		AVG(salary) AS dept_avg_salary,
 		AVG(fte_hours) AS dept_avg_hours,
 		RANK() OVER (ORDER BY COUNT(id) DESC) AS size_rank
	FROM employees 
	GROUP BY department
	ORDER BY num_employees DESC	
)
SELECT 
	e.id,
	e.first_name,
	e.last_name,
	e.department,
	e.salary,
	e.fte_hours, 
	d.dept_avg_salary,
	d.dept_avg_hours,
	e.salary/d.dept_avg_salary AS ratio_avg_sal,
	e.fte_hours/d.dept_avg_hours AS ratio_avg_hours
FROM dept_total_emps AS d
LEFT JOIN employees AS e
ON e.department = d.department
WHERE d.size_rank = 1;


/* Second attempt using window functions */

SELECT 
    first_name,
    last_name,
    department ,
    salary,
    fte_hours,
    salary / AVG(salary) OVER (PARTITION BY department) AS ratio_dept_avg_sal,
    salary / AVG(fte_hours) OVER (PARTITION BY department) AS ratio_dept_avg_fte
FROM employees 
WHERE department = (
	SELECT 
		department
	FROM employees 
	GROUP BY department 
	ORDER BY COUNT(id) DESC NULLS LAST 
	LIMIT 1);








/*[Extension - how could you generalise your query to be able to handle the fact that two or more departments may be tied in their counts of employees.
  In that case, we probably don’t want to arbitrarily return details for employees in just one of these departments]. */

/* Use DENSE_RANK */




/*Question 18.
Have a look again at your table for MVP question 8. It will likely contain a blank cell for the row relating to employees with ‘unknown’ pension enrollment status. 
This is ambiguous: it would be better if this cell contained ‘unknown’ or something similar. 
Can you find a way to do this, perhaps using a combination of COALESCE() and CAST(), or a CASE statement?*/

SELECT 
	CASE 
		WHEN pension_enrol IS NULL THEN 'Unknow'
		WHEN pension_enrol = FALSE THEN 'False'
		WHEN pension_enrol = TRUE THEN 'True'
	END pension_enrol_changed,
	count(id) AS num_employees
FROM employees 
GROUP BY pension_enrol_changed ;




/*Question 19.
Find the first name, last name, email address and start date of all the employees who are members of the ‘Equality and Diversity’ committee. Order the member employees by their length of service in the company, longest first.*/

SELECT 
	e.first_name ,
	e.last_name,
	e.email,
	e.start_date,
	c.name AS committe_name
FROM employees AS e
LEFT JOIN employees_committees AS e_c
ON  e.id = e_c.employee_id 
INNER JOIN committees AS c
ON e_c.committee_id = c.id 
WHERE c.name = 'Equality and Diversity'
ORDER BY start_date NULLS LAST ;




/*
Question 20.
[Tough!] Use a CASE() operator to group employees who are members of committees into salary_class of 'low' (salary < 40000) or 'high' (salary >= 40000).
 A NULL salary should lead to 'none' in salary_class. */


SELECT 
	e.first_name,
	e.last_name,
	salary,
	CASE 
		WHEN salary < 40000 THEN 'low'
		WHEN salary > 40000 THEN 'high'
		WHEN salary IS NULL THEN 'none'
	END salary_group,
	e_c.committee_id AS committee
FROM employees AS e
INNER JOIN employees_committees AS e_c
ON  e.id = e_c.employee_id 
;

/*Count the number of committee members in each salary_class.*/

SELECT 
	CASE 
		WHEN salary < 40000 THEN 'low'
		WHEN salary > 40000 THEN 'high'
		WHEN salary IS NULL THEN 'none'
	END salary_group,
	count(e.id) AS num_employees
FROM employees AS e
INNER JOIN employees_committees AS e_c
ON  e.id = e_c.employee_id 
GROUP BY salary_group
ORDER BY salary_group
;


/* SHOULD USE DISTINCT COUNT */












