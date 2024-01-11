-- Drop tables if they exist
DROP TABLE IF EXISTS dept_emp;
DROP TABLE IF EXISTS dept_manager;
DROP TABLE IF EXISTS salaries;
DROP TABLE IF EXISTS titles;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS departments;

-- Create tables
CREATE TABLE departments (
    dept_no VARCHAR(30) NOT NULL PRIMARY KEY,
    dept_name VARCHAR(30) NOT NULL
);

CREATE TABLE titles (
    title_id VARCHAR(30) NOT NULL PRIMARY KEY,
    title VARCHAR(30) NOT NULL
);

CREATE TABLE employees (
    emp_no INT NOT NULL PRIMARY KEY,
    emp_title_id VARCHAR(30) NOT NULL,
    birth_date VARCHAR(30) NOT NULL,
    first_name VARCHAR(30),
    last_name VARCHAR(30),
    sex VARCHAR(30),
    hire_date VARCHAR(30),
	FOREIGN KEY (emp_title_id) REFERENCES titles(title_id)
);

CREATE TABLE dept_emp (
    emp_no INT NOT NULL,
    dept_no VARCHAR(30) NOT NULL,
    FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
    FOREIGN KEY (dept_no) REFERENCES departments(dept_no)
);

CREATE TABLE dept_manager (
    dept_no VARCHAR(30) NOT NULL,
    emp_no INT NOT NULL,
    FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
    FOREIGN KEY (dept_no) REFERENCES departments(dept_no)
);

CREATE TABLE salaries (
    emp_no INT NOT NULL,
    salary INT NOT NULL,
    FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
);

--Analysis1
--List the employee number, last name, first name, sex, and salary of each employee.
SELECT
    employees.emp_no,
    employees.last_name,
    employees.first_name,
    employees.sex,
    salaries.salary
FROM
    employees
JOIN
    salaries ON employees.emp_no = salaries.emp_no;
	
--Analysis2
--List the first name, last name, and hire date for the employees who were hired in 1986.
SELECT
    first_name,
    last_name,
    hire_date
FROM
    employees
WHERE
    EXTRACT(YEAR FROM TO_DATE(hire_date, 'MM/DD/YYYY')) = 1986;
	
--Analysis3
--List the manager of each department along with their department number, 
--department name, employee number, last name, and first name.
SELECT
    dept_manager.dept_no AS department_number,
    departments.dept_name AS department_name,
    dept_manager.emp_no AS manager_employee_number,
    employees.last_name AS manager_last_name,
    employees.first_name AS manager_first_name
FROM
    dept_manager
JOIN
    departments ON dept_manager.dept_no = departments.dept_no
JOIN
    employees ON dept_manager.emp_no = employees.emp_no;
	
--Analysis4
--List the department number for each employee along with that 
--employee’s employee number, last name, first name, and department name.
SELECT
    dept_emp.dept_no AS department_number,
    employees.emp_no AS employee_number,
    employees.last_name,
    employees.first_name,
    departments.dept_name AS department_name
FROM
    dept_emp
JOIN
    employees ON dept_emp.emp_no = employees.emp_no
JOIN
    departments ON dept_emp.dept_no = departments.dept_no;

--Analysys5
--List first name, last name, and sex of each employee whose 
--first name is Hercules and whose last name begins with the letter B.
SELECT
    first_name,
    last_name,
    sex
FROM
    employees
WHERE
    first_name = 'Hercules' AND last_name LIKE 'B%';
	
--Analysis6
--List each employee in the Sales department, including 
--their employee number, last name, and first name
SELECT
    employees.emp_no AS employee_number,
    employees.last_name,
    employees.first_name
FROM
    employees
JOIN
    dept_emp ON employees.emp_no = dept_emp.emp_no
JOIN
    departments ON dept_emp.dept_no = departments.dept_no
WHERE
    departments.dept_name = 'Sales';
	
--Analysis7
--List each employee in the Sales and Development departments, 
--including their employee number, last name, first name, and department name.
SELECT
    employees.emp_no AS employee_number,
    employees.last_name,
    employees.first_name,
    departments.dept_name AS department_name
FROM
    employees
JOIN
    dept_emp ON employees.emp_no = dept_emp.emp_no
JOIN
    departments ON dept_emp.dept_no = departments.dept_no
WHERE
    departments.dept_name IN ('Sales', 'Development');
	
--Analysis8
-- List the frequency counts, in descending order, of all 
--the employee last names (that is, how many employees share each last name).
SELECT
    last_name,
    COUNT(*) AS name_count
FROM
    employees
GROUP BY
    last_name
ORDER BY
    name_count DESC, last_name;