select cus.CompanyName, cus.Title, cus.FirstName, cus.LastName, cus.EmailAddress, cus.Phone, sum(sod.TotalDue) TotalDue
    from Customer cus
    inner join SalesOrderHeader sod 
        on cus.CustomerID = sod.CustomerID
    group by cus.CompanyName, cus.Title, cus.FirstName, cus.LastName, cus.EmailAddress, cus.Phone        
    order by cus.CompanyName;  

select *
    from (
        select cus.CompanyName, cus.Title, cus.FirstName, cus.LastName, cus.EmailAddress, cus.Phone, 
              (select sum(TotalDue) from SalesOrderHeader sod where sod.CustomerId = cus.CustomerID group by sod.CustomerId ) as Sum
            from Customer cus) as subquery
    where Sum is not null        
    order by CompanyName;        
