-- 1
Insert into Product (ProductId, Name, ProductNumber, StandardCost,ListPrice, ProductCategoryID,SellStartDate)
    values 
    (
        (select max(ProductId)+1 from Product),
        'LED Lights',
        'LT_L123',
        2.56,
        12.99,
        37,
        current_date)

select * from Product where name = 'LED Lights';     

-- 2 

select * from ProductCategory;

insert into ProductCategory(ProductCategoryID, ParentProductCategoryID, Name)
    values (
        (select max(ProductCategoryID)+1 from ProductCategory),
        4,
        'Bells and Horns - Matheus'
    );

--

select * from ProductCategory;

update Product
    set ListPrice = ListPrice + ListPrice*0.1 
    where ProductCategoryID = (select ProductCategoryID from ProductCategory where name = 'Bells and Horns - Matheus')

-- 3 
delete from  Product 
    where  ProductCategoryID = (select ProductCategoryID from ProductCategory where name = 'Bells and Horns - Matheus');  

delete from  ProductCategory where name = 'Bells and Horns - Matheus';   