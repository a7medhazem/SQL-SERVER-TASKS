----------------------------( Day 5 SOLUTIOS )--------------------------
use ITI
--1.Retrieve number of students who have a value in their age. 

select count(*) from Student
where St_Age is not null;

-------------------------------------------------------------------------------------
--2.Get all instructors Names without repetition

select distinct Ins_Name from Instructor ;

-------------------------------------------------------------------------------------
--3.Display student with the following Format (use isNull function)
-----------------------------------------------------
--Student ID  |	Student Full Name |	Department name |
-----------------------------------------------------		

select St_Id,St_Fname+' '+St_Lname as fullname ,
Dept_Name from Student s inner join Department d
on d.Dept_Id=s.Dept_Id;

------------------------------------------------------------------------------------
--4.Display instructor Name and Department Name 
--Note: display all the instructors if they are attached to a department or not

select Ins_Name ,Dept_Name from Instructor i left outer join Department d 
on d.Dept_Manager=i.Ins_Id;
------------------------------------------------------------------------------------
--5.Display student full name and the name of the course he is taking
--For only courses which have a grade  

select St_Fname+' '+St_Lname as fullname,Crs_Name 
from Course c inner join Stud_Course s on c.Crs_Id=s.Crs_Id 
inner join Student st on st.St_Id=s.St_Id and s.Grade is not null; 

------------------------------------------------------------------------------------
--6.Display number of courses for each topic name

select count(Crs_Id),Top_Name from Course c inner join Topic t
on c.Top_Id=t.Top_Id group by Top_Name;

------------------------------------------------------------------------------------
--7.Display max and min salary for instructors

select max(Salary) as [min salary],min(Salary) as 'max salary'  from Instructor;

------------------------------------------------------------------------------------
--8.Display instructors who have salaries
--less than the average salary of all instructors.

select * from Instructor
where Salary <(select avg(ISNULL( salary,0)) from Instructor);

------------------------------------------------------------------------------------
--9.Display the Department name that contains the instructor
--who receives the minimum salary.

select Dept_Name from  Instructor i  inner join Department d
on d.Dept_Manager=i.Ins_Id and salary =(select min(salary)
from Instructor) ;

------------------------------------------------------------------------------------
--10. Select max two salaries in instructor table. 

select top(2) Salary from Instructor order by Salary desc;

------------------------------------------------------------------------------------
--11. Select instructor name and his salary
--but if there is no salary
--display instructor bonus. “use one of coalesce Function”

select Ins_Name,ISNULL( convert(varchar(50),Salary),'inst bouns')
from Instructor

------------------------------------------------------------------------------------
--12.Select Average Salary for instructors 

select avg( Salary) from Instructor;
select avg(isnull( Salary,0) )from Instructor;

------------------------------------------------------------------------------------
--13.Select Student first name and the data of his supervisor 

SELECT 
    st.St_Fname AS Student_FName,
    super.St_Id AS Super_ID,
    super.St_Fname AS Super_FName,
    super.St_Lname AS Super_LName
FROM 
    Student st
INNER JOIN 
    Student super 
    ON st.St_super = super.St_Id;
-------------------------------------------------------------------------------------
--14.Write a query to select the highest two salaries in Each Department
--for instructors who have salaries. “using one of Ranking Functions”

SELECT Dept_Id, Ins_Name, Salary
FROM (
    SELECT 
        Dept_Id,
        Ins_Name,
        Salary,
        DENSE_RANK() OVER (PARTITION BY Dept_Id ORDER BY Salary DESC) AS RankInDept
    FROM Instructor
    WHERE Salary IS NOT NULL
) AS RankedSalaries
WHERE RankInDept <= 2
--------------------------------------------------------------------------------------
--15. Write a query to select a random  student from each department.
--“using one of Ranking Functions”

SELECT Dept_Id, St_Id, St_Fname, St_Lname
FROM (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY Dept_Id 
            ORDER BY NEWID()
        ) AS rn
    FROM Student
) AS RandomPerDept
WHERE rn = 1

----------------------------( Day 5 DONE )--------------------------
