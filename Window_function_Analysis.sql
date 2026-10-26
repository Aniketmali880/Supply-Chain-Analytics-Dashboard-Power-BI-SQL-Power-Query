use bfsi;
-- Q1)Rank customers by annual income.
select customer_id,customer_name,annual_income,rank() over(order by annual_income desc) as rk from customers;

-- Q2)Rank branches by loan amount.
select b.branch_id,round(sum(l.loan_amount)/10000000,2) as lm,rank() over(order by sum(loan_amount) desc) as rnk from loan l
join branches b
on b.branch_id=l.branch_id
group by b.branch_id;

-- Q3)Top 5 customers in each state by loan amount.
with tabl1 as (select b.state,l.customer_id,round(l.loan_amount/100000,2) as lm,rank() over(partition by b.state order by l.loan_amount desc) as rnk from loan l
join branches b
on b.branch_id=l.branch_id)
select * from tabl1 where tabl1.rnk<=5;

-- Q4)Running total of monthly loan disbursement.
with tabl1 as (select date_format(loan_date,'%y-%m-01') as month_start,date_format(loan_date,'%b-%y') as mont_yr,round(sum(loan_amount)/100000,2) as lm_amt from loan
group by month_start,mont_yr order by month_start)
select mont_yr,lm_amt,sum(lm_amt) over(order by month_start) as running_total from tabl1; 

-- Q5)Monthly moving average of loan amounts.
with tabl1 as(select date_format(loan_date,'%y-%m-1') as strt_dt,date_format(loan_date,'%b-%y') as mnt_y,round(avg(loan_amount)/100000,2) as ln_amt from loan 
group by strt_dt,mnt_y
order by loan_date)
select mnt_y,ln_amt,round(avg(ln_amt) over(order by strt_dt),2) as running_avergae from tabl1;

-- Q6)Dense rank of branches by recovery amount.
select b.branch_id,round(sum(l.recover_amount)/10000000,2) as ram,dense_rank() over(order by sum(l.recover_amount) desc) as dns_rnk from loan l 
join branches b
on l.branch_id=b.branch_id
group by branch_id;

-- Q8)Highest loan in each loan type.
select * from (select loan_type,round(loan_amount/100000,2) as lm_amt,rank() over(partition by loan_type order by loan_amount desc) as rnk from loan) t1
where t1.rnk=1;

-- Q9)Lowest loan in each state.
select * from (select b.state,round(l.loan_amount/100000,2) as loan_amt,rank() over(partition by b.state order by loan_amount asc) as rnk from loan l
join branches b
on b.branch_id=l.branch_id)T1
where t1.rnk=1
order by t1.loan_amt;

-- Q10)Previous month's loan comparison using LAG().
with tabl1 as (select date_format(loan_date,'%b-%y') as mm_yy,round(sum(loan_amount)/10000000,2) as lm from loan
group by mm_yy order by loan_date)
select mm_yy,lm,lag(lm) over(order by mm_yy) as previous_value from tabl1;

-- Q11)Year-over-year loan growth using LAG().
with tabl1 as(select date_format(loan_date,'%b-%y') as mm_yy,round(sum(loan_amount)/10000000,2) as lm from loan
group by mm_yy order by loan_date),
tabl2 as(select mm_yy,lm,lag(lm) over() as previous_value from tabl1)
select *,round((lm-previous_value)/previous_value*100,2) as growth from tabl2;



