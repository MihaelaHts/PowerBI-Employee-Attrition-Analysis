select *
from employee_attrition_dataset;

select count(salary)
from employee_attrition_dataset
where salary like "";

-- Change Blanks to NULL

update employee_attrition_dataset
set salary = null
where salary ="";

-- Create Binning Bands and View
-- Extract Month and year
-- Salary Range

create or replace view v_employee_attrition as
select EmployeeID,ManagerID,WorkLocation,Department,JobRole,
-- Age Grouping 
case when age<30 then '18-29'
	when age between 30 and 50 then '30-50'
    else 'Over 50'
    end as age_group,cast(salary as decimal(10,2)) as salary,
-- Range Salary
    case
	when salary<50000 then '30k-50k'
    when Salary between 50000 and 90000 then '50k-90k'
    when Salary between 90001 and 130000 then '90k-130k'
	when salary between 130001 and 170000 then '130k-170k'
    else 'Over 170k'
    end as salary_range,ReasonForLeaving,PerformanceRating,
    -- Performance label
    case
    when PerformanceRating<=2 then 'Low'
    when PerformanceRating in (3,4) then 'Average'
    when PerformanceRating>=5 then 'High'
    else 'N/A'
    end as performance_label ,Gender,
-- transform string to date 
    year(str_to_date(dateofjoining,'%d/%m/%Y')) as year_of_joining,
    month(str_to_date(dateofjoining,'%d/%m/%Y')) as month_of_joining,
    year(str_to_date(dateofleaving,'%d/%m/%Y')) as year_of_leaving,
    month(str_to_date(dateofleaving,'%d/%m/%Y')) as month_of_leaving
from employee_attrition_dataset
where salary is not null
and department is not null;

select *
from v_employee_attrition;


select min(salary) as min_salary, max(salary) as max_salary, avg(salary) as avg_salary
from v_employee_attrition
;

-- Change Blanks to NULL

update v_employee_attrition
set managerid = null
where managerid ="";

update v_employee_attrition
set department = null
where department ="";

select managerid, reasonforleaving,count(*) as nr_leaving
from v_employee_attrition
where managerid is not null
and reasonforleaving is not null
group by managerid, reasonforleaving
order by nr_leaving desc
;

select performance_label, count(*) as nr_employee, avg(salary) as avg_salary
from v_employee_attrition
group by performance_label;

select performance_label, count(*) as nr_leaving
from v_employee_attrition
where reasonforleaving is not null
group by performance_label;
