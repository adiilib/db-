SELECT 
    first_name || ' ' || last_name AS full_name,
    department,
    salary
FROM employees;

SELECT DISTINCT department 
FROM employees;

SELECT 
    project_name,
    budget,
    CASE 
        WHEN budget > 150000 THEN 'Large'
        WHEN budget BETWEEN 100000 AND 150000 THEN 'Medium'
        ELSE 'Small'
    END AS budget_category
FROM projects;

SELECT 
    first_name || ' ' || last_name AS full_name,
    COALESCE(email, 'No email provided') AS email
FROM employees;

SELECT * 
FROM employees 
WHERE hire_date > '2020-01-01';

SELECT * 
FROM employees 
WHERE salary BETWEEN 60000 AND 70000;

SELECT * 
FROM employees 
WHERE last_name LIKE 'S%' OR last_name LIKE 'J%';

SELECT * 
FROM employees 
WHERE manager_id IS NOT NULL 
  AND department = 'IT';

SELECT 
    UPPER(first_name || ' ' || last_name) AS upper_full_name,
    LENGTH(last_name) AS last_name_length,
    SUBSTRING(email FROM 1 FOR 3) AS email_prefix
FROM employees;

SELECT 
    first_name || ' ' || last_name AS full_name,
    salary * 12 AS annual_salary,
    ROUND(salary / 12, 2) AS monthly_salary,
    salary * 0.10 AS raise_amount
FROM employees;

SELECT 
    FORMAT('Project: %s - Budget: $%s - Status: %s', project_name, budget, status) AS project_info
FROM projects;

SELECT 
    first_name || ' ' || last_name AS full_name,
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, hire_date)) AS years_with_company
FROM employees;

SELECT 
    department,
    ROUND(AVG(salary), 2) AS avg_salary
FROM employees
GROUP BY department;

SELECT 
    p.project_name,
    SUM(a.hours_worked) AS total_hours
FROM projects p
JOIN assignments a ON p.project_id = a.project_id
GROUP BY p.project_id, p.project_name;

SELECT 
    department,
    COUNT(*) AS employee_count
FROM employees
GROUP BY department
HAVING COUNT(*) > 1;

SELECT 
    MAX(salary) AS max_salary,
    MIN(salary) AS min_salary,
    SUM(salary) AS total_payroll
FROM employees;

SELECT employee_id, first_name || ' ' || last_name AS full_name, salary
FROM employees
WHERE salary > 65000
UNION
SELECT employee_id, first_name || ' ' || last_name AS full_name, salary
FROM employees
WHERE hire_date > '2020-01-01';

SELECT employee_id, first_name || ' ' || last_name AS full_name, department, salary
FROM employees
WHERE department = 'IT'
INTERSECT
SELECT employee_id, first_name || ' ' || last_name AS full_name, department, salary
FROM employees
WHERE salary > 65000;

SELECT employee_id, first_name || ' ' || last_name AS full_name
FROM employees
EXCEPT
SELECT e.employee_id, e.first_name || ' ' || e.last_name AS full_name
FROM employees e
JOIN assignments a ON e.employee_id = a.employee_id;

SELECT e.employee_id, e.first_name, e.last_name
FROM employees e
WHERE EXISTS (
    SELECT 1 
    FROM assignments a 
    WHERE a.employee_id = e.employee_id
);

SELECT DISTINCT e.employee_id, e.first_name, e.last_name
FROM employees e
WHERE e.employee_id IN (
    SELECT a.employee_id
    FROM assignments a
    WHERE a.project_id IN (
        SELECT p.project_id
        FROM projects p
        WHERE p.status = 'Active'
    )
);

SELECT employee_id, first_name, last_name, salary
FROM employees
WHERE salary > ANY (
    SELECT salary 
    FROM employees 
    WHERE department = 'Sales'
);

SELECT 
    e.first_name || ' ' || e.last_name AS employee_name,
    e.department,
    AVG(a.hours_worked) AS avg_hours_worked,
    DENSE_RANK() OVER (PARTITION BY e.department ORDER BY e.salary DESC) AS salary_rank
FROM employees e
LEFT JOIN assignments a ON e.employee_id = a.employee_id
GROUP BY e.employee_id, e.first_name, e.last_name, e.department, e.salary;

SELECT 
    p.project_name,
    SUM(a.hours_worked) AS total_hours,
    COUNT(DISTINCT a.employee_id) AS assigned_employees
FROM projects p
JOIN assignments a ON p.project_id = a.project_id
GROUP BY p.project_id, p.project_name
HAVING SUM(a.hours_worked) > 150;

SELECT 
    department,
    COUNT(*) AS total_employees,
    ROUND(AVG(salary), 2) AS avg_salary,
    (
        SELECT e2.first_name || ' ' || e2.last_name
        FROM employees e2
        WHERE e2.department = e1.department
        ORDER BY e2.salary DESC
        LIMIT 1
    ) AS highest_paid_employee,
    GREATEST(MAX(salary), LEAST(MIN(salary), AVG(salary))) AS greatest_salary_bound
FROM employees e1
GROUP BY department;
