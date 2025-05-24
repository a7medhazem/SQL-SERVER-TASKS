----------------------------( Day 7 SOLUTIOS )--------------------------
use ITI
--1.Create a scalar function that takes date and returns Month name of that date.

create function date_month(@d date)
returns varchar(20)
begin
return month(@d)
end

select dbo.date_month('2020-oct-5')

------------------------------------------------------------------------------------------------------------------------------------
--2. Create a multi-statements table-valued function that takes 2 integers and returns the values between them.

create function r_between(@b1 int ,@b2 int )
returns @t table
(
st_n varchar(20),
st_age int
)
begin
insert into @t select St_Fname,St_Age from Student where St_Age between @b1 and @b2;
return;
end;

select * from r_between(21,24);

-----------------------------------------------------------------------------------------------------------------------------------
 --3.Create inline function that takes Student No and returns Department Name with Student full name.

create function info(@snom int)
returns table
return(
 
  select fullname=St_Fname+' '+St_Lname,Dept_Name from Student s inner join Department d on d.Dept_Id=s.Dept_Id where St_Id=@snom

);


select* from info(5);

-------------------------------------------------------------------------------------------------------------------------------------
--4.Create a scalar function that takes Student ID and returns a message to user 
--a.If first name and Last name are null then display 'First name & last name are null'
--b.If First name is null then display 'first name is null'
--c.If Last name is null then display 'last name is null'
--d.Else display 'First name & last name are not null'


create function msg(@sid int)
returns varchar(100)
begin
declare @store1 varchar(20),@store2 varchar(20);
select @store1=St_Fname,@store2=St_Lname from Student where St_Id=@sid;
   
  IF @store1 IS NULL AND @store2 IS NULL
   RETURN 'First name & last name are null';
   ELSE  IF @store1 IS NULL 
   RETURN 'first name is null'
   else if @store2 IS NULL
   RETURN 'last name is null'
   else
   RETURN 'First name & last name are not null';
   
   return '    '
end

select dbo.msg(14)

-------------------------------------------------------------------------------------------------------------------
--5.Create inline function that takes integer which represents manager ID and displays
--department name, Manager Name and hiring date 

create function display_manger_info(@mang_id int)
returns table
return
(
select Dept_Name,Ins_Name,Manager_hiredate 
from Department d inner join Instructor i 
on d.Dept_Manager=i.Ins_Id where Dept_Id=@mang_id
);

select * from display_manger_info(1);

-------------------------------------------------------------------------------------------------------------------
--6.Create multi-statements table-valued function that takes a string
--If string='first name' returns student first name
--If string='last name' returns student last name 
--If string='full name' returns Full Name from student table 
--Note: Use “ISNULL” function

create function  get_s_name(@word varchar(20),@sid int)
returns @t table
(
  S_name  varchar(20)
)
begin 
       if @word ='first'
	   insert into @t 
	   select isnull( St_Fname,' ') from Student where St_Id=@sid
	   else  if @word ='last'
	   insert into @t 
	   select  isnull( St_Lname,' ') from Student where St_Id=@sid
	     else  if @word ='full'
	   insert into @t 
	   select   isnull( St_Fname,' ')+ ' '+isnull( St_Lname,' ') from Student where St_Id=@sid 


	   return;
end

select * from get_s_name('full',1)

-------------------------------------------------------------------------------------------------------------------
--7.Write a query that returns the Student No and Student first name without the last char.

--SOL1
create function without_Last_char(@sid int)
returns table
return( 
  select St_Id  , SUBSTRING(St_Fname,1,LEN(St_Fname)-1) as sname from Student where St_Id=@sid
)

select * from without_Last_char(2);


--SOL2
 select St_Id  , SUBSTRING(St_Fname,1,LEN(St_Fname)-1) as sname from Student 

------------------------------------------------------------------------------------------------
--8.Wirte query to delete all grades for the students Located in SD Department 

delete c from Stud_Course c
inner join Student s on s.St_Id=c.St_Id
inner join Department d on d.Dept_Id=s.Dept_Id
where Dept_Name='SD'; 



----------------------------( Day 7 DONE )--------------------------
