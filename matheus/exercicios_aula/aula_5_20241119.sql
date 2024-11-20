select cus.CompanyName, cus.Title, cus.FirstName, cus.LastName, cus.EmailAddress, cus.Phone, sum(sod.TotalDue) TotalDue
    from Customer cus
    inner join SalesOrderHeader sod 
        on cus.CustomerID = sod.CustomerID
    group by cus.CompanyName, cus.Title, cus.FirstName, cus.LastName, cus.EmailAddress, cus.Phone        
    order by cus.CompanyName;  

select *
    from (
        select cus.CompanyName, cus.Title, cus.FirstName, cus.LastName, cus.EmailAddress, cus.Phone, 
              (select sum(TotalDue) 
                    from SalesOrderHeader sod 
                    where sod.CustomerId = cus.CustomerID 
                    group by sod.CustomerId ) as Sum
            from Customer cus) as subquery
    where Sum is not null        
    order by CompanyName;        

select cus.CompanyName, cus.Title, cus.FirstName, cus.LastName, cus.EmailAddress, cus.Phone, totalduesum
    from Customer cus
    join (select CustomerID, sum(TotalDue) totalduesum 
                    from SalesOrderHeader
                    group by CustomerID ) sod 
        on cus.CustomerID = sod.CustomerID      
    order by cus.CompanyName;   


WITH cte_mediaproduto AS
    (Select ProductNumber, avg(unitprice) mediaproduto
        from salesorderdetail sod 
        join product p 
            on p.productid=sod.productid
        group by ProductNumber
    )

    Select ProductNumber, mediaproduto As MaxMedia
        from cte_mediaproduto
        where mediaproduto= (Select max(mediaproduto) from cte_mediaproduto);

