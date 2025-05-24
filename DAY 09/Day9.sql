----------------------------( Day 9 SOLUTIOS )--------------------------
use ITI

--1.Create a stored procedure without parameters to show the number of students per department name.[use ITI DB] 

create proc Student_num 
as 
select d.Dept_Name,COUNT(s.St_Id) from Department d inner join Student s
on s.Dept_Id=d.Dept_Id  group by d.Dept_Name;

Exec Student_num
---------------------------------------------------------------------------------------------------------
--2.Create a stored procedure that will check for the # of employees in the project p1 
--if they are more than 3 print message to the user “'The number of employees in the project p1 is 3 or more'” 
--if they are less display a message to the user “'The following employees work for the project p1'”
--in addition to the first name and last name of each one. [Company DB] 

use Company_SD

create Proc check_num 
as
Begin
 declare @num int 
 select @num=COUNT(SSN) from Employee e inner join Works_for w 
 on w.ESSn=e.SSN where w.Pno=100
   if(@num >= 3)
    select 'The number of employees in the project p1 is 3 or more' AS Message
   else
     Begin
         select 'The following employees work for the project p1' AS Message

	     select e.Fname+' '+e.Lname AS FullName from Employee e inner join Works_for w 
         on w.ESSn=e.SSN where w.Pno=100
     End
End
exec check_num
----------------------------------------------------------------------------------------------------
--3.Create a stored procedure that will be used in case there is an old employee has left the project 
--and a new one become instead of him. The procedure should take 3 parameters
--(old Emp number, new Emp number and the project number) and it will be used to update works_on table. [Company DB]


use Company_SD

create Proc lefting_Project @Old_SSN int ,@New_SSN int ,@P_num int
as
update Works_for set ESSn=@New_SSN  WHERE ESSn = @Old_SSN AND Pno = @P_num


EXEC lefting_Project @Old_SSN = 123456, @New_SSN = 654321, @P_num = 100
-----------------------------------------------------------------------------------------------------
--4.add column budget in project table and insert any draft values in it then 
--then Create an Audit table with the following structure 
----------------------------------------------------------------------------
-- ProjectNo |	UserName |	ModifiedDate  | 	Budget_Old |	Budget_New  |
-------------|-----------|----------------|----------------|----------------|
-- p2 	     |    Dbo    |	2008-01-31	  |    95000 	   |    200000      |
----------------------------------------------------------------------------
alter table Project add budget int;

--the values I am added it manually

create table auditing(
ProjectNo int,
UserName varchar(20),
ModifiedDate date,
Budget_Old int,
Budget_New int
)
--audit in budjet
create trigger audit_budget on Project 
AFTER UPDATE
as
BEGIN    
    IF UPDATE(budget)
	 begin
      declare @old_budg int,@new_budg int,@pnum int
      select @old_budg=budget,@pnum=Pnumber from deleted;
      select @new_budg=budget from inserted
      insert into auditing values(@pnum,SUSER_NAME(),GETDATE(),@old_budg,@new_budg)
   end
END 
-------------------------------------------------------------------------------------------------------
--5.Create a trigger to prevent anyone from inserting a new record in the Department table [ITI DB]
--“Print a message for user to tell him that he can’t insert a new record in that table”

use ITI

create trigger prventing on Department 
instead of insert
as
select 'You can’t insert a new record in that table '

insert into Department values(10,'sd','sys','cairo',NULL,GETDATE())
-------------------------------------------------------------------------------------------------------
--6. Create a trigger that prevents the insertion Process for Employee table in March [Company DB].
use Company_SD

create trigger prevent_march on Employee
instead of insert
as
BEGIN
if (format(getdate(),'MMMM')='March')
    select'You can’t insert at this month'
else 
	insert into Employee select * from inserted
END
--------------------------------------------------------------------------------------------------------
--7.Create a trigger on student table after insert to add Row in Student
--Audit table(Server User Name , Date, Note) where note will be
--“[username] Insert New Row with Key=[Key Value] in table [table name]”
-------------------------------------------
-- Server User Name  |  Date  |	 Note     |
-------------------------------------------
use ITI	

create table auditing_inserteed_Student(
Server_User_Name  varchar(20),
Date  date,
Note varchar(300)
);

create trigger auditing_insert on Student 
after insert 
as
BEGIN
   declare @id int 
   select @id =St_Id from inserted

   insert into auditing_inserteed_Student 
   select
   SUSER_NAME(), 
   GETDATE(),
   USER_NAME()+' '+'Insert New Row with '+'st_id= '+convert(varchar(10),@id)+' in table [student]'
END
-------------------------------------------------------------------------------------------------------------
--8. Create a trigger on student table instead of delete to add Row in Student Audit table 
--(Server User Name, Date, Note) where note will be“ try to delete Row with Key=[Key Value]”

use ITI	

create table auditing_deleted_Student(
Server_User_Name  varchar(20),
Date  date,
Note varchar(300)
);

create trigger auditing_delete on Student 
instead of delete 
as
BEGIN
   declare @id int 
   select @id =St_Id from deleted

   insert into auditing_deleted_Student 
   select
   SUSER_NAME(), 
   GETDATE(),
   USER_NAME()+' '+'try to delete Row with Key st_id = '+' '+convert(varchar(10),@id)
END
--check
delete from Student where St_Id=1;
------------------------------------------------------------------------------------------------------------
--9.Display all the data from the Employee table (HumanResources Schema) 
--As an XML document “Use XML Raw”. “Use Adventure works DB” 

USE AdventureWorks;

--A)Elements
select * from HumanResources.Employee for xml raw,elements

--B)Attributes
select * from HumanResources.Employee for xml raw

-------------------------------------------------------------------------------------------------------------
--10.Display Each Department Name with its instructors. “Use ITI DB”
use ITI

--A)Use XML Auto
select Dept_Name,Ins_Name  from Department d inner join Instructor i 
on i.Dept_Id = d.Dept_Id for xml auto

--B)Use XML Path
select Dept_Name,Ins_Name  from Department d inner join Instructor i 
on i.Dept_Id = d.Dept_Id for xml path
-------------------------------------------------------------------------------------------------------------
--11.Use the following variable to create a new table “customers” inside the company DB.
--Use OpenXML
use Company_SD

CREATE TABLE customers (
    First_Name VARCHAR(20),
    Zipcode INT,
    orderr VARCHAR(20),
    order_ID INT
);

--1) declare xml variable
declare @docs xml =
'<customers>
    <customer FirstName="Bob" Zipcode="91126">
        <order ID="12221">Laptop</order>
    </customer>
    <customer FirstName="Judy" Zipcode="23235">
        <order ID="12221">Workstation</order>
    </customer>
    <customer FirstName="Howard" Zipcode="20009">
        <order ID="3331122">Laptop</order>
    </customer>
    <customer FirstName="Mary" Zipcode="12345">
        <order ID="555555">Server</order>
    </customer>
</customers>'
 
--2) declare int variable
declare @ptr int
--3) create memorey tree
exec sp_xml_preparedocument @ptr output, @docs

--4)reed tree from the memorey
INSERT INTO customers
select * from openxml (@ptr,'/customers/customer')
with(
    First_Name varchar(20) '@FirstName',
    Zipcode int '@Zipcode',
    orderr varchar(20) 'order',
    order_ID int 'order/@ID'
)

exec sp_xml_removedocument @ptr
             
			 
			 
			 
----------------------------( Day 9 DONE )--------------------------
