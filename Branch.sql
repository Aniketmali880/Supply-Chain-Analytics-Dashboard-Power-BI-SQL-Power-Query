use bfsi;

select * from branches;
-- Q1)Total loan amount by branch.
select b.branch_id,round(sum(l.Loan_Amount)/10000000,0) as lm from branches b
join loan l
on b.branch_id=l.branch_id
group by b.branch_id order by lm desc;

-- Q2)Top 10 performing branches.
select b.branch_id,round(sum(l.loan_amount)/10000000,0) lm from branches b
join loan l
on b.branch_id=l.branch_id
group by b.branch_id order by lm desc
limit 10;
 
 -- Q3)Bottom 10 performing branches.
select b.branch_id,round(sum(l.loan_amount)/10000000,0) lm from branches b
join loan l
on b.branch_id=l.branch_id
group by b.branch_id order by lm asc
limit 10;

-- Q4)Branch-wise default rate.
with tabl1 as (select b.branch_id,sum(case when loan_status='Defaulted' then 1 else 0 end) defaulted,count(*) as total from branches b
join loan l
on b.branch_id=l.branch_id
group by b.branch_id order by defaulted desc)

select branch_id,defaulted,total,round(defaulted/total*100,0) as defrate from tabl1
order by defrate desc;

-- Q5)Branch-wise recovery amount.
select b.branch_id,round(sum(l.recover_amount)/10000000,2) as recovery from branches b
join loan l
on b.branch_id=l.branch_id
group by branch_id order by recovery desc;

-- Q6)Branch-wise outstanding balance.
select b.branch_id,round(sum(l.outstanding_balace)/10000000,2) as outstanding from branches b
join loan l
on b.branch_id=l.branch_id
group by branch_id order by outstanding desc;

-- Q7)Total customers served by each branch.
select b.branch_id,count(l.customer_id) as totalcus from branches b
join loan l
on b.branch_id=l.branch_id
group by branch_id order by totalcus desc;

-- Q8)Branch performance by region.
select b.region,round(sum(l.loan_amount)/10000000,0) as lm from branches b 
join loan l
on b.branch_id=l.branch_id
group by b.region order by lm desc;

-- Q9)Loan status distribution by branch.

select b.branch_id,l.loan_status,count(*) as ct from branches b 
join loan l
on b.branch_id=l.branch_id
group by b.branch_id,l.loan_status order by b.branch_id,ct desc;

-- Q10) Average loan amount by branch.

select b.branch_id,round(avg(loan_amount)/100000,2) as lm from branches b
join loan l
on l.branch_id=b.branch_id
group by b.branch_id order by lm desc;


 

