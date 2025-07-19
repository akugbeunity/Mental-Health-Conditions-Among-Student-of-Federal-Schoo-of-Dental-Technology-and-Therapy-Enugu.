-- CREATE STAGING DATASET FROM MAIN DATASET
create table mental_health_among_students_that_attend_fsdtt
like `mental health amongst students who attend fstt7t`;
insert into mental_health_among_students_that_attend_fsdtt
select * from `mental health amongst students who attend fstt7t`;

-- CHANGE COLUMN NAME
alter table mental_health_among_students_that_attend_fsdtt
rename column Cgpa to CGPA;

-- FIND DUPLICATES WITH CTE
with duplicate_row as 
(select *,
row_number() over(partition by Nos,Gender,Age,Course_of_study,Level,`Marital status`,Mental_Health_Condition,`active participation in schoool`,Sleep_Quality,
`hours of study in a week`,Schooling_and_working,`problems with lecuturer/friends/roomates`,CGPA,carryover) as finding_duplicates 
from mental_health_among_students_that_attend_fsdtt)
select * from duplicate_row
where finding_duplicates >1;
 
 -- DELETE DUPLICATES VALUES
 delete from mental_health_among_students_that_attend_fsdtt
 where Nos in 
(select Nos from 
 (select *,
row_number() over(partition by Nos,Gender,Age,Course_of_study,Level,`Marital status`,Mental_Health_Condition,`active participation in schoool`,Sleep_Quality,
`hours of study in a week`,Schooling_and_working,`problems with lecuturer/friends/roomates`,CGPA,carryover) as finding_duplicates 
from mental_health_among_students_that_attend_fsdtt) X
where X.finding_duplicates  >1);

-- ADD AUTO INCREMENT COLUMN
alter table mental_health_among_students_that_attend_fsdtt
add column ID int  auto_increment primary key
-- I WANTED TO CREATE A STORE PROCEDURE THAT WILL BE EASY FRON ME TO CALL MENTAL HEALTH STUDENT BUT IT DID NOT WORK 
delimiter //
create procedure alter_table()
begin
alter table mental_health_among_students_that_attend_fsdtt;
end //
delimiter ;
call alter_table;

-- DELETE THE COLUMN NOS
alter table mental_health_among_students_that_attend_fsdtt
drop  Nos; 
-- CHANGING THE POSITION OF THE COLUMNS
alter table mental_health_among_students_that_attend_fsdtt
modify carryover text  after CGPA;

-- FINDING NULL/BLANK FOR EACH COLUMN 
select ID,`problems with lecuturer/friends/roomates`from 
mental_health_among_students_that_attend_fsdtt
where `problems with lecuturer/friends/roomates` = '';

update mental_health_among_students_that_attend_fsdtt
set `problems with lecuturer/friends/roomates`= 'blank'
where `problems with lecuturer/friends/roomates`='';

-- STANDARDIZE EACH COLUMN 
select distinct(Gender)
from mental_health_among_students_that_attend_fsdtt;
select Gender
from mental_health_among_students_that_attend_fsdtt
where Gender like 'a%';
update mental_health_among_students_that_attend_fsdtt
set Gender='Female'
where Gender like 'a%';
select Gender
from mental_health_among_students_that_attend_fsdtt
where Gender like 'm%';
alter table mental_health_among_students_that_attend_fsdtt
modify Gender varchar(20);


select distinct(Course_of_study)
from mental_health_among_students_that_attend_fsdtt;
select Course_of_study
from mental_health_among_students_that_attend_fsdtt;


select Course_of_study
from mental_health_among_students_that_attend_fsdtt
where Course_of_study like 'n%' ;
update mental_health_among_students_that_attend_fsdtt
set Course_of_study= 'Dental Nursing'
where Course_of_study like 'mursing ';
select Course_of_study
from mental_health_among_students_that_attend_fsdtt
where Course_of_study like 'the%';
select Course_of_study,upper(Course_of_study)
from mental_health_among_students_that_attend_fsdtt;

select concat(upper(substring(Course_of_study,1,1)),lower(substring(Course_of_study,2)))
as proper_case from mental_health_among_students_that_attend_fsdtt;
update mental_health_among_students_that_attend_fsdtt
set Course_of_study= concat(upper(substring(Course_of_study,1,1)),lower(substring(Course_of_study,2)));
alter table mental_health_among_students_that_attend_fsdtt
modify Course_of_study varchar(50);

select ID,Age from mental_health_among_students_that_attend_fsdtt
order by age asc;
update mental_health_among_students_that_attend_fsdtt
set Age=30
where Age=3;

select distinct(Level)  from mental_health_among_students_that_attend_fsdtt;
select Level from mental_health_among_students_that_attend_fsdtt
where Level like 'year 1';
update mental_health_among_students_that_attend_fsdtt
set Level ='Year 2'
where Level ='yeae 3';
alter table mental_health_among_students_that_attend_fsdtt
modify Schooling_and_working varchar(20);

select carryover from mental_health_among_students_that_attend_fsdtt;


select distinct(`Marital status`) from mental_health_among_students_that_attend_fsdtt;
select `Marital status` from mental_health_among_students_that_attend_fsdtt
where `Marital status`like 'm%';
update mental_health_among_students_that_attend_fsdtt
set `Marital status`='married'
where `Marital status` like 'no';

select distinct(Mental_Health_Condition) from mental_health_among_students_that_attend_fsdtt;
select id,Mental_Health_Condition from mental_health_among_students_that_attend_fsdtt;
update  mental_health_among_students_that_attend_fsdtt
set Mental_Health_Condition=null
where Mental_Health_Condition='blank';
 
 select distinct(`hours of study in a week`) from mental_health_among_students_that_attend_fsdtt;
 select Schooling_and_working from mental_health_among_students_that_attend_fsdtt
 where Schooling_and_working like 'y%';
 
 update mental_health_among_students_that_attend_fsdtt 
 set `hours of study in a week` = 7
 where `hours of study in a week`=9;
 
 alter table mental_health_among_students_that_attend_fsdtt
 modify column `hours of study in a week` int;
 
 update mental_health_among_students_that_attend_fsdtt
set CGPA = Null
where CGPA='';
select distinct(Schooling_and_working) from mental_health_among_students_that_attend_fsdtt;
select concat(upper(substring(Schooling_and_working,1,1)),lower(substring(Schooling_and_working,2)))
as proper_case from mental_health_among_students_that_attend_fsdtt;
update mental_health_among_students_that_attend_fsdtt
set Schooling_and_working= concat(upper(substring(Schooling_and_working,1,1)),lower(substring(Schooling_and_working,2)));
update mental_health_among_students_that_attend_fsdtt
set carryover =concat(upper(substring(carryover,1,1)),lower(substring(carryover,2)));
alter table mental_health_among_students_that_attend_fsdtt
rename column `hours of study in a week`to `Hours of study in a week`;

select `Active participarion in school`,
case
 when `Active participarion in school` <= 1 then 'Not Activie'
when `Active participarion in school` = 2 then 'Average'
else ' fully Activie'
end as Active_participation from  mental_health_among_students_that_attend_fsdtt;

-- add table--
alter table mental_health_among_students_that_attend_fsdtt
add column Participation_in_activities int after `Active participarion in school`;
-- i made a mistake in the data types  instead of varchar i used int
alter table mental_health_among_students_that_attend_fsdtt
modify column Participation_in_activities varchar(50);

-- Update table 
update mental_health_among_students_that_attend_fsdtt
set Participation_in_activities =
case
 when `Active participarion in school` <= 1 then 'Not Activie'
when `Active participarion in school` = 2 then 'Average'
else ' fully Activie'
end;
alter table mental_health_among_students_that_attend_fsdtt
rename column Mental_Health_Condition to Mental_Health_Diagnosis;

