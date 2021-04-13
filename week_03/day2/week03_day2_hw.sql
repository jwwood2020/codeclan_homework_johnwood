MVP

/*Question 1.
(a). Find the first name, last name and team name of employees who are members of teams.*/

SELECT
	e.first_name AS first_name,
	e.last_name AS last_name, 
	t.name AS team_name
FROM employees AS e
INNER JOIN teams AS t
ON e.team_id = t.id



/* (b) Find the first name, last name and team name of employees who are members of teams and are enrolled in the pension scheme. */

SELECT 
	e.first_name AS first_name,
	e.last_name AS last_name, 
	t.name AS team_name
FROM employees AS e
INNER JOIN teams AS t
ON e.team_id = t.id
WHERE pension_enrol = TRUE



/* c). Find the first name, last name and team name of employees who are members of teams,
 	   where their team has a charge cost greater than 80. */

SELECT 
	e.first_name AS first_name,
	e.last_name AS last_name, 
	t.name AS team_name,
	t.charge_cost AS charge_cost
FROM employees AS e
INNER JOIN teams AS t
ON e.team_id = t.id
WHERE CAST(t.charge_cost AS INTEGER) >= '80';




/* Question 2.
(a). Get a table of all employees details, together with their local_account_no and local_sort_code, if they have them */

SELECT 
	e.*,
	p.local_account_no AS local_account_no,
	p.local_sort_code AS local_sort_code
FROM employees AS e
LEFT JOIN pay_details AS p
ON e.pay_detail_id = p.id 




/* (b). Amend your query above to also return the name of the team that each employee belongs to. */

SELECT 
	e.*,
	p.local_account_no AS local_account_no,
	p.local_sort_code AS local_sort_code,
	t.name AS team_name
FROM employees AS e
LEFT JOIN pay_details AS p
ON e.pay_detail_id = p.id 
LEFT JOIN teams AS t
ON e.team_id = t.id;




/*Question 3.
(a). Make a table, which has each employee id along with the team that employee belongs to. */

SELECT 
	e.id AS employee_id,
	t.name AS team_name
FROM employees AS e
LEFT JOIN teams AS t
ON e.team_id = t.id ;




/*(b). Breakdown the number of employees in each of the teams.  */


SELECT 
	t.name AS team_name,
	COUNT(e.id) AS num_employees
FROM employees AS e
LEFT JOIN teams AS t
ON e.team_id = t.id
GROUP BY t.name;




/*(c) Order the table above by so that the teams with the least employees come first.  */

SELECT 
	t.name AS team_name,
	COUNT(e.id) AS num_employees
FROM employees AS e
LEFT JOIN teams AS t
ON e.team_id = t.id
GROUP BY t.name
ORDER BY num_employees ASC;



/*Question 4.
(a). Create a table with the team id, team name and the count of the number of employees in each team.*/

SELECT 
	t.id AS team_ID,
	t.name AS team_name,
	COUNT(e.id) AS num_employees
FROM teams AS t
LEFT JOIN employees AS e
ON t.id = e.team_id
GROUP BY(t.id, t.name)
ORDER BY team_id ;



/* (b). The total_day_charge of a team is defined as the charge_cost of the team multiplied by the number of employees in the team. 
Calculate the total_day_charge for each team. */

SELECT 
	t.id AS team_ID,
	t.name AS team_name,
	SUM(CAST(t.charge_cost AS INTEGER)) AS total_day_charge
FROM teams AS t
LEFT JOIN employees AS e
ON t.id = e.team_id
GROUP BY(t.id)
ORDER BY team_id ;


SELECT 
	t.id AS team_ID,
	t.name AS team_name,
	CAST(t.charge_cost AS INTEGER) * COUNT(e.id) AS total_day_charge
FROM teams AS t
LEFT JOIN employees AS e
ON t.id = e.team_id
GROUP BY(t.id)
ORDER BY team_id ;


/* (/c). How would you amend your query from above to show only those teams with a total_day_charge greater than 5000? */

SELECT 
	t.id AS team_ID,
	t.name AS team_name,
	SUM(CAST(t.charge_cost AS INTEGER)) AS total_day_charge
FROM teams AS t
LEFT JOIN employees AS e
ON t.id = e.team_id
GROUP BY(t.id)
HAVING SUM(CAST(t.charge_cost AS INTEGER)) > 5000
ORDER BY total_day_charge ;




/*2 Extension


Question 5.
How many of the employees serve on one or more committees?*/


SELECT 
	employee_id, 
	COUNT(id) AS num_committees
FROM employees_committees 
GROUP BY employee_id 
HAVING COUNT(id) > 1;
	



/* Question 6.
How many of the employees do not serve on a committee? */

SELECT 
	COUNT(e.id) AS num_employees
FROM employees AS e
LEFT JOIN employees_committees AS e_c
ON e.id = e_c.employee_id 
WHERE e_c.employee_id IS NULL;










