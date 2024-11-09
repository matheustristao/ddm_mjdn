select CountryRegion, count(*) number_country_region
    from Address
    group by CountryRegion
    order by 2;

with 
    SalesOrderHeaderCte as (
        select SalesOrderID, SalesOrderNumber 
            from SalesOrderHeader
    ),
    SalesOrderDetailCte as (
        select SalesOrderID, UnitPrice, OrderQty, LineTotal
            from SalesOrderDetail
    ),
    ProductCte as (
        select productId, Name, Color, StandardCost
            from Product
    )

    select sh.SalesOrderNumber, pr.Name, pr.Color, pr.StandardCost, si.UnitPrice,si.OrderQty,si.LineTotal
        from SalesOrderHeaderCte as sh
        inner join SalesOrderDetail as si 
            on sh.SalesOrderID = si.SalesOrderID
        inner join ProductCte as pr 
            on si.ProductID = pr.ProductID
        where sh.SalesOrderNumber = 'SO71782';   

with 
    SalesOrderDetailCte as (
        select ProductID, count(*) as count_product, sum(LineTotal) as LineTotal
            from SalesOrderDetail
            group by ProductID
    ),

    ProductCte as (
        select ProductID, Name
            from Product
    )

    select  
          CASE 
            WHEN CHARINDEX(',', Name) > 0 
                THEN SUBSTRING(Name, 1, CHARINDEX(',', Name) - 1) 
            ELSE Name 
           END as Name, 
          sales.count_product, sales.LineTotal
        from SalesOrderDetailCte as sales
        inner join ProductCte as pr 
            on sales.ProductID = pr.ProductID
        order by 3 desc;
        