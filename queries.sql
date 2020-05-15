SELECT * FROM departments;

--searching for retirement eligibility
--employees born in 1952-1955
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';

--employees born in 1952
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1952-12-31';

--employees born in 1953
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1953-01-01' AND '1953-12-31';

--employees born in 1954
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1954-01-01' AND '1954-12-31';

--employees born in 1955
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1955-01-01' AND '1955-12-31';

-- Retirement eligibility
SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Number of employees retiring
SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT * FROM retirement_info;

-- Joining departments and dept_manager tables
SELECT departments.dept_name,
     dept_manager.emp_no,
     dept_manager.from_date,
     dept_manager.to_date
FROM departments
INNER JOIN dept_manager
ON departments.dept_no = dept_manager.dept_no;

-- Joining retirement_info and dept_emp tables
SELECT retirement_info.emp_no,
	retirement_info.first_name,
retirement_info.last_name,
	dept_employees.to_date
FROM retirement_info
LEFT JOIN dept_employees
ON retirement_info.emp_no = dept_employees.emp_no;

--aliases
SELECT ri.emp_no,
	ri.first_name,
ri.last_name,
	de.to_date 
FROM retirement_info as ri
LEFT JOIN dept_employees as de
ON ri.emp_no = de.emp_no;

SELECT d.dept_name,
     dm.emp_no,
     dm.from_date,
     dm.to_date
     FROM departments as d
INNER JOIN dept_manager as dm
ON d.dept_no = dm.dept_no;

--joining retirement info and dept_employee
SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
de.to_date
INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_employees as de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');

-- Employee count by department number
SELECT COUNT(ce.emp_no), de.dept_no
FROM current_emp as ce
LEFT JOIN dept_employees as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no;
ORDER BY de.dept_no;

--employee information
SELECT * FROM salaries;

SELECT * FROM salaries
ORDER BY to_date DESC;

SELECT emp_no,
	first_name,
last_name,
	gender
INTO emp_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

--all together
SELECT e.emp_no,
	e.first_name,
e.last_name,
	e.gender,
	s.salary,
	de.to_date
    INTO emp_info
FROM employees as e
INNER JOIN salaries as s
ON (e.emp_no = s.emp_no)
INNER JOIN dept_employees as de
ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
     AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
     AND (de.to_date = '9999-01-01');

--Management
-- List of managers per department
SELECT  dm.dept_no,
        d.dept_name,
        dm.emp_no,
        ce.last_name,
        ce.first_name,
        dm.from_date,
        dm.to_date
INTO manager_info
FROM dept_manager AS dm
    INNER JOIN departments AS d
        ON (dm.dept_no = d.dept_no)
    INNER JOIN current_emp AS ce
        ON (dm.emp_no = ce.emp_no);

--department retirees
SELECT ce.emp_no,
ce.first_name,
ce.last_name,
d.dept_name	
INTO dept_info
FROM current_emp as ce
INNER JOIN dept_emp AS de
ON (ce.emp_no = de.emp_no)
INNER JOIN departments AS d
ON (de.dept_no = d.dept_no);

--Last page skill drill
--new table with all departments
SELECT ce.emp_no, ce.first_name, ce.last_name, d.dept_name
INTO current_emp_dept
FROM current_emp as ce
	INNER JOIN dept_employees as de
	ON ce.emp_no = de.emp_no
	INNER JOIN departments as d
	ON de.dept_no = d.dept_no;

--Create a list of just sales department 
SELECT * 
INTO current_emp_sales
FROM current_emp_dept
WHERE dept_name = 'Sales';

SELECT *
FROM current_emp_sales;
--create list with sales and development department
SELECT *
INTO current_emp_sales_dev
FROM current_emp_dept
WHERE dept_name IN ('Sales', 'Development');


--CHALLENGE
--technical analysis 1
--getting total number of current employees by title
SELECT e.emp_no,
	e.first_name,
	e.last_name,
	s.salary,
	t.from_date,
	t.title
INTO cur_emp_title
FROM employees as e
	INNER JOIN salaries as s
	ON (e.emp_no = s.emp_no)
	INNER JOIN titles as t
	ON (e.emp_no = t.emp_no)
WHERE (t.to_date = '9999-01-01')
ORDER BY e.emp_no ASC;

SELECT COUNT(emp_no), title
INTO num_title_total
FROM cur_emp_title
GROUP BY title
ORDER BY title;

--getting retirement employees with title
SELECT e.emp_no,
	e.first_name,
	e.last_name,
	s.salary,
	s.from_date,
	de.to_date,
	t.title
INTO emp_info_title
FROM employees as e
	INNER JOIN salaries as s
	ON (e.emp_no = s.emp_no)
	INNER JOIN dept_employees as de
	ON (e.emp_no = de.emp_no)
	INNER JOIN titles as t
	ON (e.emp_no = t.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
     AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
     AND (de.to_date = '9999-01-01')
ORDER BY t.title ASC;

-- Partition the data to show only most recent title per employee
SELECT emp_no,
 first_name,
 last_name,
 salary,
 title
INTO cur_emp_info_title
FROM
 (SELECT emp_no,
 first_name,
 last_name,
 salary,
 title, ROW_NUMBER() OVER
 (PARTITION BY (emp_no)
 ORDER BY from_date DESC) rn
 FROM emp_info_title
 ) tmp WHERE rn = 1
ORDER BY emp_no;

--get counts for retirement titles
SELECT COUNT(emp_no), title
INTO num_title_retire
FROM cur_emp_info_title
GROUP BY title
ORDER BY title;

--Mentor identification
SELECT e.emp_no,
	e.first_name,
	e.last_name,
	t.title,
	t.from_date,
	t.to_date
INTO mentor_info
FROM employees as e
INNER JOIN titles as t
ON (e.emp_no = t.emp_no)
WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
     AND (t.to_date = '9999-01-01');

