# Pewlett-Hackard-Analysis

## Challenge Technical Report
#### Problem
Pewlett-Hackard is preparing for a time of transition where they will have many employees retiring. While they had tracked a few different metrics on their employees, they did not have a unified database for this information which made it difficult to robustly prepare for this. The goal of this was to create a linked database with employee information to allow robust query of the data. Ultimately, we need to identify who in the company is getting close to retirement and what positions/departments they are coming from so we know who we will need to replace in the coming years. Further, we want to identify a second wave of employees with significant experience but who aren't yet retiring who may be able to serve as mentors for the influx of new employyes.

#### Steps to address
To address this problem, I had to create a robust database for employee tracking. I began by making an [Entity Relatioship Diagram (ERD)](EmployeeDB.png) which documented the data structures that we have access to and demonstrated how this data is related. I then created a [database](schema.sql) and uploaded the data into PostgreSQL. Once uploaded in here, I could use SQL to specifically query this data in ways that would return data relevant to our needs. For example, I could pull employees based on their birth and hire date (ones we think are likely to retire) using:

SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

I can also join data from mutiple data tables together in ways such as this:
SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
de.to_date
INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_employees as de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');

Further examples of the queries used can be found [here.](queries.sql) The biggest challenge in this analysis was filtering out duplicates in the data for employees who held more than one position or were in more than one department. This was ultimately achieved with partitioning.

#### Results
To get a sense of the scope, I first made a table showing the breakdown of numbers of current employees in the company [by position title.](Queries/Challenge/num_title_total.csv) Then I made an analagous table but filtered for people who may be close to retirement to get a sense of [those numbers.](Queries/Challenge/num_title_retire.csv) As can be seen from those tables, most titles can expect about 7-15% of the employees with that title to retire. This information should be very valuable for management to project which positions and how many people should be hired going forward. To drill into specifics, I also generated a table with each employee and their listed who may be retiring [here.](Queries/Challenge/cur_emp_info_title.csv) This specific list can be distributed to managers to begin preparing for individual situations. Finally, to prepare for this significant influx of new employees, I generated a [table](Queries/Challenge/mentor_info.csv) of employees and their titles who would be eligible for a mentorship program to mentor the new employees. This list should be given to managers and will be very helpful in making a plan for how to bring new employees up to speed quickly. Future analysis could be done such as grouping on both department and title since employees with the same title but in different departments may perform different functions.
