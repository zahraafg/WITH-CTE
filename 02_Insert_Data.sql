CREATE DATABASE IT_CompanyDB;
GO
USE IT_CompanyDB;
GO

-- 🏢 Departments
INSERT INTO Departments VALUES
('Backend'),
('Frontend'),
('QA'),
('HR'),
('DevOps');

---- 🧑‍💼 Positions
INSERT INTO Positions VALUES
('Junior Developer'),
('Middle Developer'),
('Senior Developer'),
('Team Lead'),
('QA Engineer');

-- 👤 Employees
INSERT INTO Employees VALUES
('Zahra Afg', 'zahra@company.com', '2024-01-10', 1200, 1, 1),
('Ali Mammadov', 'ali@company.com', '2023-06-01', 1800, 1, 2),
('Elvin Huseynov', 'elvin@company.com', '2022-03-15', 2500, 5, 4),
('Aysel Karimova', 'aysel@company.com', '2023-09-20', 1000, 3, 5),
('Murad Aliyev', 'murad@company.com', '2021-11-05', 3000, 2, 3);

-- 👥 Customers
INSERT INTO Customers VALUES
('ABC Tech', 'Azerbaijan'),
('GlobalSoft', 'Germany'),
('FinBank', 'UK');

-- 📦 Projects
INSERT INTO Projects VALUES
('E-Government System', 1, 50000, '2024-01-01', NULL),
('Banking App', 3, 80000, '2023-05-10', '2024-02-01'),
('CRM Platform', 2, 30000, '2024-03-01', NULL);

-- 🔗 Employee – Project (Assignments)
INSERT INTO Assignments VALUES
(1, 1, 'Backend Developer'),
(2, 1, 'Backend Developer'),
(5, 3, 'Frontend Developer'),
(3, 2, 'DevOps'),
(4, 1, 'QA');

-- 🧾 Orders
INSERT INTO Orders VALUES
(1, '2024-04-01', 15000),
(2, '2024-04-05', 20000),
(3, '2024-04-10', 30000);

-- 📑 OrderDetails
INSERT INTO OrderDetails VALUES
(1, 'Software License', 5000, 3),
(1, 'Support Service', 5000, 1),
(2, 'Custom Development', 20000, 1),
(3, 'Mobile App', 30000, 1);

-- 💰 Payments
INSERT INTO Payments VALUES
(1, '2024-04-03', 15000),
(2, '2024-04-06', 15000);

-- 🕒 Attendance
INSERT INTO Attendance VALUES
(1, '2024-04-01', 8),
(1, '2024-04-02', 7),
(2, '2024-04-01', 9),
(3, '2024-04-01', 8);