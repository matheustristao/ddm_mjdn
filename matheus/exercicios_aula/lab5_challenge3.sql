-- 1
select name, sum(LineTotal) as vendas
    from Product p
    join SalesOrderDetail sod 
    on p.ProductID = sod.ProductID
    group by name
    order by 2 desc;

-- 2 
select name, sum(LineTotal) as vendas
    from Product p
    join SalesOrderDetail sod 
    on p.ProductID = sod.ProductID
    where LineTotal > 1000
    group by name
    order by 2 desc;

-- 3 
select name, sum(LineTotal) as vendas
    from Product p
    join SalesOrderDetail sod 
    on p.ProductID = sod.ProductID
    where LineTotal > 1000
    group by name
    having sum(LineTotal) > 20000
    order by 2 desc;