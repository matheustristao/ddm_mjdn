-- 1
select DISTINCT City, StateProvince
    from Address;

-- 2
select top 10 Name, Weight
    from Product 
    order by Weight desc;   

-- 3
select Name, Weight
    from Product 
    order by Weight desc
    OFFSET 10 ROWS 
    FETCH NEXT 100 ROWS ONLY;