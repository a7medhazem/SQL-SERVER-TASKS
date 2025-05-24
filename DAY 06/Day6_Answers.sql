----------------------------( Day 6 SOLUTIOS )--------------------------
use LAB6

create rule r1 as @x in('NY','DS','KW'); 
create default def1 as 'NY';
EXEC sp_addtype locc,'nchar(2)';
EXEC sp_bindrule r1,locc;
EXEC sp_bindefault def1,locc;


create table Department (
dnum int primary key,
dname varchar(20),
loc locc,
);

insert into Department values(1,'Research','NY');
insert into Department values(2,'Accounting','DS');
insert into Department values(3,'Markiting','KW');

---------------------------------------------------------------------------------
create table Employee (
emp_num int ,
Fname varchar(20) not null,
Lname varchar(20) not null,
dnum int,
salary int,
constraint s1 primary key (emp_num),
constraint s2 foreign key (dnum) references Department(dnum),
constraint s3 unique (salary),
);
 
create rule r2 as @X<6000;
EXEC sp_bindrule r2,'Employee.salary';

insert into Employee values(25348,'Mathew','Smith',3,2500);
insert into Employee values(10102,'Ann','Jones',3,3000);
insert into Employee values(29346,'James','James',2,2800);
insert into Employee values(9031,'lisa','Bertoni',2,4000);
insert into Employee values(2581,'Elisa','Hansel',2,3600);
insert into Employee values(28559,'Sybl','Moser',1,2900);



--testing (all query is conflicted)
delete from Employee where emp_num=10102;--conflicted
---------------------------------------------------------------------------------

alter table Employee add telephone_num varchar(12);
alter table Employee drop column telephone_num;

---------------------------------------------------------------------------------

create schema Company;
alter schema Company transfer Department;

---------------------------------------------------------------------------------

create schema Human_Resources;
alter schema Human_Resources transfer Employee;

---------------------------------------------------------------------------------
SELECT 
    CONSTRAINT_NAME, 
    CONSTRAINT_TYPE
  
FROM 
    INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
WHERE 
    TABLE_NAME = 'employee';
---------------------------------------------------------------------------------

create synonym empp for Human_Resources.Employee;
select * from Employee;--invalid
select * from Human_Resources.Employee ;--done
select * from empp;//done
select * from Human_Resources.empp;//error
---------------------------------------------------------------------------------

UPDATE p
SET p.budget = p.budget + p.budget * 0.1
FROM Company.Project p
INNER JOIN Works_on w ON p.Pnum = w.Pnum
WHERE w.emp_num = 10102;
---------------------------------------------------------------------------------

update c set c.dname='Sales' from Company.Department c 
inner join Human_Resources.Employee e on c.dnum=e.dnum
where e.Fname='James';

---------------------------------------------------------------------------------
update w set Enterdate='2007-12-12' from Works_on w
inner join Human_Resources.Employee e
on w.emp_num=e.emp_num 
inner join Company.Department c on e.dnum=c.dnum
where w.Pnum=1 and c.dname='Sales';

---------------------------------------------------------------------------------

delete w from Works_on w 
inner join Human_Resources.Employee e on w.emp_num=e.emp_num 
inner join Company.Department c on e.dnum=c.dnum 
where c.loc='KW';






----------------------------( Day 6 DONE )--------------------------
