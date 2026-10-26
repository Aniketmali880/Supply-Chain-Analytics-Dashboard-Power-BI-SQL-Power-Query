-- Q1)Number of customers by state.
select state,count(customer_id) as cd from customers
group by state order by cd desc;

-- Q2)Number of customers by gender.
select gender,count(customer_id) as cd from customers
group by gender order by cd desc;

-- Q3)Average annual income by occupation
select Occupation,round(avg(annual_income)/100000,2) as ai from customers
group by occupation order by ai desc;

-- Q4)Average credit score by state
select state,round(avg(credit_score),2) as cs from customers
group by state order by cs desc;

-- Q5)Top 10 customers with the highest annual income.
select customer_name,round(Annual_income/100000,2) from customers
order by Annual_income desc limit 10;

-- Q6)Top 10 customers with the highest credit score.

select customer_name,credit_score from customers
order by credit_score desc limit 10;

-- Q7)Distribution of customers by age group.
select  case when 
age>=21 and age <=30 then '21-30'
when age>=31 and age<=40 then '31-40'
when age>=41 and age<=50 then '41-50'
when age>=51 and age<=60 then '51-60'
else '>60'
end as Age_group,count(*) as ct
from customers
 group by age_group
 order by ct desc;

-- Q8) Average loan amount by gender.

select c.gender,round(avg(l.loan_amount)/100000,2) as lm from loan l
join customers c
on l.customer_id=c.customer_id
group by c.gender order by lm desc;

-- Q9)Average loan amount by occupation.

select c.occupation,round(avg(l.loan_amount)/100000,2) la from loan l 
join customers c 
on l.customer_id=c.customer_id
group by c.Occupation order by la desc;

-- Q10) Which occupation has the highest default rate?

select c.occupation,count(*) as ct from loan l
join customers c
on l.customer_id=c.customer_id
where l.Loan_Status='Defaulted'
group by c.Occupation order by ct desc;