use bfsi;
Load data infile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Loans.csv'
into table Loan
fields terminated by ','
enclosed by '"'
lines terminated by'\n'
ignore 1 rows;
#Loading customer file

load data infile "C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Customers.csv"
into table  customers
fields terminated by ","
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;
#uploading branches table
load data infile "C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Branches.csv"
into table branches
fields terminated by ","
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;
select * from branches;

#Adding Date_dimension
load data infile "C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Date_Dimension.csv"
into table date_dimensions
fields terminated by ","
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

select * from date_dimensions;

select * from customers;
