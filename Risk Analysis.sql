use bfsi;
-- Q1)Overall default rate.
 select round((sum(case when loan_status='Defaulted' then 1 else 0 end)/count(*))*100,2) as default_rate from loan;

-- Q2)NPA ratio.
select round(sum(case when Default_flag=1 then loan_amount else 0 end)/sum(loan_amount),2) as NPA from Loan;


-- Q2)Branch wise npa Ratio
select b.branch_id, round(sum(case when l.Default_flag=1 then l.loan_amount else 0 end)/sum(l.loan_amount),2) as NPA from loan l
join branches b 
on l.branch_id=b.branch_id
group by b.branch_id order by NPA desc;

-- Q3)Region wise npa Ratio
select b.region, round(sum(case when l.Default_flag=1 then l.loan_amount else 0 end)/sum(l.loan_amount),2) as NPA from loan l
join branches b 
on l.branch_id=b.branch_id
group by b.region order by NPA desc;

-- Q4)Customers with credit score below 600.
select * from customers where credit_score<600
order by credit_score asc;

-- Q5)High-risk customers (credit score <600 and active loan).

select c.*,round(l.Loan_Amount/100000,2)  as loanamt from customers c
join loan l 
on c.customer_id=l.customer_id
where c.credit_score<600 and loan_status='Active'
order by c.credit_score asc;

-- Q6)Default rate by state.
select b.state,round((sum(case when l.loan_status='Defaulted' then 1 else 0 end)/count(*))*100,0) as default_rate from branches b 
join loan l 
on b.branch_id=l.Branch_ID
group by b.state order by default_rate desc; 

-- Q7)Default rate by occupation.
select c.occupation,round((sum(case when l.loan_status='Defaulted' then 1 else 0 end)/count(*))*100,0) as default_rate from customers c
join loan l 
on c.customer_id=l.customer_id
group by c.occupation order by default_rate desc; 


-- Q8)Default rate by age group.

select (case when c.age>=21 and c.age <= 30 then '21-30' 
when c.age>=31 and c.age <= 40 then '31-40' 
when c.age>=41 and c.age <= 50 then '41-50' 
when c.age>=51 and c.age <= 60 then '51-60' 
else '>60' end) as age_group,round(sum(case when l.loan_status='defaulted' then 1 else 0 end)/count(*)*100,2) as default_rate from customers c
join loan l 
on c.customer_id=l.customer_id
group by age_group order by default_rate desc;

-- Q9)Default rate by loan amount bucket.
select (case when l.loan_amount<=100000 then '<=1L'
when l.loan_amount>100000 and l.loan_amount<=1000000 then '>1L<=10L'
when l.loan_amount>1000000 and l.loan_amount<=2000000 then '>10L<=20L'
when l.loan_amount>2000000 and l.loan_amount<=3000000 then '>20L<=30L'
when l.loan_amount>3000000 and l.loan_amount<=4000000 then '>30L<=40L'
when l.loan_amount>4000000 and l.loan_amount<=5000000 then '>40L<=50L'
else '>50L' end) as Loan_bucket,round(sum(case when l.loan_status='Defaulted' then 1 else 0 end)/count(*)*100,2) as default_rate from loan l
group by loan_bucket order by default_rate desc;

-- Q10)Outstanding balance by state.
select b.state,round(sum(l.Outstanding_Balace)/10000000,2) as os from loan l 
join branches b
on b.branch_id=l.branch_id
group by b.state order by os desc;

-- Q11)Recovery percentage.

select round((sum(recover_amount)/sum(loan_amount))*100,2) as recovery from loan;

-- Q12)Loan Recovery by region
select b.region,round((sum(l.recover_amount)/sum(l.loan_amount))*100,2) as recovery from loan l 
join branches b 
on l.branch_id=b.branch_id
group by b.region order by recovery desc;

-- Q13)High-value loans (> ₹20 lakh).
select * from loan where loan_amount>2000000;

-- Q14)Branches with the highest NPAs.
select b.branch_id,b.region,b.state,round(sum(case when l.default_flag=1 then l.loan_amount else 0 end)/sum(l.loan_amount)*100,2) as defaultR from loan l
join branches b
on l.branch_id=b.branch_id
group by b.branch_id order by defaultR desc
limit 10;

-- Q15)Loan_Status and loan_type metrics
select loan_status,sum((case
when loan_type='Personal Loan' then 1 else 0 end)) as personal_loan,
sum((case
when loan_type='Vehicle loan' then 1 else 0 end)) as vehicle_loan,
sum((case
when loan_type='Education loan' then 1 else 0 end)) as educational_loan,
sum((case
when loan_type='Home Loan' then 1 else 0 end)) as personal_loan,
sum((case
when loan_type='Business Loan' then 1 else 0 end)) as business_loan,
sum((case
when loan_type='gold loan' then 1 else 0 end)) as gold_loan
from loan
group by loan_status;






 