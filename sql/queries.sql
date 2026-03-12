-- ══════════════════════════════════════════
-- HR ATTRITION ANALYSIS — SQL QUERIES
-- Database: hr_attrition
-- Author: Rajat Kumar
-- ══════════════════════════════════════════

# Q1. Which departments are losing the most people?

select d.department_name,
count(e.employee_id) as total_employees,
sum(e.attrition) as attritions,
round(sum(e.attrition)*100/count(e.employee_id),1) as attrition_rate
from employees e join departments d on
e.department_id = d.department_id
group by d.department_name order by attrition_rate desc;

#1. sales has the highest attrition at 20.6% nearly 1 in 5 employees leaving. 
#2. R&D at 13.8% is significantly better despite being 2x larger. 
#3. HR is small sample size (63 people) so interpret with caution.

# Q.2 At what career stage do employees leave most?
select case 
when j.years_at_company <= 2 then '0-2 Years'
when j.years_at_company <= 5 then '3-5 Years'
when j.years_at_company <= 10 then '6-10 Years'
else '10+ Years'
End as tenure,
count(*) as total_employees,
sum(e.attrition) as attritions,
round(sum(e.attrition)*100/count(*),1) as attrition_rate
from employees e join job_details j on e.employee_id = j.employee_id
group by tenure order by attrition_rate desc;

#1. Attrition is overwhelmingly an early-tenure problem. 
#2. Employees in their first 2 years leave at 28.3% 4x the rate of employees with 10+ years. 
#3. Every year an employee stays, the probability of them leaving falls significantly.
#4. The retention intervention should concentrate on the first 2 years.

#Q3. Is compensation driving attrition?
select
    case when e.attrition = 1 then 'Left' else 'Stayed' end AS employee_status,
    COUNT(*) as employee_count,
    round(avg(j.monthly_income), 0) AS avg_monthly_income,
    round(avg(j.percent_salary_hike), 1) AS avg_salary_hike_pct,
    round(avg(j.stock_option_level), 2) AS avg_stock_options,
    round(avg(j.years_since_last_promotion), 1) AS avg_years_since_promo
from employees e
join job_details j on e.employee_id = j.employee_id
group by employee_status
order by avg_monthly_income desc;

#1. Employees who left earned on average $2,046 less per month than those who stayed a 30% income gap. 
#2. Stock option level is notably lower for leavers (0.30 vs 0.58) confirming that financial lock-in through stock options retains employees.
#3. Interestingly, salary hike percentage is nearly identical meaning it is not the rate of increase but the base level of pay that drives attrition
    
#Q 4. Which specific combination of department and job level has the highest attrition risk?

with department_level_attrition as (
select d.department_name, j.job_level, count(*) as total, sum(e.attrition) as attritions
from employees e join departments d on e.department_id = d.department_id join job_details j on e.employee_id = j.employee_id group by d.department_name, j.job_level)
select department_name, job_level, total, attritions, round(attritions*100/total,1) as attrition_rate from department_level_attrition where total>=20 order by attrition_rate desc limit 10;

#1. The top rows show that Sales at Job Level 1 and 2 with extremely high attrition rates likely. 
#2. These are entry-level sales employees, the most at-risk segment in the entire company. 

#Q 5. Within each department, which specific job role has the worst attrition problem?
with role_attrition as (
select d.department_name, j.job_role, count(*) as total, sum(e.attrition) as attritions, round(sum(e.attrition) * 100.0 / count(*), 1) as attrition_rate
from employees e join departments d on e.department_id = d.department_id
join job_details j on e.employee_id = j.employee_id
group by d.department_name, j.job_role)
select department_name, job_role, total, attritions, attrition_rate,
rank() over ( partition by department_name
order by attrition_rate desc) as rank_within_dept
from role_attrition where total >= 10
order by department_name, rank_within_dept;

#1. Within Sales: Sales Representatives rank 1st with the highest attrition. 
#2. Within R&D: Laboratory Technicians rank 1st. 
#3. This tells HR exactly which job role to prioritise within each department much more actionable than department-level analysis alone.

#Q6. Which satisfaction dimension most differentiates employees who leave from those who stay?

select
    case when e.attrition = 1 then 'Left' else 'Stayed' end as employee_status,
    round(avg(s.job_satisfaction), 2) as avg_job_satisfaction,
    round(avg(s.environment_satisfaction), 2) as avg_environment_sat,
    round(avg(s.relationship_satisfaction), 2) as avg_relationship_sat,
    round(avg(s.work_life_balance), 2) as avg_work_life_balance,
    round(avg(s.job_involvement), 2) as avg_job_involvement
from employees e join satisfaction s on e.employee_id = s.employee_id
group by employee_status order by employee_status desc;

# Q7. Does working overtime significantly increase attrition risk?

select j.overtime, count(*) as total_employees, sum(e.attrition) as attritions, round(sum(e.attrition) * 100.0 / count(*), 1) as attrition_rate
from employees e join job_details j on e.employee_id = j.employee_id group by j.overtime order by attrition_rate desc;

#1. Employees working overtime leave at 30.5% vs 10.4% for those who do not nearly 3x the rate. 
#2. This is one of the single strongest attrition signals in the entire dataset. It is also one of the most actionable overtime policy is within management control in a way that salary bands or market conditions are not.

# Q8. Are employees leaving because they feel stuck?

select case
when j.years_since_last_promotion = 0 then '0 - Recently promoted'
when j.years_since_last_promotion <= 2 then '1-2 years'
when j.years_since_last_promotion <= 5 then '3-5 years'
else '6+ years'
end as promotion_gap,
count(*) as total_employees,
sum(e.attrition) as attritions,
round(sum(e.attrition) * 100.0 / count(*), 1) as attrition_rate,
round(avg(j.monthly_income), 0) as avg_income
from employees e join job_details j on e.employee_id = j.employee_id
group by promotion_gap order by attrition_rate desc;

#1. Employees who have gone 6+ years without a promotion show noticeably higher attrition than recently promoted employees. 
#2. But the relationship is not perfectly linear some employees are comfortable in their role without promotion. 

#Q9. Are employees who leave paid below average for their role?
with salary_quartiles as (
select e.employee_id, e.attrition, j.job_role, j.monthly_income,
ntile(4) over (partition by j.job_role order by j.monthly_income) as salary_quartile from employees e
join job_details j on e.employee_id = j.employee_id)
select job_role, salary_quartile,
count(*) as total,
sum(attrition) as attritions,
round(sum(attrition)*100.0/count(*), 1) as attrition_rate
from salary_quartiles
group by job_role, salary_quartile
order by job_role, salary_quartile;

#1. For most job roles, Quartile 1 (lowest paid 25% within that role) shows significantly higher attrition than Quartile 4 (highest paid 25%). 
#2. This proves that relative pay how you are paid compared to peers in the same roles matters as much as absolute pay level.

# Executive Summary
select d.department_name,
count(*) as headcount,
round(avg(j.monthly_income), 0) as avg_salary,
round(avg(j.years_at_company), 1) as avg_tenure_yrs,
round(avg(s.job_satisfaction), 2) as avg_job_satisfaction,
round(avg(s.work_life_balance), 2) as avg_work_life_balance,
sum(case when j.overtime = 'Yes' then 1 else 0 end) as overtime_headcount,
round(sum(case when j.overtime = 'Yes' then 1 else 0 end)*100/count(*), 1) as overtime_pct,
sum(e.attrition) as attritions,
round(sum(e.attrition)*100/count(*), 1) as attrition_rate
from employees e join departments d on e.department_id = d.department_id
join job_details j on e.employee_id = j.employee_id
join satisfaction s on e.employee_id  = s.employee_id
group by d.department_name order by attrition_rate desc;
