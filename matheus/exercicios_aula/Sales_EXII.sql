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

-- 13

with media_produto as (
    select pr.ProductID, ProductModelID, avg(LineTotal) avg_line_total
        from Product pr 
        join SalesOrderDetail sod 
            on sod.ProductID = pr.ProductID
        group by  pr.ProductID, ProductModelID 
)
select avg(avg_line_total) as "Média das médias"
from media_produto;

select avg(avg_line_total) as "Média das médias"
from (
select pr.ProductID, ProductModelID, avg(LineTotal) avg_line_total
    from Product pr 
    join SalesOrderDetail sod 
        on sod.ProductID = pr.ProductID
    group by  pr.ProductID, ProductModelID ) as media_das_medias

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

-- 43
select ProductNumber, StandardCost, SalesOrderID, UnitPrice, 
    avg(UnitPrice) over (partition by productnumber) as "media preço produto"
    from Product pr
    join salesOrderDetail sod 
        on sod.ProductID = pr.ProductID
        order by 1;

with avg_sales_product as (
    select ProductNumber, avg(UnitPrice) AVG_Unit_Price
    from Product pr
    join salesOrderDetail sod 
        on sod.ProductID = pr.ProductID
    group by ProductNumber         
) 

select pr.ProductNumber, StandardCost, SalesOrderID, UnitPrice, AVG_Unit_Price
    from Product pr
    join salesOrderDetail sod 
        on sod.ProductID = pr.ProductID
    join avg_sales_product  asp 
        on pr.ProductNumber = asp.ProductNumber  
    order by 1; 


select pr.ProductNumber, StandardCost, SalesOrderID, UnitPrice, AVG_Unit_Price
    from Product pr
    join salesOrderDetail sod 
        on sod.ProductID = pr.ProductID
    join (
        select ProductNumber, avg(UnitPrice) AVG_Unit_Price
            from Product pr
            join salesOrderDetail sod 
                on sod.ProductID = pr.ProductID
            group by ProductNumber   
    )  asp 
        on pr.ProductNumber = asp.ProductNumber  
    order by 1; 


select pr.ProductNumber, StandardCost, SalesOrderID, UnitPrice, (select avg(UnitPrice) 
                                                                    from Product pr_aux
                                                                    join salesOrderDetail sod 
                                                                        on sod.ProductID = pr_aux.ProductID
                                                                    where pr_aux.ProductID = pr.ProductID
                                                                    group by ProductNumber ) as avg_unit
    from Product pr
    join salesOrderDetail sod 
        on sod.ProductID = pr.ProductID
    order by 1; 

select pr.ProductNumber, StandardCost, SalesOrderID, UnitPrice, AVG_Unit_Price
    from Product pr
    join salesOrderDetail sod 
        on sod.ProductID = pr.ProductID
    join (
        select ProductNumber, avg(UnitPrice) AVG_Unit_Price
            from Product pr
            join salesOrderDetail sod 
                on sod.ProductID = pr.ProductID
            group by ProductNumber   
    )  asp 
        on pr.ProductNumber = asp.ProductNumber  
    order by 1; 

-- 26 

select pr.ProductModelID, pr.ProductId, sum(sod.LineTotal) sum_line_total,
       RANK() over(partition by ProductModelID order by sum(sod.LineTotal) desc) as rank_prod
    from Product pr 
    join SalesOrderDetail sod 
        on pr.ProductID = sod.ProductID
    group by pr.ProductModelID, pr.ProductId;

-- 27 
select * from (
select pc.Name as "Category Name", pr.Name as "Product Name", pr.ListPrice, 
       rank() over (partition by pc.Name order by pr.ListPrice asc) rank_pr
    from ProductCategory pc 
    join Product pr 
        on pc.ProductCategoryID = pr.ProductCategoryID) rank_select
    where rank_pr = 1
    order by 1;

-- 28
    select * from Classificacao

    insert into Classificacao (cID,fID,estrelas,dataClassificacao)
    values (
        (select cID from Critico where nome = 'Sara Martins'),
        (select fID from Filme where titulo = 'Avatar'),
        4,
        '2021-05-25'
         ),
         (
        (select cID from Critico where nome = 'Daniel Morgado'),
        (select fID from Filme where titulo = 'E.T.'),
        5,
        CAST(GETDATE() AS DATE)
         );    

-- 44

with cus_sum as (
    select CustomerID, sum(TotalDue) totalduesum 
        from SalesOrderHeader
        group by CustomerID 
    ) 

    select cus.CompanyName, cus.Title, cus.FirstName, cus.LastName, cus.EmailAddress, cus.Phone, totalduesum
        from Customer cus  
        join cus_sum cs
            on cus.CustomerID = cs.CustomerID      
    order by cus.CompanyName; 


select cus.CompanyName, cus.Title, cus.FirstName, cus.LastName, cus.EmailAddress, cus.Phone, totalduesum
    from Customer cus
    join (select CustomerID, sum(TotalDue) totalduesum 
                    from SalesOrderHeader
                    group by CustomerID ) sod 
        on cus.CustomerID = sod.CustomerID      
    order by cus.CompanyName;   

select cus.CompanyName, cus.Title, cus.FirstName, cus.LastName, cus.EmailAddress, cus.Phone, 
       sum(TotalDue) over (partition by cus.CustomerID order by cus.CustomerID) as SumTotalDue
    from Customer cus 
    join SalesOrderHeader soh   
        on cus.CustomerID = soh.CustomerID
    order by cus.CompanyName;        


-- 51
select CompanyName, Title, FirstName, isnull(MiddleName,'') as MiddleName, LastName, isnull(Suffix,'') Sufix
    from Customer     

-- 53 
select pr.ProductID, sod.SalesOrderID, sod.OrderQty, sod.LineTotal, 
       avg(sod.LineTotal) over(order by pr.Productid) as avg_vendas
from Product pr     
join SalesOrderDetail sod 
    on pr.ProductID = sod.ProductID