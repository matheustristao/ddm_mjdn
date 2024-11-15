-- 1
select distinct cus.CompanyName, ca.AddressType,ad.AddressLine1, ad.AddressLine2, ad.City, ad.StateProvince, ad.CountryRegion, ad.PostalCode
    from Customer as cus
    join CustomerAddress as ca
        on cus.CustomerID = ca.CustomerID
    join Address as ad 
        on ca.AddressID = ad.AddressID   
    order by cus.CompanyName   

-- 2
select pr.ProductNumber, pr.Name, pm.catalogdescription, pd.description, pmpd.culture
    from Product pr 
    inner join ProductModel pm 
        on pr.ProductModelId = pm.ProductModelId   
    inner join ProductModelProductDescription pmpd 
        on pmpd.ProductModelID = pm.ProductModelId 
    inner join ProductDescription pd
        on pmpd.ProductDescriptionID = pd.ProductDescriptionID
    where pmpd.culture = 'en';                

-- 3 
SELECT Filho.Name Filho, Pai.Name Pai
FROM ProductCategory Filho 
JOIN ProductCategory Pai
ON Filho.parentproductcategoryid = Pai.productcategoryid;

-- 4
select cus.CustomerID, cus.CompanyName, soh.CustomerID
    FROM Customer cus
    left join SalesOrderHeader soh
        on cus.CustomerID=soh.CustomerID 
    where soh.CustomerID is null;

-- 5 
    select cus.CustomerID, cus.CompanyName
    into  g01.CustomerWOrders_matheus
    FROM Customer cus
    left join SalesOrderHeader soh
        on cus.CustomerID=soh.CustomerID 
    where soh.CustomerID is null;

-- 6     
select ProductNumber, Name
    from Product 
    where ProductCategoryID = 
    (
        select ProductCategoryID from Product where ProductNumber = 'BK-M82B-48'
    );

-- 7
select cus_cond.CustomerId, CompanyName
    from Customer cus_cond 
    join CustomerAddress cas_cond 
        on cus_cond.CustomerID = cas_cond.CustomerID
    join Address ad_cond 
        on cas_cond.AddressID = ad_cond.AddressID        
    where ad_cond.City in (        
        select ad.City
            from Customer cus
            join CustomerAddress cas 
                on cus.CustomerID = cas.AddressID
            join Address ad 
                on cas.AddressID = ad.AddressID                
            where cus.CompanyName = 'Authentic Sales and Service');

-- 8 
select ProductID, Name 
    from Product       
    where ProductCategoryID in (
        select ProductCategoryID
            from Product 
            where ProductID = '714'
    );

 -- 9

 select cus_cond.CustomerId, ad_cond.City
    from Customer cus_cond 
    join CustomerAddress cas_cond 
        on cus_cond.CustomerID = cas_cond.CustomerID
    join Address ad_cond 
        on cas_cond.AddressID = ad_cond.AddressID        
    where ad_cond.StateProvince in ( 
        select ad.StateProvince
            from Customer cus
            join CustomerAddress cas 
                on cus.CustomerID = cas.AddressID
            join Address ad 
                on cas.AddressID = ad.AddressID                
            where cus.CompanyName = 'Bikes and Motorbikes');

-- 10 
select pr.ProductID, ProductNumber, name
    from Product as pr 
    where not exists (
        select *
            from SalesOrderDetail as sod
            where sod.ProductID = pr.ProductID
    );

-- 14 
select count(*)
    from Customer cus 
    left join SalesOrderHeader soh 
        on cus.CustomerID = soh.CustomerID
    where soh.CustomerID is null;   

select count(*)
    from Customer cus 
    where not exists (
        select *
            from SalesOrderHeader soh 
            where cus.CustomerID = soh.CustomerID
    );   

-- 18 
select pr.ProductCategoryId, pr.ProductID, sum(LineTotal) vendas
    from Product pr        
    join SalesOrderDetail sod 
        on pr.ProductID = sod.ProductID     
    group by rollup (ProductCategoryId,pr.ProductID)
    order by 1,2;     

-- 20

select cus.CustomerID, cus.CompanyName, avg(soh.TotalDue) AVG_Vendas
    from SalesOrderHeader soh 
    join Customer cus 
        on cus.CustomerID = soh.CustomerID 
    group by cus.CustomerID, cus.CompanyName
    having avg(soh.TotalDue)  > (select avg(TotalDue) from SalesOrderHeader)

-- 21 
select pr.ProductCategoryId, pr.ProductID, sum(LineTotal) vendas
    from Product pr        
    join SalesOrderDetail sod 
        on pr.ProductID = sod.ProductID     
    group by cube (ProductCategoryId,pr.ProductID)
    order by 1,2;     

-- 22 
Select parentproductcategoryid, p.productcategoryid, p.productid, sum(linetotal)
from Product p 
join SalesOrderDetail sod
    on p.productid=sod.ProductID 
join ProductCategory pc
    on p.productcategoryid=pc.productcategoryid
group by rollup (parentproductcategoryid,p.productcategoryid, p.productid)

Select parentproductcategoryid, p.productcategoryid, p.productid, sum(linetotal)
from Product p 
join SalesOrderDetail sod
    on p.productid=sod.ProductID 
join ProductCategory pc
    on p.productcategoryid=pc.productcategoryid
group by GROUPING sets(parentproductcategoryid,(parentproductcategoryid,p.productcategoryid),(parentproductcategoryid,p.productcategoryid, p.productid),())

-- com cube

Select parentproductcategoryid, p.productcategoryid, p.productid, sum(linetotal)
from Product p 
join SalesOrderDetail sod
    on p.productid=sod.ProductID 
join ProductCategory pc
    on p.productcategoryid=pc.productcategoryid
group by cube (parentproductcategoryid,p.productcategoryid, p.productid)


Select parentproductcategoryid, p.productcategoryid, p.productid, sum(linetotal)
from Product p 
join SalesOrderDetail sod
    on p.productid=sod.ProductID 
join ProductCategory pc
    on p.productcategoryid=pc.productcategoryid
group by GROUPING sets(parentproductcategoryid,
                      (parentproductcategoryid,p.productcategoryid),
                      (parentproductcategoryid,p.productid),
                      (parentproductcategoryid,p.productcategoryid, p.productid),
                      (p.productcategoryid),
                      (p.productcategoryid,p.productid),
                      p.productid,
                      ());


-- 51
select CompanyName, Title, FirstName, isnull(MiddleName,'') as MiddleName, LastName, isnull(Suffix,'') Sufix
    from Customer       