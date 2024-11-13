select nome_emp, salario_base
from empregado join categoria
on empregado.cod_cat = categoria.cod_cat
where salario_base = (select max(salario_base) from categoria);

select p1.name, p1.listprice, p1.productcategoryid
from product p1
where listprice = 
    (
        select max(p2.listprice)
            from product p2
        where p2.productcategoryid = p1.productcategoryid
    )
order by 3,1,2;

select p1.name, p1.listprice, p1.productcategoryid
from product as p1
inner join ( select productcategoryid, max(listprice) listprice
            from product p2
            group by ProductCategoryID
    ) as p_join
on p_join.productcategoryid = p1.productcategoryid    
order by 3,1,2;

select productcategoryid, productmodelid, sum(linetotal) as salesvalue
from Product p join SalesOrderDetail sod 
    on p.productid = sod.ProductID
GROUP by GROUPING sets(ProductCategoryID,(ProductModelID),())
order by 1,2

SELECT 
    ProductCategoryID, 
    ProductModelID, 
    SUM(LineTotal) AS SalesValue
FROM Product p 
JOIN SalesOrderDetail sod 
    ON p.ProductID = sod.ProductID
GROUP BY  ROLLUP (ProductCategoryID, ProductModelID);
