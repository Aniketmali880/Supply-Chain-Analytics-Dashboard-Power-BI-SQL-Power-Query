use bfsi;

-- Q1)Create a view for branch performance.
create view branch_performance as
select b.branch_id,count(l.loan_id) as total_loan,round(sum(l.loan_amount)/10000000,2) as loan_amount,
round(avg(loan_amount)/100000,2) as averege_loan,count(distinct(c.customer_id)) as total_customer,
round(sum(case when default_flag=1 then l.loan_amount else 0 end)/10000000,2) as default_amt,
round(round(sum(case when l.default_flag=1 then l.loan_amount else 0 end)/10000000,2)/(round(sum(l.loan_amount)/10000000,2))*100,2) as default_rate,
round(sum(l.recover_amount)/100000,2) as recovery_amt,
round((round(sum(l.recover_amount)/10000000,2)/round(sum(l.loan_amount)/10000000,2))*100,2) as recovery_rate from loan l
join branches b
on l.branch_id=b.branch_id
join customers c
on l.customer_id=c.customer_id
group by b.Branch_id
order by total_loan desc;
select * from branch_performance;

-- Q2)Create a view for customer risk profile.
create view risk_analysis as 
select c.*,l.loan_amount,l.default_flag,
(case when credit_score<500 then 'High Risk' when credit_score>=500 and credit_score<=700 then 'Medium risk' else 'Low risk' end )as Risk_status
 from customers c
join loan l
on c.customer_id=l.customer_id;
select * from risk_analysis where risk_status='High Risk'
order by loan_amount desc;
select * from risk_analysis where risk_status='Medium Risk'
order by loan_amount desc;
select * from risk_analysis where risk_status='Low Risk'
order by loan_amount desc;
select risk_status,count(*) as ct from risk_analysis
group by risk_status order by ct desc;

-- Q3)Use a CTE to identify high-risk customers.

with risk_table as(select c.customer_id,c.customer_name,c.occupation,c.credit_score,
(case when c.credit_score<500 then 'High risk' when c.credit_score>=500 and credit_score<=700 then 'Medium risk' else 'Low risk' end) as Risk_Status,
l.loan_amount,l.loan_status from customers c
join loan l
on c.customer_id=l.customer_id)
select * from risk_table where risk_status='High risk'
order by loan_amount desc;

-- Q4)Find customers with multiple loans.
select l.customer_id,count(*) as ct,c.customer_name,c.age,c.occupation,c.credit_score from loan l
join customers c
on l.customer_id=c.customer_id
group by l.customer_id 
having count(*)>1;

-- Q5) Customers who never defaulted.
 select * from customers c where c.customer_id not in (select distinct(l.customer_id) from loan l where l.default_flag=1);
 
 -- Q6)Customers who defaulted more than once.
 select * from customers c where c.customer_id in(select l.customer_id from loan l where l.default_flag=1
 group by customer_id having count(*)>1);

-- Q7)Find duplicate customers.
select customer_id,count(*) as ct from customers
group by customer_id having count(*)>1;

-- Q8)Branch contribution to total loan portfolio.
select b.branch_id,round(sum(l.loan_amount)/10000000,2) as lm,
round((round(sum(l.loan_amount)/10000000,2)/(select round(sum(l2.loan_amount)/10000000,2) from loan l2))*100 ,2)as Contribution
 from branches b 
join loan l
on b.branch_id=l.branch_id
group by b.branch_id
order by contribution desc;

-- Q9)Percentage contribution by loan type.
select loan_type,round(sum(loan_amount)/10000000,2) as lm,
round(round(sum(loan_amount)/10000000,2)/(select round(sum(l2.loan_amount)/10000000,2) from loan l2)*100,2) as contribution
 from loan
group by loan_type
order by contribution desc;

-- Q10)State-wise loan market share.
select b.state,round(sum(l.loan_amount)/10000000,2) lm,round((round(sum(l.loan_amount)/10000000,2)/(select round(sum(l2.loan_amount)/10000000,2) from loan l2))*100,2) as contribution
from loan l
join branches b
on l.branch_id=b.branch_id
group by b.state order by contribution desc;

-- Q11) branch_wise Average days between loan applications (if dates available).
with tabl1 as(select branch_id,loan_date,lag(loan_date) over(partition by branch_id order by branch_id,loan_date) as previous_date from loan),
tabl2 as(select branch_id,date(loan_date) as Loan_date,date(previous_date) as previous_date,
datediff(loan_date,previous_date) as day_diff from tabl1 where previous_date is not null)
select branch_id,round(avg(day_diff),0) as day_diff from tabl2
group by branch_id order by day_diff desc;

-- Q12)Pivot loan status by loan type.
select loan_type,loan_status,count(*) as statistics from loan
group by loan_type,loan_status order by loan_type,statistics desc;

-- Q13)Stored procedure to fetch branch performance.
DELIMITER //
create procedure branch_performance(in p_branch_id varchar(20))
begin
select round(sum(loan_amount)/10000000,2) as loan_amt,round(sum(recover_amount)/10000000,2)as recovery,round(sum(outstanding_balace)/10000000,2) as outstanding_balnce,
round(sum(default_flag),2) as total_defaulter,round(sum(case when default_flag=1 then loan_amount else 0 end)/10000000,2) as deafult_amount from loan
where branch_id=p_branch_id ;
end //
DELIMiTER ;
call branch_performance('B011');

select * from loan;

describe loan;
alter table loan
modify default_flag tinyint;

select sum(loan_amount) from loan where default_flag=1;