USE IT_CompanyDB;

-- WITH-CTE_Practice


/* Sual 1

WITH ilə salary > 4000 olan işçiləri seç və əsas SELECT-də göstər. */

with sub as (
	select full_name, salary
	from Employees 
	where salary > 4000
	)
select *
from sub;

 --OR
with sub as (
	select id, salary
	from Employees 
	where salary > 4000
	)
select full_name, s.salary
from Employees e
join sub s
on e.id = s.id;


/* Sual 2

WITH ilə son 2 ildə işə girən işçiləri çıxar, sonra onların ad və hire_date-ni göstər. */

with sub as (
	select full_name, hire_date
	from Employees
	where hire_date >= DATEADD(YEAR, -2, GETDATE())
	)
select full_name, hire_date
from sub;


/* Sual 3

WITH ilə hər department üzrə işçi sayını hesabla, sonra nəticəni göstər. */

with sub as (
	select department_id, COUNT(*) as count_emp
	from Employees
	group by department_id
	)
select s.department_id, full_name, count_emp
from Employees e
join sub s
on s.department_id = e.department_id;


/* Sual 4

WITH ilə average salary hesabla, sonra ortalamadan çox maaş alan işçiləri seç. */

with sub as (
	select department_id, AVG(salary) as avg_salary
	from Employees
	group by department_id
	)
select s.department_id, full_name, salary, avg_salary
from Employees e
join sub s
on e.department_id = s.department_id
where e.salary > s.avg_salary;


/* Sual 5

WITH ilə project-lərdə işləyən unikal işçilərin siyahısını çıxar. */

with sub as (
	select employee_id, COUNT(a.employee_id) as count_emp
	from Assignments a
	group by employee_id
	)
select full_name, count_emp
from Employees e
join sub s
on e.id = s.employee_id;


/* Sual 6

WITH ilə hər işçinin neçə layihədə iştirak etdiyini hesabla. */

with sub as (
	select employee_id, COUNT(a.employee_id) as count_project
	from Assignments a
	group by employee_id
	)
select employee_id, full_name, count_project
from sub s
join Employees e
on e.id = s.employee_id;


/* Sual 7

WITH ilə salary > 3000 olanları çıxar, sonra onları Departments ilə JOIN et və dept_name göstər. */

with sub as (
	select DISTINCT department_id
	from Employees
	where salary > 3000
	)
select d.department_name
from sub s
join Departments d
on d.id = s.department_id;


/* Sual 8

WITH ilə ən böyük budget-li layihəni tap, sonra əsas SELECT-də göstər. */

with sub as (
	select MAX(budget) as max_budget
	from Projects
	)
select *
from Projects p
join sub s
on p.budget = s.max_budget;


/* Sual 9

WITH ilə hər department üzrə average salary hesabla, sonra nəticəni böyükdən kiçiyə sırala. */

with sub as (
	select department_id, AVG(salary) as avg_salary
	from Employees
	group by department_id
	)
select department_id, avg_salary
from sub
order by avg_salary desc;


/* Sual 10

WITH ilə project-də işləyən işçilərin maaş cəmini hesabla. */

with sub as (
  select e.id, e.salary
  from Employees e
  join Assignments a
  on e.id = a.employee_id
)
select SUM(s.salary) as total_salary
from sub s;



/* 🎯 Tapşırıq 1:

Birinci CTE (high_salary) → maaşı 5000-dən çox olan işçiləri çıxar.

İkinci CTE (project_count) → hər bir işçinin neçə layihədə iştirak etdiyini çıxar.

Son SELECT → yalnız maaşı 5000-dən çox olan işçilər və onların layihə sayı göstərilsin.*/

with sub as (
	select id, full_name, salary
	from Employees
	where salary > 5000
	),
sub2 as (
	select employee_id, COUNT(employee_id) as count_project
	from Assignments 
	group by employee_id
	)
select 
	s.full_name, 
	s.salary, 
	s2.count_project
from sub s
join sub2 s2
on s.id = s2.employee_id;


/* 🎯 Tapşırıq 2:

Birinci CTE (dept_salary) → hər department üçün ortalama maaşı hesabla.

İkinci CTE (high_salary_employees) → yalnız həmin department-in ortalama maaşından yüksək maaş alan işçiləri götür.

Son SELECT → hər yüksək maaşlı işçinin:*/

with sub as (
	select department_id, AVG(salary) as avg_salary
	from Employees e
	group by department_id
	),
sub2 as (
	select 
		id, 
		full_name, 
		salary, 
		e2.department_id, 
		e2.hire_date, 
		YEAR(GETDATE()) - YEAR(e2.hire_date) AS years_in_company
	from Employees e2
	join sub s
	on e2.department_id = s.department_id
	where e2.salary > s.avg_salary
	)
select 
	full_name, 
	department_name, 
	salary, 
	s.avg_salary, 
	hire_date , 
	s2.years_in_company
from Departments d
join sub s
on d.id = s.department_id
join sub2 s2
on s.department_id = s2.department_id
order by s2.department_id, s2.salary desc;


/* 🎯 Tapşırıq 3:

👉 yalnız ən azı 2 fərqli layihədə işləyən işçilər
👉 onların işlədiyi layihələrin toplam budget-i
👉 və onların department ortalama maaşı

çıxarılsın. */

with sub as (
	select employee_id, COUNT(*) as count_project
	from Assignments a
	group by employee_id
	having COUNT(*) >= 2
	),
sub2 as (
	select employee_id, SUM(budget) as total_budget
	from Projects p
	join Assignments a
	on a.project_id = p.id
	group by employee_id
	),
sub3 as (
	select department_id, AVG(salary) as avg_salary
	from Employees
	group by department_id
	)
select 
	e.full_name, 
	e.salary, 
	d.department_name, 
	s.count_project, 
	s2.total_budget, 
	s3.avg_salary
from sub s
join Employees e
on e.id = s.employee_id
join sub2 s2 
on s.employee_id = s2.employee_id
join sub3 s3
on s3.department_id = e.department_id
join Departments d
on d.id = e.department_id
order by s2.total_budget desc;


/* 🎯 Tapşırıq 4:

👉 yalnız ən azı 3 layihədə işləyən işçilər
👉 onların işlədiyi layihələrin orta budget-i
👉 onların departmentindəki ümumi işçi sayı
👉 həmin departmentdəki maksimum maaş

çıxarılsın */

with emp_project_counts as (
	select employee_id, COUNT(*) as count_project
	from Assignments a
	group by employee_id
	having COUNT(*) >= 3
	),
emp_avg_project_budget as (
	select employee_id, AVG(budget) as avg_budget
	from Projects p
	join Assignments a
	on a.project_id = p.id
	group by employee_id
	),
dept_employee_count as (
	select department_id, COUNT(*) as count_emp
	from Employees
	group by department_id
	),
dept_max_salary as (
	select department_id, MAX(salary) as max_salary
	from Employees
	group by department_id
	)
select 
	e.full_name, 
	d.department_name, 
	p.count_project, 
	b.avg_budget, 
	c.count_emp, 
	m.max_salary
from Employees e
join emp_project_counts p
on e.id = p.employee_id
join emp_avg_project_budget b 
on e.id = b.employee_id
join Departments d
on d.id = p.employee_id 
join dept_employee_count c
on d.id = c.department_id
join dept_max_salary m
on d.id = m.department_id;

/* 🎯 Tapşırıq 5:

Aşağıdakı məlumatları çıxaran sorğu yaz:

Hər department üçün göstər: department_name

departmentdə işləyən işçi sayı

bu department işçilərinin iştirak etdiyi unikal project sayı

həmin projectlərin ümumi budget cəmi

departmentdə ortalama salary */

with sub1 as (
	select 
		department_id, 
		COUNT(*) as emp_count, 
		AVG(salary) as avg_salary
	from Employees
	group by department_id
	),
sub as (
	select distinct employee_id, project_id
	from Assignments a
	),
sub2 as (
	select 
		department_id, 
		COUNT(distinct a.project_id) as pro_count, 
		SUM(budget) as total_budget
	from Projects p
	join Assignments a
	on a.project_id = p.id
	join Employees e
	on e.id = a.employee_id
	group by department_id
	)
select 
	d.department_name, 
	s1.avg_salary, 
	s1.emp_count, 
	s2.pro_count, 
	s2.total_budget
from Departments d
left join sub1 s1
on d.id = s1.department_id
left join sub2 s2
on s2.department_id = d.id
order by d.department_name;


/* 🎯 Tapşırıq 6:

1️. Yalnız ən azı 2 layihədə işləyən işçiləri seç
2️. Bu işçilərin hər birinin işlədiyi layihələrin toplam budget-i
3️. İşçinin departmentindəki ortalama maaş və maksimum maaş
4️. Hər department üzrə layihələrə iştirak edən işçi sayı
5️. Final nəticədə göstər: */

with sub1 as (
	select employee_id, COUNT(*) as emp_count
	from Assignments a
	group by employee_id
	having COUNT(*) > 2
	),
sub2 as (
	select employee_id, SUM(budget) as total_budget
	from Assignments a
	join Projects p
	on a.project_id = p.id
	group by employee_id
	),
sub3 as (
	select 
		department_id, 
		AVG(salary) as avg_salary, 
		MAX(salary) as max_salary
	from Employees 
	group by department_id
	),
sub4 as (
	select department_id, COUNT(distinct a.employee_id) as emp_count
	from Employees e
	join Assignments a
	on a.employee_id = e.id
	group by department_id
	)
select 
	e.full_name, 
	d.department_name, 
	e.salary, s2.total_budget, 
	s3.avg_salary, 
	s3.max_salary, 
	s4.emp_count
from Employees e
join sub1 s1
on s1.employee_id = e.id
join sub2 s2
on s1.employee_id = s2.employee_id
join Departments d
on d.id = e.department_id
join sub3 s3
on s3.department_id = d.id
join sub4 s4
on s4.department_id = d.id;


/* 🎯 Tapşırıq 7:

1️. Hər işçi üçün hesabla:

neçə layihədə iştirak edib

işlədiyi layihələrin toplam budget-i 

2️. Yalnız 2+ layihədə işləyən işçiləri seç

3️. Hər işçinin department-i üzrə hesabla:

departmentdəki ortalama maaş

departmentdəki maksimum maaş

departmentdəki layihələrdə iştirak edən işçi sayı

4️. Nəticədə göstər:*/

with emp_proj_count as (
	select employee_id, COUNT(*) as proj_count
	from Assignments a
	group by employee_id
	having COUNT(*) > 2
	),
emp_total_budget as (
	select a.employee_id, SUM(budget) as total_budget
	from Assignments a
	join Projects p
	on p.id = a.project_id
	group by a.employee_id
	),
dept_salary_stats as (
	select 
		department_id, 
		AVG(salary) as avg_salary, 
		MAX(salary) as max_salary, 
		COUNT(distinct a.employee_id) as dept_active_emp
	from Employees e
	join Assignments a
	on e.id = a.employee_id
	group by department_id
	)
select 
	e.full_name, 
	d.department_name, 
	e.salary, 
	e2.proj_count, 
	e3.total_budget,
	d2.avg_salary, 
	d2.max_salary, 
	d2.dept_active_emp
from Employees e
join emp_proj_count e2
on e.id = e2.employee_id
join emp_total_budget e3
on e.id = e3.employee_id 
join Departments d
on d.id = e.department_id
join dept_salary_stats d2
on d2.department_id = d.id;