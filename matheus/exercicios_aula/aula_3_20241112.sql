select upper(CompanyName) NewCompany from Customer;
select Cast(customerid as char) as customerid from Customer;
select ISNUMERIC(customerid) from Customer;
select month(getdate());
select datename(mm,getdate());

-- Challenge 1
select Title +lastname+ ' '+firstname as CustomerName, salesperson,phone
from Customer