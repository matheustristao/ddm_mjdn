select upper(CompanyName) NewCompany from Customer;
select Cast(customerid as char) as customerid from Customer;
select ISNUMERIC(customerid) from Customer;
select month(getdate());
select datename(mm,getdate());

-- Challenge 1
select Title +lastname+ ' '+firstname as CustomerName, salesperson,phone
from Customer;

select cod_dept, nome_dept
    from departamento
    where exists (
        select *
            from empregado
            where departamento.cod_dept = empregado.cod_dept
    );

select count(distinct Color) from Product ;

select p1.name, p1.listprice, p1.productcategoryid
from product p1
where listprice = 
    (
        select max(p2.listprice)
            from product p2
        where p2.productcategoryid = p1.productcategoryid
    )
order by 3,1,2