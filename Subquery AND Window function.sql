CREATE DATABASE parks_and_recreation;
USE  parks_and_recreation;

CREATE TABLE employee_demographics(
employee_id INT PRIMARY KEY,
first_name VARCHAR(20) , 
last_name VARCHAR(20) , 
age INT,
gender VARCHAR(10),
birth_date date
);
INSERT INTO employee_demographics(employee_id,first_name,last_name,age,gender,birth_date)
VALUES
(1, 'Rahul', 'Sharma', 25, 'Male', '1999-05-14'),
(2, 'Shlok', 'Singh', 24, 'Male', '2000-08-21'),
(3, 'Priya', 'Verma', 26, 'Female', '1998-03-10'),
(4, 'Amit', 'Kumar', 28, 'Male', '1996-11-02'),
(5, 'Neha', 'Gupta', 23, 'Female', '2001-07-19'),
(6, 'Rohit', 'Yadav', 27, 'Male', '1997-01-25'),
(7, 'Sneha', 'Patel', 29, 'Female', '1995-06-30'),
(8, 'Arjun', 'Mehta', 30, 'Male', '1994-09-12'),
(9, 'Pooja', 'Agarwal', 22, 'Female', '2002-12-05'),
(10, 'Karan', 'Malhotra', 31, 'Male', '1993-04-18');

CREATE TABLE employee_salary (
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    occupation VARCHAR(100),
    salary INT,
    dept_id INT
);

INSERT INTO employee_salary (employee_id, first_name, last_name, occupation, salary, dept_id) VALUES
(1, 'Leslie', 'Knope', 'Deputy Director of Parks and Recreation', 75000, 1),
(2, 'Ron', 'Swanson', 'Director of Parks and Recreation', 70000, 1),
(3, 'Tom', 'Haverford', 'Entrepreneur', 50000, 1),
(4, 'April', 'Ludgate', 'Assistant to the Director of Parks and Recreation', 25000, 1),
(5, 'Jerry', 'Gergich', 'Office Manager', 50000, 1),
(6, 'Donna', 'Meagle', 'Office Manager', 60000, 1),
(7, 'Ann', 'Perkins', 'Nurse', 55000, 4),
(8, 'Chris', 'Traeger', 'City Manager', 90000, 3),
(9, 'Ben', 'Wyatt', 'State Auditor', 70000, 6),
(10, 'Andy', 'Dwyer', 'Shoe Shiner', 20000, NULL),
(11, 'Mark', 'Brendanawicz', 'City Planner', 57000, 3);

CREATE TABLE park_departments(
department_id INT PRIMARY KEY,
department_name VARCHAR(20)
);
ALTER TABLE park_departments
MODIFY department_name VARCHAR(40);

INSERT INTO park_departments(department_id , department_name)
VALUES
(1,"Parks And Recreations"),
(2,"Animal Control"),
(3,"Public Works"),
(4,"Healthcare"),
(5,"Library"),
(6,"Finance");



SELECT * FROM employee_demographics;
SELECT * FROM employee_salary;
SELECT * FROM park_departments;


SELECT * FROM
employee_demographics 
WHERE employee_id IN
                    (SELECT employee_id FROM employee_salary
                    WHERE dept_id = 1);
                    
                    
SELECT first_name , salary ,
                          (SELECT AVG(Salary) FROM employee_salary) AS AVG_SALARY
FROM employee_salary  ;     


SELECT AVG(MAX_AGE) FROM 
              (SELECT gender, AVG(age) AS AVG_AGE , MAX(age) AS MAX_AGE , MIN(age) AS MIN_AGE, COUNT(age) AS AGE_COUNT
              FROM employee_demographics
              GROUP BY gender) AS EMP_DEM;
              
-- 1.Find employees who earn more than average salary

SELECT *
FROM employee_salary
WHERE salary> (SELECT AVG(salary) FROM employee_salary);

-- 2️.Find employee(s) with highest salary
SELECT * 
FROM employee_salary 
WHERE salary = (SELECT MAX(salary) FROM employee_salary);

-- 3️.Find employee(s) with lowest salary
SELECT * FROM
employee_salary 
WHERE salary = (SELECT MIN(salary) FROM employee_salary);

-- 4️ . Find employees working in same department as 'Leslie'
SELECT * 
from employee_salary WHERE dept_id IN (SELECT dept_id  FROM employee_salary WHERE first_name = "Leslie");

-- 5️.Find employees whose salary is greater than salary of 'Tom'
SELECT *
FROM employee_salary
WHERE salary > (SELECT salary FROM employee_salary 
                    WHERE first_name = "Tom");
                    
                
-- Find employees who belong to departments where salary > 60000 exists
SELECT *
FROM employee_salary
WHERE dept_id IN (
    SELECT dept_id
    FROM employee_salary
    WHERE salary > 60000
);

-- Find employees whose salary is equal to any salary in department 1
SELECT *
FROM employee_salary
WHERE salary IN (
    SELECT salary
    FROM employee_salary
    WHERE dept_id = 1
);

-- Find employees not in department 1

SELECT *
FROM employee_salary
WHERE dept_id NOT IN (
    SELECT dept_id
    FROM employee_salary
    WHERE dept_id = 1
);

-- Find employees with salary greater than average salary of their department
 SELECT *  
 FROM employee_salary AS e
 WHERE salary > (SELECT AVG(salary) FROM employee_salary
				 WHERE 
                 dept_id = e.dept_id) ;                  

 
 -- Find departments having more than 1 employee
 SELECT dept_id
FROM employee_salary
GROUP BY dept_id
HAVING COUNT(*) > 1;
                  
-- Find employees earning more than overall average salary
SELECT * 
FROM employee_salary
WHERE salary > (SELECT AVG(salary) from employee_salary);

-- Find employees whose salary is less than average salary
SELECT * 
FROM employee_salary
WHERE salary < (SELECT AVG(salary) FROM employee_salary);

-- Find employees who earn more than the average salary of department 1
SELECT * FROM 
employee_salary
WHERE salary >
(SELECT AVG(salary) FROM employee_salary
WHERE dept_id = 1);

-- Find employees working in departments where average salary > 60000
SELECT * 
FROM employee_salary
WHERE dept_id IN (SELECT dept_id FROM employee_salary
                      GROUP BY dept_id
                      HAVING AVG(salary) > 60000);
                      
-- Find employees whose salary is equal to maximum salary in their department
SELECT * 
FROM employee_salary AS e
WHERE salary = (SELECT MAX(salary) FROM employee_salary 
				 WHERE dept_id = e.dept_id);    
                 
-- Find employees who are NOT in the same department as 'Ron'
SELECT * 
FROM employee_salary 
WHERE dept_id NOT IN ( SELECT dept_id FROM employee_salary
                       WHERE first_name = "Ron"); 
                       
-- Find employees who earn more than at least one employee in department 1
SELECT *
FROM employee_salary 
WHERE salary >  ANY (SELECT salary FROM employee_salary
                     WHERE dept_id = 1);
                     
-- Find employees who earn more than all employees in department 1
SELECT * 
FROM employee_salary
WHERE salary > ALL(SELECT salary FROM employee_salary 
                   WHERE dept_id = 1 );     

-- Find departments where no employee has salary < 30000
SELECT DISTINCT dept_id
FROM employee_salary d
WHERE NOT EXISTS (
    SELECT 1
    FROM employee_salary
    WHERE dept_id = d.dept_id
      AND salary < 30000
); 

-- Find employees whose department has more than 2 employees
SELECT * 
FROM employee_salary
WHERE employee_id IN (SELECT dept_id FROM employee_salary
                     GROUP BY dept_id 
					 HAVING count(*) > 2);
                     
                     
                     -- BEGINNER LEVEL QUESTIONS
                     
-- Find second highest salary using subquery
SELECT salary from employee_salary 
GROUP BY salary 
LIMIT 1 offset 1;

SELECT MAX(salary)
FROM employee_salary
WHERE salary < (
    SELECT  MAX(salary)
    FROM employee_salary
);

-- Find employees whose salary is greater than average salary of their own department
SELECT * 
FROM employee_salary AS e
WHERE salary > all(
SELECT AVG(salary) FROM employee_salary
WHERE dept_id = e.dept_id);

-- Find employees whose department has at least one employee earning > 80000
SELECT *
FROM employee_salary
WHERE Salary =(SELECT salary from employee_salary
GROUP BY salary
HAVING salary > 80000);

-- Find employees who do NOT belong to any department
SELECT *
FROM employee_salary e
WHERE NOT EXISTS (
    SELECT 1
    FROM employee_salary d
    WHERE d.dept_id = e.dept_id
);

-- Find employees whose salary is among top 3 salaries
SELECT * 
FROM (
       SELECT *,
                DENSE_RANK() OVER (ORDER BY  salary DESC) AS RNK
                FROM employee_salary
) AS t
WHERE rnk <=3;

-- Find employees earning more than average salary
SELECT * 
FROM employee_salary
WHERE salary >
              (SELECT AVG(salary) FROM employee_salary);

-- Find employees earning less than average salary
SELECT * 
FROM employee_salary
WHERE salary <
                (SELECT AVG(salary) FROM employee_salary);
                
-- Find employees working in a specific department (using subquery)
SELECT * 
FROM employee_salary
WHERE employee_id IN 
                    (SELECT dept_id FROM employee_salary);
                    
-- Find employees whose salary equals maximum salary
 SELECT * 
 FROM employee_salary
 WHERE salary = 
                (SELECT MAX(salary) FROM employee_salary)    ;   
               
-- Find employees whose salary equals minimum salary
SELECT * FROM 
employee_salary
WHERE salary = 
              (SELECT MIN(salary) FROM employee_salary);
              
-- Find employees working in departments where avg salary > X
SELECT *
FROM employee_salary
WHERE dept_id IN (
    SELECT dept_id
    FROM employee_salary
    GROUP BY dept_id
    HAVING AVG(salary)  > 50000
);

-- Find employees whose department is same as 'John'
SELECT * FROM employee_salary
WHERE dept_id = 
(SELECT dept_id FROM employee_salary
WHERE first_name = "Tom");

-- Find employees NOT in the same department as 'John'
SELECT * FROM employee_salary
WHERE dept_id NOT IN 
(SELECT dept_id FROM employee_salary
WHERE first_name = "Tom");

-- Find employees with salary > ANY salary of department X
SELECT *
FROM employee_salary
WHERE salary > (
    SELECT MIN(salary)
    FROM employee_salary
    WHERE dept_id = 1
);

-- Find employees with salary > ALL salaries of department X
SELECT * 
FROM employee_salary
WHERE salary > ALL (
SELECT salary FROM employee_salary
WHERE dept_id = 1);

                          -- INTERMEDIATE LEVEL QUESTIONS

-- Find second highest salary
SELECT first_name,salary
FROM employee_salary
WHERE salary < (
    SELECT  MAX(salary)
    FROM employee_salary
);                       

-- Find Nth highest salary
SELECT * FROM 
              (
              SELECT salary ,
			                DENSE_RANK() OVER (ORDER BY salary DESC) AS RNK
              FROM employee_salary
              ) AS t
WHERE rnk = 2; 

-- Find employees whose salary is max in their department
SELECT * FROM
employee_salary AS e
WHERE salary =
               (SELECT MAX(salary) FROM employee_salary
                WHERE dept_id = e.dept_id);
                
-- Find employees whose salary is min in their department
SELECT *
FROM employee_salary AS e
WHERE salary = (
SELECT MIN(SALARY) FROM employee_salary
WHERE dept_id = e.dept_id);  

-- Find employees whose department has more than N employees
SELECT * FROM 
		     (
              SELECT *,
              COUNT(*) OVER (PARTITION BY DEPT_ID ) as rnk
FROM employee_salary) AS t
WHERE rnk = 2;  

SELECT *
FROM employee_salary
WHERE dept_id IN (
    SELECT dept_id
    FROM employee_salary
    GROUP BY dept_id
    HAVING COUNT(*) > 3
);         

-- Find departments where avg salary > X
SELECT * 
FROM employee_salary
WHERE dept_id IN 
               (SELECT dept_id FROM employee_salary  
                GROUP BY dept_id
                HAVING AVG(salary) > 5000);    
                
-- Find departments where no employee earns below X
SELECT *
FROM employee_salary
WHERE dept_id NOT IN                
                (SELECT dept_id FROM employee_salary  
                GROUP BY dept_id
                HAVING MIN(salary) < 25000);     
                
-- Find employees whose salary is greater than department average (correlated)  
SELECT * FROM 
employee_salary AS e
WHERE salary > (
                SELECT AVG(salary) FROM employee_salary
                WHERE dept_id = e.dept_id
				);
                
-- Find employees who do NOT belong to any department
SELECT * 
FROM employee_salary AS e
WHERE  NOT EXISTS
				(SELECT 1 FROM employee_salary 
				WHERE dept_id = e.dept_id);
                
                       -- ADVANCE LEVEL
-- Find top 3 salaries (using subquery)
SELECT DISTINCT salary,first_name
FROM employee_salary e1
WHERE 3 > (
    SELECT COUNT(DISTINCT salary)
    FROM employee_salary e2
    WHERE e2.salary > e1.salary
);

-- Find top N salaries per department
SELECT * FROM
             (SELECT first_name,salary,dept_id,
              DENSE_RANK() OVER (PARTITION BY dept_id ORDER BY salary DESC) AS rnk
              FROM employee_salary) AS t
WHERE rnk = 4;         

-- Find employees whose salary is among top N
SELECT *
FROM employee_salary e1
WHERE salary IN (
    SELECT DISTINCT salary
    FROM employee_salary e2
    WHERE 3 > (
        SELECT COUNT(DISTINCT salary)
        FROM employee_salary e3
        WHERE e3.salary > e2.salary
    )
); 

-- Find employees whose salary is higher than their manager


-- Find employees who have same salary as someone else
SELECT * FROM
employee_salary AS e
WHERE salary IN (
SELECT salary FROM employee_salary
GROUP BY  salary
HAVING COUNT(*) > 1
);

-- Find duplicate records using subquery
SELECT * FROM
             (SELECT *,
             COUNT(*) OVER (PARTITION BY  dept_id) AS cnt
             FROM employee_salary ) AS t
WHERE cnt >1;

                              -- WINDOW FUNCTIONS

-- Q1. Add row number to each employee
SELECT * ,
         ROW_NUMBER() OVER () AS ROW_COUNT
from employee_salary;   

-- Q2. Row number based on salary (highest first)
SELECT *,
         ROW_NUMBER() over (ORDER BY salary desc) AS highest_first
FROM employee_salary;     

-- Q3. Rank employees based on salary
SELECT *,
         RANK() OVER (ORDER BY salary DESC) AS employee_ranking
FROM employee_salary;         
              
-- Dense rank (no gaps)
SELECT *,
         DENSE_RANK() OVER (ORDER BY salary DESC) AS DENSE_ranking
FROM employee_salary;   

-- Partition by department
SELECT *,
		ROW_NUMBER() OVER (PARTITION BY dept_id ORDER BY salary DESC) AS partitionBy
FROM employee_salary;   

-- Find highest salary in each department
SELECT * FROM
             ( SELECT *,
             RANK() OVER(PARTITION BY dept_id ORDER BY salary DESC) AS salary_dept_wise
             FROM employee_salary ) AS t
WHERE salary_dept_wise = 1;   

-- Find employees whose salary is greater than department average 
SELECT * FROM 
              (SELECT *,
              AVG(salary) OVER(PARTITION BY dept_id ) AS depatment_avg
              FROM employee_salary
              ) AS t
WHERE salary > depatment_avg ;     

-- Find top 2 highest paid employees in each department
SELECT * FROM  
             (
             SELECT *,
             DENSE_RANK() OVER (PARTITION BY dept_id ORDER BY salary DESC) AS paid
             FROM employee_salary
             )         AS T
WHERE paid > 2
limit 2;     

-- Find lowest salary employee in each department
SELECT * FROM
             (
             SELECT *,
             DENSE_RANK() OVER(PARTITION BY dept_id ORDER BY salary ASC) AS low_paid
             FROM employee_salary
             )        AS T
WHERE low_paid < 2
limit 2;   

-- Assign rank to employees based on salary (no gaps allowed)
SELECT *,
       DENSE_RANK() OVER (PARTITION BY dept_id ORDER BY salary DESC) AS rnk
FROM employee_salary;

-- Find employees who have 2nd highest salary in each department
SELECT * FROM
             (
             SELECT *,
             DENSE_RANK() OVER (PARTITION BY dept_id ORDER BY salary DESC) AS second_heighest
             FROM employee_salary
             ) AS t
WHERE second_heighest = 2;           

-- Find employees whose salary rank is between 2 and 4 (globally)
SELECT * FROM
              (
              SELECT *,
              DENSE_RANK() OVER(PARTITION BY dept_id ORDER BY salary DESC) AS RNK
              FROM employee_salary
			)  AS T
WHERE RNK BETWEEN 2 AND 3;   

-- Find employees whose salary is top 3 in entire company
SELECT * FROM
             (
             SELECT *,
             DENSE_RANK() OVER( ORDER BY salary DESC) as top_three
             FROM employee_salary
             )     AS T
WHERE top_three >= 3;   

-- Find employees who are top earners but only one per department
SELECT * FROM
             (
             SELECT *,
             ROW_NUMBER() OVER(PARTITION BY dept_id ORDER BY salary DESC) AS top_earners
             FROM employee_salary
             )          AS T
WHERE top_earners > 1;   

-- Find employees with same rank within department
SELECT * FROM
             (
             SELECT *,
             DENSE_RANK() OVER(PARTITION BY dept_id ORDER BY salary DESC) ,
             COUNT(*) OVER(PARTITION BY dept_id,salary) AS RNK
             FROM employee_salary
             )          AS T
WHERE rnk >1;  

SELECT * FROM
             (
             SELECT *,
             COUNT(*) OVER(PARTITION BY dept_id,salary) AS RNK
             FROM employee_salary
             )          AS T
WHERE rnk >1;  

-- Find employees whose salary is above department average
SELECT * FROM
             (
             SELECT *,
             AVG(salary) OVER(PARTITION BY dept_id ) AS dept_avg
             FROM employee_salary
             ) AS T
WHERE salary>dept_avg;

-- Find employees whose salary is below department average
SELECT * FROM
             (
             SELECT *,
             AVG(salary) OVER(PARTITION BY dept_id ORDER BY salary DESC) AS dept_avg
             FROM employee_salary
             ) AS T
WHERE salary<dept_avg;

-- Find difference between employee salary and department average
SELECT *,
       AVG(salary) OVER (PARTITION BY dept_id) AS dept_avg,
       salary - AVG(salary) OVER (PARTITION BY dept_id) AS diff
FROM employee_salary;    

SELECT *,
ABS(salary - AVG(salary) over(partition by dept_id)) as absdiff
FROM employee_salary;   

-- Find employees whose salary is greater than overall average salary
SELECT * FROM
             (
             SELECT *,
             AVG(salary) OVER (partition by dept_id) AS AVG_SALARY
             FROM employee_salary
             )  AS T
WHERE salary > AVG_SALARY;        

-- Find percentage contribution of each employee salary in their department
SELECT *,
       SUM(salary) OVER (PARTITION BY dept_id) AS dept_total,
       (salary * 100.0 / SUM(salary) OVER (PARTITION BY dept_id)) AS pct
FROM employee_salary;     

-- Find departments where total salary is highest
SELECT *
FROM (
    SELECT dept_id, SUM(salary) AS total_salary,
           DENSE_RANK() OVER (ORDER BY SUM(salary) DESC) AS rnk
    FROM employee_salary
    GROUP BY dept_id
) t
WHERE rnk = 1;       

-- Find employees whose salary is equal to department max salary
SELECT * FROM
             (
             SELECT *,
             MAX(salary) OVER(PARTITION BY dept_id ORDER BY salary DESC) AS MAX_SALARY
             FROM employee_salary
             )     AS T
WHERE salary = MAX_SALARY;       

-- Find employees who are top 3 BUT without using DENSE_RANK
SELECT *
FROM (
    SELECT *,
           ROW_NUMBER() OVER (ORDER BY salary DESC) AS rn
    FROM employee_salary
) t
WHERE rn <= 3;      

--
 SELECT *
FROM (
    SELECT *,
           RANK() OVER (ORDER BY salary DESC) AS global_rank,
           RANK() OVER (PARTITION BY dept_id ORDER BY salary DESC) AS dept_rank
    FROM employee_salary
) t
WHERE global_rank = dept_rank;
   
-- Salary greater than at least 50% employees
SELECT *
FROM (
    SELECT *,
           PERCENT_RANK() OVER (ORDER BY salary) AS pr
    FROM employee_salary
) t
WHERE pr > 0.5;   

-- Salary in top 10% of their department
SELECT *
FROM (
    SELECT *,
           NTILE(10) OVER (PARTITION BY dept_id ORDER BY salary DESC) AS bucket
    FROM employee_salary
) t
WHERE bucket = 1;

-- Find previous salary of each employee
SELECT *,
LAG(salary) OVER(order by salary DESC) AS previous
FROM employee_salary;

-- Find next salary of each employee
SELECT *, 
		 LEAD(salary) OVER(ORDER BY  salary DESC) AS next_salary
         FROM employee_salary;
         
-- Find salary difference between current and previous employee.
SELECT *,
(salary - lag(salary) over(ORDER BY salary DESC)) AS DIFFERENCE
from employee_salary;
         
-- Find employees whose salary is greater than previous employee
SELECT * from 
			(
            SELECT * ,
            LAG(salary) OVER(PARTITION BY dept_id) AS previous_employee
            FROM employee_salary
            ) AS T
WHERE salary >previous_employee;  

-- Find employees whose salary decreased compared to previous row
SELECT * FROM
             (
             SELECT * , 
             LAG(salary) OVER(ORDER BY employee_id) AS previous_row
             FROM employee_salary
             )          AS T
WHERE salary < previous_row;   

-- Find first salary in each department
SELECT * FROM 
             (
             SELECT *,
        FIRST_VALUE(salary) OVER(PARTITION BY dept_id ORDER BY salary desc) AS FIRST_SALARY
        FROM employee_salary
        ) AS T
WHERE salary = FIRST_SALARY ;  

-- Find last salary in each department
SELECT * FROM 
             (
             SELECT *,
        LAST_VALUE(salary) OVER(PARTITION BY dept_id ORDER BY salary desc
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
        ) AS LAST_SALARY
        FROM employee_salary
        ) AS T
WHERE salary = LAST_SALARY ;   

-- Find difference between current salary and first salary in department
SELECT *,
       salary - FIRST_VALUE(salary) OVER (
           PARTITION BY dept_id 
           ORDER BY salary DESC
       ) AS difference
FROM employee_salary;  

-- Find employees who got salary jump compared to next employee
SELECT *
FROM (
    SELECT *,
           LEAD(salary) OVER (ORDER BY employee_id) AS next_salary
    FROM employee_salary
) t
WHERE salary > next_salary;  

-- Find 2nd highest salary using NTH_VALUE()
SELECT * FROM
            (
            SELECT *,
            NTH_VALUE(salary,2) OVER(ORDER BY salary DESC) AS second_highest
            FROM employee_salary
            )      AS T
WHERE salary = second_highest;   

-- Find employees whose salary is equal to department’s highest salary
SELECT * FROM 
             (SELECT * ,
             FIRST_VALUE(salary) OVER (PARTITION BY dept_id ORDER BY salary DESC) AS HIGHEST_SALARY
             FROM employee_salary
             ) AS T
WHERE salary = HIGHEST_SALARY;       

-- Find employees whose salary is equal to department’s Lowest salary    
SELECT * FROM 
             (SELECT * ,
             LAST_VALUE(salary) OVER (PARTITION BY dept_id ORDER BY salary DESC
             ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
             ) AS LOWEST_SALARY
             FROM employee_salary
             ) AS T
WHERE salary = LOWEST_SALARY;   

-- Find running comparison (increase/decrease trend)
SELECT *,
       CASE 
           WHEN salary > LAG(salary) OVER (ORDER BY employee_id) THEN 'INCREASE'
           WHEN salary < LAG(salary) OVER (ORDER BY employee_id) THEN 'DECREASE'
           ELSE 'NO CHANGE'
       END AS trend
FROM employee_salary; 

SELECT *,
       CASE 
           WHEN salary > prev_salary THEN 'INCREASE'
           WHEN salary < prev_salary THEN 'DECREASE'
           ELSE 'NO CHANGE'
       END AS trend
FROM (
    SELECT *,
           LAG(salary) OVER (PARTITION BY dept_id ORDER BY employee_id) AS prev_salary
    FROM employee_salary
) t;

-- Find employees where salary is higher than both previous AND next
SELECT *
FROM (
    SELECT *,
           LAG(salary) OVER (ORDER BY employee_id)  AS prev_salary,
           LEAD(salary) OVER (ORDER BY employee_id) AS next_salary
    FROM employee_salary
) t
WHERE salary > prev_salary
  AND salary > next_salary;
  
  
        

             

           
             
            

                       
             
             
             
  

   
        

              


                       
                     
                
         
                


             
               


              
               
                














            
                   

                       





                  
                  




              
              
              
              
              
              
              
              
              

