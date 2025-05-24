------------------------------( WEEK 3 SOLUTIOS )-------------------------------
use Company_SD;

--1.Display the Department id, name and id and the name of its manager.

select Dnum,Dname,fname,SSN from Departments inner join Employee
on MGRSSN=SSN;

-------------------------------------------------------------------------------------------
--2.Display the name of the departments and the name of the projects under its control.

select Dname,Pname from Departments d inner join Project p
on d.Dnum=p.Dnum;

-------------------------------------------------------------------------------------------
--3.Display the full data about all the dependence associated with
--the name of the employee they depend on him/her.

select d.* ,concat(Fname,' ',Lname) as [name]
from Dependent d inner join Employee e
on d.ESSN=e.SSN;

-------------------------------------------------------------------------------------------
--4.Display the Id, name and location of the projects in Cairo or Alex city.

Select Pnumber,Pname,Plocation from Project
where City in('Cairo','Alex');

-------------------------------------------------------------------------------------------
--5.Display the Projects full data of the projects with a name starts with "a" letter.

Select p.* from Project p where Pname like 'a%';

-------------------------------------------------------------------------------------------
--6.display all the employees in department 30 whose salary from 1000 to 2000 LE monthly

select fname from Employee where Salary between 1000 and 2000 and Dno=30;

-------------------------------------------------------------------------------------------
--7.Retrieve the names of all employees in department 10 who works
--more than or equal10 hours per week on "AL Rabwah" project.

select concat(Fname,' ',Lname) as [name] from Employee e
inner join Departments d on e.Dno=d.Dnum and Dnum=10 
inner join Project p on d.Dnum=p.Dnum and Pname='AL Rabwah'
inner join Works_for w on w.Pno=p.Pnumber and e.SSN=w.ESSn and Hours>=10;

-------------------------------------------------------------------------------------------
--8.Find the names of the employees who directly supervised with Kamel Mohamed.

select concat(x.Fname,' ',x.Lname) as [name] 
from Employee x , Employee y
where y.SSN=x.Superssn and y.Fname='Kamel' and y.Lname='mohamed';

-------------------------------------------------------------------------------------------
--9.Retrieve the names of all employees and the names of the projects
--they are working on, sorted by the project name.

SELECT concat(e.Fname,' ',e.Lname) as [Emp_name],p.Pname  from Employee e
INNER JOIN Works_for w ON e.SSN = w.ESSn
INNER JOIN Project p ON w.Pno = p.Pnumber
ORDER BY p.Pname;

-------------------------------------------------------------------------------------------
--10.For each project located in Cairo City , find the project number,
--the controlling department name ,the department manager last name ,address and birthdate.

select Pnumber,Dname,Lname as manager_Lname,Address,Bdate from Project p
inner join Departments d on p.Dnum=d.Dnum  and p.City = 'Cairo'
inner join Employee e on d.MGRSSN=e.SSN;
 
 -------------------------------------------------------------------------------------------
 --11.Display All Data of the mangers

select  DISTINCT e.* 
from Employee e inner join Departments d
on e.SSN=d.MGRSSN;

-------------------------------------------------------------------------------------------
--12.Display All Employees data and the data of their dependents
--even if they have no dependents

select e.* ,d.*
from Employee e left outer join Dependent d
on e.SSN=d.ESSN;

-------------------------------------------------------------------------------------------
--13.Insert your personal data to the employee table as a new employee
--in department number 30, SSN = 102672, Superssn = 112233, salary=3000.

INSERT INTO Employee (SSN,Dno, Superssn, Salary) 
VALUES (102672, 30, 112233, 3000);
-------------------------------------------------------------------------------------------
--2.Insert another employee with personal data your friend as new employee
--in department number 30, SSN = 102660, but don’t enter any value for salary
--or manager number to him.

INSERT INTO Employee (SSN,Dno) 
VALUES (102660, 30);

-------------------------------------------------------------------------------------------
--3.Upgrade your salary by 20 % of its last value.

update Employee set Salary=Salary+(Salary*0.2);


------------------------------( WEEK 3 SOLUTIOS )-------------------------------
