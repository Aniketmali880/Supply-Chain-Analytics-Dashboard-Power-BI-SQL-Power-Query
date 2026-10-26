use bfsi;
select * from loan;
-- Total loan amount by loan type
select loan_type,round(sum(loan_amount)/10000000,2) as lm from loan 
group by loan_type order by lm desc;

-- Average EMI by loan type.
select loan_type,round(avg(emi),2)as ema from loan
group by loan_type order by ema desc;

-- Average interest rate by loan type.
select loan_type,round(avg(intrest_rate),2) as it from loan
group by loan_type order by it desc;

-- Loan approval count by loan type.
select loan_type,count(Loan_Status) as lt from loan where loan_status='Approved'
group by loan_type order by lt desc;

-- loan approval rate
with tbl1 as (select loan_type,count(*) as total,sum(case when loan_status='Approved' then 1 else 0 end) as apr from loan
group by loan_type order by apr desc)
select loan_type,total,apr,round((apr/total)*100) as rate from tbl1;

-- Loan rejection count by loan type.
select loan_type,count(loan_status) as ls from loan where loan_status='Rejected'
group by loan_type order by ls desc;

-- loan rejection rate
with tabl2 as(select loan_type,count(*) as total,sum(case when loan_status='Rejected' then 1 else 0 end) as rj from loan 
group by loan_type order by rj desc)
select loan_type,total,rj,round((rj/total)*100,2) as rte from tabl2;

-- Defalut count by loan_type

select loan_type,count(*) as ct from loan where loan_status='Defaulted'
group by loan_type order by ct desc;

-- Default rate
with tabl3 as(select loan_type,count(*) as total,sum(case when loan_status='defaulted' then 1 else 0 end) as df from  loan
group by loan_type order by df desc)
select loan_type,df,total,round((df/total)*100,0) as rate from tabl3
order by rate desc;

-- Recovery amount by loan type.
select loan_type,round(sum(Recover_Amount)/10000000,2) as ream from loan
group by loan_type order by ream desc;

-- Outstanding balance by loan type.
select loan_type,round(sum(outstanding_balace)/10000000,0) as outstanding from loan
group by loan_type order by outstanding desc;

-- Monthly loan disbursement trend.
select month(loan_date) as mt,round(sum(loan_amount)/10000000,0) as lm from loan
group by mt order by lm desc;

-- Yearly loan disbursement trend.
select year(loan_date) as yr ,round(sum(loan_amount)/10000000,0) as rs from loan
group by yr order by rs desc;

-- Top 10 highest loan amounts.
select * from loan
order by loan_amount desc limit 1,10;

-- Average tenure by loan type.
select loan_type ,round(avg(tenure_month),0) as tm from loan
group by loan_type order by tm desc;
