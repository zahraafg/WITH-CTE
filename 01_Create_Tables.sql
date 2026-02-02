CREATE DATABASE IT_CompanyDB;
GO
USE IT_CompanyDB;
GO

-- 👤 Employees
CREATE TABLE Employees (
    id INT IDENTITY PRIMARY KEY,
    full_name NVARCHAR(100),
    email NVARCHAR(100),
    hire_date DATE,
    salary DECIMAL(10,2),
    department_id INT,
    position_id INT
);

-- 🏢 Departments
CREATE TABLE Departments (
    id INT IDENTITY PRIMARY KEY,
    department_name NVARCHAR(50)
);

-- 🧑‍💼 Positions
CREATE TABLE Positions (
    id INT IDENTITY PRIMARY KEY,
    position_name NVARCHAR(50)
);

-- 👥 Customers
CREATE TABLE Customers (
    id INT IDENTITY PRIMARY KEY,
    company_name NVARCHAR(100),
    country NVARCHAR(50)
);

-- 📦 Projects
CREATE TABLE Projects (
    id INT IDENTITY PRIMARY KEY,
    project_name NVARCHAR(100),
    customer_id INT,
    budget DECIMAL(12,2),
    start_date DATE,
    end_date DATE
);

-- 🔗 Employee – Project (Assignments)
CREATE TABLE Assignments (
    id INT IDENTITY PRIMARY KEY,
    employee_id INT,
    project_id INT,
    role NVARCHAR(50)
);

-- 🧾 Orders
CREATE TABLE Orders (
    id INT IDENTITY PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2)
);

-- 📑 OrderDetails
CREATE TABLE OrderDetails (
    id INT IDENTITY PRIMARY KEY,
    order_id INT,
    product_name NVARCHAR(100),
    price DECIMAL(10,2),
    quantity INT
);

-- 💰 Payments
CREATE TABLE Payments (
    id INT IDENTITY PRIMARY KEY,
    order_id INT,
    payment_date DATE,
    amount DECIMAL(10,2)
);

-- 🕒 Attendance
CREATE TABLE Attendance (
    id INT IDENTITY PRIMARY KEY,
    employee_id INT,
    work_date DATE,
    hours_worked INT
);

