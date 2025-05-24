------------------------( Day 10 Solutions )-----------------------

--Create a cursor for Employee table that increases 
--Employee salary by 10% if Salary <3000 and increases it 
--by 20% if Salary >=3000 .Use company DB
use Company_SD

declare c1 cursor
for select Salary from Employee
for update 
declare @sal int
open  c1
fetch c1 into @sal
  
  while(@@FETCH_STATUS=0)
  begin
       if(@sal<3000)
	     update Employee set Salary=@sal+@sal*0.1 where current of c1
	   else
	   	 update Employee set Salary=@sal+@sal*0.2 where current of c1

       fetch c1 into @sal

  end
close c1
deallocate c1;

---------------------------------------------------------------------
--2.Display Department name with its manager name using cursor.
--Use ITI DB

use ITI
declare c2 cursor
for select Dept_Name,Dept_Manager from Department
for read only
declare @D_name varchar(20),@D_manager varchar(20)
open  c2
fetch c2 into @D_name,@D_manager
  
  while(@@FETCH_STATUS=0)
    begin
     select @D_name,@D_manager
     fetch c2 into @D_name,@D_manager
    end
close c2
deallocate c2;

---------------------------------------------------------------------
--3.Try to display all students first name in one cell
--separated by comma. Using Cursor 

use ITI
declare c3 cursor
for select St_Fname from Student
for read only
declare @name varchar(20),@all_nmaes varchar(300)=' '
open  c3
fetch c3 into @name
  
  while(@@FETCH_STATUS=0)
    begin
        set @all_nmaes=concat(@all_nmaes,',',@name)
        fetch c3 into @name
    end
	select 'all students : '+ @all_nmaes
close c3
deallocate c3;

---------------------------------------------------------------------
--4.Create full, differential Backup for SD DB.

BACKUP DATABASE Company_SD
TO DISK ='D:\DB (MS SQL Server)\Company_SD_Full.bak'
WITH format,init;

BACKUP DATABASE Company_SD
TO DISK = 'D:\DB (MS SQL Server)\Company_SD_Diff.bak'
WITH DIFFERENTIAL;

-----------------------( Day 10 Done )------------------------
-----------------------( finally ... )------------------------
-----------------------( frkesh .... )------------------------

