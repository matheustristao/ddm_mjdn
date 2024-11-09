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