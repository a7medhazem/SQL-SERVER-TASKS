---------------------------------( Day 8 SOLUTIONS )----------------------------------------
use ITI

--1. Create a view that displays student full name, course name if the student has a grade more than 50. 

create view display 
as
select fullnmae= St_Fname+' '+St_Lname , Crs_Name
from Student s inner join Stud_Course c 
on s.St_Id=c.St_Id inner join Course e on e.Crs_Id=c.Crs_Id 
where grade > 50;

select * from display

----------------------------------------------------------------------------------------------------------------
--2. Create an Encrypted view that displays manager names and the topics they teach. 

create view managers_topics with encryption
as
select i.Ins_Name,t.Top_Name from Instructor i inner join Ins_Course c 
on i.Ins_Id=c.Ins_Id inner join Course e on e.Crs_Id=c.Crs_Id
inner join Topic t on t.Top_Id=e.Top_Id;

select * from managers_topics
sp_helptext 'managers_topics' -- to ensuer the query is encrypted

------------------------------------------------------------------------------------------------------------------
--3.Create a view that will display Instructor Name, Department Name for the ‘SD’ or ‘Java’ Department 

create view insname_w_dept
as
select i.Ins_Name,d.Dept_Name from Instructor i inner join Department d 
on d.Dept_Manager=i.Ins_Id
where d.Dept_Name='SD' OR d.Dept_Name='Java'


select * from insname_w_dept

-------------------------------------------------------------------------------------------------------------------
--4. Create a view “V1” that displays student data for student who lives in Alex or Cairo. 
--Note: Prevent the users to run the following query 
--Update V1 set st_address=’tanta’
--Where st_address=’alex’;

create view cairo_or_alex
as 
select * from Student where St_Address='Cairo'
or St_Address='Alex' with check option;

select * from cairo_or_alex
---------------------------------------------------------------------------------------------------------------------
--5.Create a view that will display the project name and the number of employees work on it. “Use Company DB”

use Company_SD
go
create view project_info
as 
select Pname ,emp_num=count(pno)from Project p
inner join Works_for w
on w.Pno=p.Pnumber 
group by pname

select * from project_info
----------------------------------------------------------------------------------------------------------------------
--6.Create index on column (Hiredate) that allow u to cluster the data in table Department. What will happen?

use ITI
go
create nonclustered index hiring 
on Department(Manager_hiredate);
--(NOTE)==> searching by the (Manager_hiredate) will be better and speed 

-----------------------------------------------------------------------------------------------------------------------
--7.Create index that allow u to enter unique ages in student table. What will happen? 

create unique nonclustered index ages 
on Student(St_Age);

-----------------------------------------------------------------------------------------------------------------------
--8.Using Merge statement between the following two tables [User ID, Transaction Amount]


merge into trans as t
using daily as s
on t.amount=s.amount
when matched then update set t.amount=s.amount
when not matched by target then insert  (id, amount) values(s.id,s.amount)
when not matched by source then delete;


---------------------------------( Day 8 DONE )----------------------------------------


 