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
            where cus.CompanyName = 'Authentic Sales and Service')    

-- 51
select CompanyName, Title, FirstName, isnull(MiddleName,'') as MiddleName, LastName, isnull(Suffix,'') Sufix
    from Customer       