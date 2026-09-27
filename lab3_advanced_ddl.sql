CREATE DATABASE advanced_lab;

CREATE TABLE employees (
    emp_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    department VARCHAR(50),
    salary INTEGER,
    hire_date DATE,
    status VARCHAR(20) DEFAULT 'Active'
);

CREATE TABLE departments (
    dept_id SERIAL PRIMARY KEY,
    dept_name VARCHAR(50),
    budget INTEGER,
    manager_id INTEGER
);

CREATE TABLE projects (
    project_id SERIAL PRIMARY KEY,
    project_name VARCHAR(100),
    dept_id INTEGER,
    start_date DATE,
    end_date DATE,
    budget INTEGER
);

INSERT INTO employees (first_name, last_name, department)
VALUES ('John', 'Doe', 'IT');

INSERT INTO employees (first_name, last_name, department, salary, hire_date, status)
VALUES ('Jane', 'Smith', 'HR', DEFAULT, CURRENT_DATE, DEFAULT);

INSERT INTO departments (dept_name, budget, manager_id)
VALUES 
    ('IT', 150000, 1),
    ('HR', 80000, 2),
    ('Sales', 120000, 3);

INSERT INTO employees (first_name, last_name, department, salary, hire_date)
VALUES ('Alex', 'Brown', 'Finance', 50000 * 1.1, CURRENT_DATE);

CREATE TEMP TABLE temp_employees AS
SELECT * FROM employees WHERE 1=0;

INSERT INTO temp_employees
SELECT * FROM employees WHERE department = 'IT';

UPDATE employees
SET salary = salary * 1.10;

UPDATE employees
SET status = 'Senior'
WHERE salary > 60000 AND hire_date < '2020-01-01';

UPDATE employees
SET department = CASE 
    WHEN salary > 80000 THEN 'Management'
    WHEN salary BETWEEN 50000 AND 80000 THEN 'Senior'
    ELSE 'Junior'
END;

UPDATE employees
SET department = DEFAULT
WHERE status = 'Inactive';

UPDATE departments d
SET budget = sub.avg_sal * 1.20
FROM (
    SELECT department, AVG(salary) AS avg_sal
    FROM employees
    WHERE department IS NOT NULL
    GROUP BY department
) sub
WHERE d.dept_name = sub.department;

UPDATE employees
SET salary = salary * 1.15,
    status = 'Promoted'
WHERE department = 'Sales';

DELETE FROM employees
WHERE status = 'Terminated';

DELETE FROM employees
WHERE salary < 40000 
  AND hire_date > '2023-01-01' 
  AND department IS NULL;

DELETE FROM departments
WHERE dept_id NOT IN (
    SELECT DISTINCT dept_id 
    FROM departments d
    JOIN employees e ON d.dept_name = e.department
    WHERE e.department IS NOT NULL
);

DELETE FROM projects
WHERE end_date < '2023-01-01'
RETURNING *;

INSERT INTO employees (first_name, last_name, department, salary, hire_date)
VALUES ('Michael', 'Scott', NULL, NULL, CURRENT_DATE);

UPDATE employees
SET department = 'Unassigned'
WHERE department IS NULL;

DELETE FROM employees
WHERE salary IS NULL OR department IS NULL;

INSERT INTO employees (first_name, last_name, department, salary, hire_date)
VALUES ('Pam', 'Beesly', 'Reception', 45000, CURRENT_DATE)
RETURNING emp_id, (first_name || ' ' || last_name) AS full_name;

UPDATE employees
SET salary = salary + 5000
WHERE department = 'IT'
RETURNING emp_id, (salary - 5000) AS old_salary, salary AS new_salary;

DELETE FROM employees
WHERE hire_date < '2020-01-01'
RETURNING *;

INSERT INTO employees (first_name, last_name, department, salary, hire_date)
SELECT 'Dwight', 'Schrute', 'Sales', 55000, CURRENT_DATE
WHERE NOT EXISTS (
    SELECT 1 FROM employees 
    WHERE first_name = 'Dwight' AND last_name = 'Schrute'
);

UPDATE employees e
SET salary = CASE 
    WHEN (
        SELECT budget FROM departments d WHERE d.dept_name = e.department
    ) > 100000 THEN salary * 1.10
    ELSE salary * 1.05
END
WHERE department IS NOT NULL;

INSERT INTO employees (first_name, last_name, department, salary, hire_date)
VALUES 
    ('Emp1', 'Test', 'IT', 50000, CURRENT_DATE),
    ('Emp2', 'Test', 'IT', 52000, CURRENT_DATE),
    ('Emp3', 'Test', 'HR', 48000, CURRENT_DATE),
    ('Emp4', 'Test', 'Sales', 60000, CURRENT_DATE),
    ('Emp5', 'Test', 'Sales', 62000, CURRENT_DATE);

UPDATE employees
SET salary = salary * 1.10;

CREATE TABLE employee_archive (LIKE employees INCLUDING ALL);

WITH moved_rows AS (
    DELETE FROM employees
    WHERE status = 'Inactive'
    RETURNING *
)
INSERT INTO employee_archive
SELECT * FROM moved_rows;

UPDATE projects
SET end_date = end_date + INTERVAL '30 days'
WHERE budget > 50000
  AND dept_id IN (
      SELECT d.dept_id
      FROM departments d
      JOIN employees e ON d.dept_name = e.department
      GROUP BY d.dept_id
      HAVING COUNT(e.emp_id) > 3
  );
