select productid, name, color, listprice,
    rank() over(PARTITION by color order by listprice desc) rank_price
from product
where color is not null;    

select productid, name, color, listprice,
    row_number() over(PARTITION by color order by listprice desc) rank_price
from product
where color is not null;  

select nome_dept, nome_emp, salario_base
    from (
        select nome_dept, nome_emp, salario_base, 
                ROW_NUMBER() over(partition by nome_dept order by salario_base asc) row_num
            from empregado e 
            join departamento d 
                on e.cod_dept = d.cod_dept
            join categoria c 
                on e.cod_cat = c.cod_cat) x 
where row_num = 1;                