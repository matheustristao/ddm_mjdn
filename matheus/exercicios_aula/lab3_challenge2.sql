select cus.firstname, cus.lastname, soh.SalesOrderId, soh.TotalDue
    from g01.Customer as cus
    left join g01.SalesOrderHeader as soh
    on cus.CustomerId = soh.CustomerId
    order by SalesOrderId desc;

select cus.CustomerId, cus.CompanyName, cus.firstname, cus.lastname, cus.Phone
    from g01.Customer as cus    
    left join g01.CustomerAddress as ca
        on cus.CustomerId = ca.CustomerId
        and ca.AddressID is null;
