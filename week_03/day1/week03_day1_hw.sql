/*1. Find all the employees who work in the ‘Human Resources’ department. */


SELECT *
FROM employees 
WHERE department = 'Human Resources';



/*2. Get the first_name, last_name, and country of the employees who work in the ‘Legal’ department. */

SELECT 
	first_name,
	last_name,
	country
FROM employees 
WHERE department = 'Legal' ;



/* 3. Count the number of employees based in Portugal. */

SELECT 
	COUNT(*) AS n_portugal
FROM employees 
WHERE country = 'Portugal'
	


/* 4. Count the number of employees based in either Portugal or Spain. */

SELECT 
	COUNT(*) AS n_portugal_spain
FROM employees 
WHERE country IN ('Portugal', 'Spain')



/5. Count the number of pay_details records lacking a local_account_no. */

SELECT 
	COUNT(*) AS missing_account_no
FROM pay_details 
WHERE local_account_no IS NULL



/* 6. Get a table with employees first_name and last_name ordered alphabetically by last_name (put any NULLs last). */

SELECT 
	first_name,
	last_name
FROM employees 
ORDER BY last_name NULLS LAST;



/* 7. How many employees have a first_name beginning with ‘F’? */

SELECT 
	COUNT(*) AS starts_with_f
FROM employees 
WHERE first_name LIKE 'F%';



/* 8. Count the number of pension enrolled employees not based in either France or Germany. */

SELECT 
	COUNT(*) AS num_in_pension
FROM employees 
WHERE pension_enrol = TRUE 
	AND country NOT IN ('France', 'Germany');


/* EXTENSION */

/* 9.The corporation wants to make name badges for a forthcoming conference. 
 	Return a column badge_label showing employees’ first_name and last_name
 	joined together with their department in the following style: ‘Bob Smith - Legal’. 
 	Restrict output to only those employees with stored first_name, last_name and department.*/

SELECT 
	CONCAT(first_name,
			' ',
			last_name,
			' - ',
			department)
		AS badge_label
FROM employees 
WHERE first_name IS NOT NULL
	AND last_name IS NOT NULL
	AND department IS NOT NULL
	AND start_date IS NOT NULL;



/* 10 One of the conference organisers thinks it would be nice to add the year of the employees’ start_date
  to the badge_label to celebrate long-standing colleagues, in the following style ‘Bob Smith - Legal (joined 1998)’.
   Further restrict output to only those employees with a stored start_date. 

[If you’re really keen - try adding the month as a string: ‘Bob Smith - Legal (joined July 1998)’] */

SELECT 
	CONCAT(first_name,
			' ',
			last_name,
			' - ',
			department,
			' (joined ',
			TO_CHAR(start_date, 'Mon YYYY'),
			')') 
		AS badge_label
FROM employees 
WHERE first_name IS NOT NULL
	AND last_name IS NOT NULL
	AND department IS NOT NULL;









