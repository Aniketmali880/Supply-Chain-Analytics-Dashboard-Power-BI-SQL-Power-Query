-- Q1)Total number of customers.

Select distinct(count(*)) from customers;

-- Q2)Total number of loans issued.
select distinct(count(loan_id)) from loan;

-- Q3)Total loan amount disbursed.

select round(sum(Loan_Amount)/10000000.0,2) as corore from loan;

-- Q4)Average loan amount.

select round(avg(loan_amount)/100000,2) as lakh from loan;

-- Q5)Average interest rate.
select round(avg(intrest_rate),2) as intr from loan;

-- Q6)Total outstanding balance.

select round(sum(outstanding_balace)/10000000.0,2) as oscr from loan;

-- Q7)Total recovery amount.

select round(sum(Recover_amount)/10000000,2) as rcamt from loan;

-- Q8)Count of loans by loan status.

select Loan_status,count(loan_id) ld from loan
group by loan_status
order by ld desc;

-- Q9)Count of loans by loan type.

select loan_type,count(loan_id) as ld from loan
group by loan_type order by ld desc;

-- Q10)Total loans issued each year.

select year(loan_date) as loan_year,count(loan_id) as ld from loan

group by year(loan_date)  order by ld desc;