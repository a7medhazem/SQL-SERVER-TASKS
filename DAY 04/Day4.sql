------------------------------( Day 4 SOLUTIOS )-------------------------------
use Company_SD

--1.Display (Using Union Function)
--a. The name and the gender of the dependence that's gender
--is Female and depending on Female Employee.

--b. And the male dependence that depends on Male Employee.

select d.Dependent_name ,d.Sex from Employee e 
inner join Dependent d on e.SSN=d.ESSN
where  e.Sex='F' and d.Sex='F' 
union all
select d.Dependent_name ,d.Sex from Employee e
inner join Dependent d on e.SSN=d.ESSN 
where  e.Sex='M' and d.Sex='M' ;
-------------------------------------------------------------------------------------------
--2.For each project, list the project name and the total hours per week 
--(for all employees) spent on that project.

select Pname,sum(Hours*7) Total_Hours_Per_Week
from Project p inner join Works_for w
on w.Pno=p.Pnumber group by Pname;

-------------------------------------------------------------------------------------------
--3.Display the data of the department which has
--the smallest employee ID over all employees' ID.

select d.* from Departments d inner join Employee e 
on e.Dno=d.Dnum where e.SSN=(select min(SSN) from employee);

-------------------------------------------------------------------------------------------
--4.For each department, retrieve the department name
--and the maximum, minimum and average salary of its employees.

select d.Dname,min(e.Salary) min_salary,max(Salary) max_salary ,
avg(Salary) avg_sal from Departments d left outer join Employee e 
on e.Dno=d.Dnum group by d.Dname;

-------------------------------------------------------------------------------------------
--5.List the last name of all managers who have no dependents.
select Lname from Employee e inner join Departments d 
on e.SSN=d.MGRSSN
where d.MGRSSN not in(select t.ESSN from Dependent t);

-------------------------------------------------------------------------------------------
-- 6.For each department-- if its average salary is less than the average salary
-- of all employees-- display its number, name and number of its employees.

select Dno,Dname,count(e.SSN) from Departments d inner join Employee e
on d.Dnum=e.Dno
group by Dname,Dno
having avg(Salary) <(select avg(salary) from Employee);

-------------------------------------------------------------------------------------------
--7.Retrieve a list of employees and the projects they are working on ordered by department
--and within each department, ordered alphabetically by last name, first name.

select Fname,Lname,Dname,Pname
from Employee e inner join Departments d
on e.Dno=d.Dnum
inner join Project p
on  p.Dnum=d.Dnum order by Dname,Fname,Lname;

-------------------------------------------------------------------------------------------
--8.Try to get the max 2 salaries using subquery

--sol1
select top(2) Salary from Employee order by Salary desc;
--sol2
SELECT DISTINCT Salary  AS maxSalaryd.e
FROM Employee
WHERE Salary IN (
    SELECT TOP(2) Salary
    FROM Employee
    ORDER BY Salary DESC)
ORDER BY maxSalary DESC;

-------------------------------------------------------------------------------------------
--9.Get the full name of employees that is similar to any dependent name


select Fname+' '+Lname [fullname],d.Dependent_name
from Employee e inner join Dependent d 
on e.SSN=d.ESSN
where d.Dependent_name like '%'+Fname +' '+Lname;

-------------------------------------------------------------------------------------------
--10.Try to update all salaries of employees who work in Project ‘Al Rabwah’ by 30% 


update e set e.Salary=Salary+Salary*0.3
from Employee e inner join Departments d
on e.Dno=d.Dnum inner join Project p
on d.Dnum=p.Dnum
where p.Pname='Al Rabwah';

-------------------------------------------------------------------------------------------
--11.Display the employee number and name
--if at least one of them have dependents (use exists keyword) self-study.

--sol1
select distinct Fname,Lname , SSN 
from Employee e inner join Dependent d
on e.SSN=d.ESSN ;

--sol2
SELECT e.Fname, e.Lname, e.SSN
FROM Employee e
WHERE EXISTS (
    SELECT 1
    FROM Dependent d
    WHERE d.ESSN = e.SSN);
-------------------------------------------------------------------------------------------

-------------------------------( PART 2 )------------------------------------

--1.In the department table insert new department called "DEPT IT" ,
--with id 100, employee with SSN = 112233 as a manager for this department.
--The start date for this manager is '1-11-2006'

insert into Departments values('DEPT IT',100,112233,1-11-2006);

-------------------------------------------------------------------------------------------
--2.Do what is required if you know that : Mrs.Noha Mohamed(SSN=968574)
--moved to be the manager of the new department (id = 100),
--and they give you(your SSN =102672) her position (Dept. 20 manager) 

--a.First try to update her record in the department table
--b.Update your record to be department 20 manager.
--c.Update the data of employee number=102660 to be in your teamwork (he will be supervised by you) (your SSN =102672)

--A
update Departments set MGRSSN=968574 where Dnum=100;

--b
update Departments set MGRSSN=102672 where Dnum=20;

--c
update Employee set Superssn=102672 where SSN=102660;

-------------------------------------------------------------------------------------------
--3.Unfortunately the company ended the contract with Mr. Kamel Mohamed (SSN=223344)
--so try to delete his data from your database in case
--you know that you will be temporarily in his position.
--Hint: (Check if Mr. Kamel has dependents, works as a department manager,
--supervises any employees or works in any projects and handle these cases).

-- تحديث مشرفي الموظفين الذين كانوا تحت إشراف السيد كامل
update Employee 
set Superssn = 102672 
where Superssn = 223344;

-- تحديث سجل العمل في المشاريع
update Works_for
set ESSn = 102672
where ESSn = 223344;

-- حذف بيانات المعالين للسيد كامل
delete from Dependent where ESSN = 223344;

-- تحديث الأقسام التي كان السيد كامل مديرها
update Departments set MGRSSN = 102672 where MGRSSN = 223344;

-- حذف سجل السيد كامل من جدول الموظفين
delete from Employee where SSN = 223344;


------------------------------( Day 4 DONE )-------------------------------
