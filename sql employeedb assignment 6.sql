-- Create Database
CREATE DATABASE CompanyDB;

-- Select Database
USE CompanyDB;

-- Create Table
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    EmployeeName VARCHAR(100),
    Department VARCHAR(50),
    Salary DECIMAL(10,2),
    ManagerID INT,
    HireDate DATE
);

-- View Table Structure
DESC Employees;

-- Insert Records
INSERT INTO Employees
(EmployeeID, EmployeeName, Department, Salary, ManagerID, HireDate)
VALUES
(101, 'John', 'Sales', 50000, 201, '2021-01-10'),
(102, 'Mary', 'Sales', 65000, 201, '2020-03-15'),
(103, 'David', 'HR', 55000, 202, '2022-05-20'),
(104, 'Sophia', 'HR', 70000, 202, '2019-07-18'),
(105, 'James', 'IT', 80000, 203, '2018-11-01'),
(106, 'Emma', 'IT', 75000, 203, '2021-09-25'),
(107, 'Michael', 'Finance', 90000, 204, '2017-06-12'),
(108, 'Olivia', 'Finance', 60000, 204, '2023-02-01');

-- Display All Records
SELECT * FROM Employees;
-- 1 .find employess eearning moree than avg salary
SELECT *
FROM Employees
WHERE Salary >
(
    SELECT AVG(Salary)
    FROM Employees
);
-- 2. find employees earning the highest salary
select * from employees where salary=(select max(salary) from employees);
-- 3. find employess earning the second highest salary
select max(salary) from employees where salary not in (select max(salary) from employees);
-- 4. list employess whose salary is less than max salary
select * from employees where salary < (select max(salary) from employees);
-- 5.find employess workinng in same dept as the emp with highest sal
 SELECT *
FROM Employees
WHERE Department =
(
    SELECT Department
    FROM Employees
    WHERE Salary =
    (
        SELECT MAX(Salary)
        FROM Employees
    )
);
-- 6. find dept having employes with sal greater than 70000
select distinct department from employees where department in (select department from employees where salary>70000);
-- 7. find employees whose salary is above their dept avg salary 
SELECT *
FROM Employees e1
WHERE Salary >
(
    SELECT AVG(Salary)
    FROM Employees e2
    WHERE e1.Department = e2.Department
);
-- 8. find emp who earn more than all emp in hr dept
select * from employees where salary >all(select salary from employees where department='HR');
-- 9. Find employees whose salary matches any salary in the Sales department.
SELECT *
FROM Employees
WHERE Salary = ANY
(
    SELECT Salary
    FROM Employees
    WHERE Department = 'Sales'
); 
-- 10. Find employees hired after the employee with the lowest salary.
SELECT *
FROM Employees
WHERE HireDate >
(
    SELECT HireDate
    FROM Employees
    WHERE Salary =
    (
        SELECT MIN(Salary)
        FROM Employees
    )
);
-- 11. Find the department with the highest average salary.
SELECT Department
FROM Employees
GROUP BY Department
HAVING AVG(Salary) =
(
    SELECT MAX(AvgSalary)
    FROM
    (
        SELECT AVG(Salary) AS AvgSalary
        FROM Employees
        GROUP BY Department
    ) AS Temp
);
-- 12. Find employees who earn the minimum salary in their department.
SELECT *
FROM Employees e1
WHERE Salary =
(
    SELECT MIN(Salary)
    FROM Employees e2
    WHERE e1.Department = e2.Department
);
-- 13. Display managers who manage employees earning more than 75,000.
SELECT DISTINCT ManagerID
FROM Employees
WHERE Salary > 75000;
-- 14. Find employees whose salary is greater than their manager's salary (assume managers are employees).
SELECT *
FROM Employees e1
WHERE Salary >
(
    SELECT Salary
    FROM Employees e2
    WHERE e1.ManagerID = e2.EmployeeID
);
-- 15. Find the top 3 highest paid employees using a subquery.
SELECT *
FROM Employees e1
WHERE 3 >
(
    SELECT COUNT(*)
    FROM Employees e2
    WHERE e2.Salary > e1.Salary
);
