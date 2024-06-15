SELECT gender,AVG(age),MAX(age),MIN(age),COUNT(age)
FROM Parks_and_Recreation.employee_demographics
GROUP BY gender;

SELECT * 
FROM Parks_and_Recreation.employee_demographics
ORDER BY age DESC
LIMIT 5,1;

SELECT occupation,avg(salary) AS avg_salary
FROM Parks_and_Recreation.employee_salary
WHERE occupation LIKE "%manager%"
GROUP BY occupation
HAVING avg_salary>25000;

SELECT *
FROM Parks_and_Recreation.employee_salary
ORDER BY salary DESC
LIMIT 2,1;

-- --JOINS--

SELECT 
dem.employee_id,
dem.first_name,
dem.last_name,
dem.gender,
sal.occupation,
sal.salary,
dep.department_name
FROM Parks_and_Recreation.employee_demographics dem
LEFT JOIN Parks_and_Recreation.employee_salary sal
	ON dem.employee_id=sal.employee_id
INNER JOIN Parks_and_Recreation.parks_departments dep
	ON sal.dept_id=dep.department_id;
    
SELECT first_name, last_name,"Old" as Label
FROM Parks_and_Recreation.employee_demographics dem
WHERE age > 50
UNION ALL
SELECT first_name,last_name, "rich" as label
FROM Parks_and_Recreation.employee_salary
WHERE salary > 75000;

SELECT ("  raman  ") as name;
SELECT rtrim("  raman  ") as name;

SELECT first_name, LENGTH(first_name) AS Name
FROM Parks_and_Recreation.employee_demographics
WHERE LENGTH(first_name) >5;

SELECT 
first_name, 
LEFT(first_name,4) AS Name,
RIGHT(first_name,4) AS Rname,
SUBSTRING(first_name,3,2) AS sub,
replace(first_name,"es","sa") as rep,
locate("er",first_name) as loc,
concat (first_name," ",last_name) as FullName
FROM Parks_and_Recreation.employee_demographics;


SELECT first_name,last_name,
CASE
	WHEN age between 30 AND 50 THEN "old"
    WHEN age <=30 THEN "young"
    WHEN age >50 THEN "you are done"
END AS age_bracket
FROM Parks_and_Recreation.employee_demographics;

SELECT first_name,last_name,salary,
CASE
	WHEN salary > 50000 THEN salary *1.05
    WHEN salary >70000 THEN salary * 1.07
END AS salary_bracket,
CASE
   WHEN dept_id=6 THEN salary * 0.10
END AS BONUS
FROM Parks_and_Recreation.employee_salary;

SELECT avg(Max_age)
FROM (
SELECT 
AVG(age) AS Avg_age, 
MAX(age) AS Max_age, 
MIN(age) AS Min_age 
FROM Parks_and_Recreation.employee_demographics
GROUP BY gender) AS agg_table;

SELECT first_name,last_name,employee_id
FROM Parks_and_Recreation.employee_demographics 
WHERE employee_id IN (
SELECT employee_id
FROM Parks_and_Recreation.employee_salary
WHERE dept_id=1);

SELECT dem.first_name,dem.last_name,salary,SUM(salary) OVER(partition by gender order by dem.employee_id) As rolling_salary
FROM Parks_and_Recreation.employee_demographics AS dem
JOIN Parks_and_Recreation.employee_salary AS sal
ON dem.employee_id=sal.employee_id;

SELECT dem.first_name,dem.last_name,gender,salary,
row_number() OVER(partition by gender ORDER BY salary DESC) As row_num,
rank() OVER(partition by gender ORDER BY salary DESC) As rank_num,
dense_rank() OVER(partition by gender ORDER BY salary DESC) As dense_rank_num
FROM Parks_and_Recreation.employee_demographics AS dem
JOIN Parks_and_Recreation.employee_salary AS sal
	ON dem.employee_id=sal.employee_id;
    
WITH CTE_example AS
(
SELECT 
gender,
AVG(salary) AS Avg_salary, 
MAX(salary) AS Max_salary, 
MIN(salary) AS Min_salary,
COUNT(salary) AS salaryCount
FROM Parks_and_Recreation.employee_demographics AS dem
JOIN Parks_and_Recreation.employee_salary AS sal
ON dem.employee_id=sal.employee_id
GROUP BY gender) 
SELECT AVG(Avg_salary)
FROM CTE_example;

WITH CTE_Example1 AS
(
SELECT employee_id,gender,birth_date
FROM employee_demographics
WHERE birth_date > '1985-01-01'
),
CTE_Example2 AS 
(
SELECT employee_id,salary
FROM employee_salary
WHERE salary > 50000
)
SELECT *
FROM CTE_Example1
JOIN CTE_Example2
	ON CTE_Example1.employee_id=CTE_Example2.employee_id;
    
CREATE temporary table salary_over_50k
SELECT * FROM employee_salary
WHERE salary > 50000;

SELECT * FROM salary_over_50k;

DELIMITER $$
CREATE procedure large_salaries()
BEGIN
  SELECT first_name,last_name,salary
  FROM employee_salary
  WHERE salary >= 50000;
END $$
DELIMITER $$

CALL large_salaries();
CALL new_procedure;

DELIMITER $$
CREATE procedure salaries1(p_employee_id INT)
BEGIN
  SELECT first_name,last_name,salary
  FROM employee_salary
  WHERE employee_id=p_employee_id;
END $$
DELIMITER ;

CALL salaries1(1);

DELIMITER $$
CREATE EVENT delete_retirees
ON SCHEDULE EVERY 30 SECOND
DO
BEGIN
  DELETE 
  FROM employee_demographics
  WHERE age >60;
END $$
DELIMITER ;

SELECT * FROM employee_demographics;

DELIMITER $$
CREATE TRIGGER employee_insert
		AFTER INSERT ON employee_salary
        FOR EACH ROW
 BEGIN
 INSERT INTO employee_demographics(employee_id, first_name,last_name)
 VALUES(NEW.employee_id,NEW.first_name,NEW.last_name);
 END $$
 DELIMITER ;
 
 INSERT INTO employee_salary(employee_id,first_name,last_name,occupation,salary,dept_id)
 VALUES (13,"Rosie","HALL","Manager", 65000,6);
 
 SELECT * FROM employee_demographics;






