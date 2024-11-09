select * from empregado;
select distinct cod_dept from empregado;

select *
    from g01.empregado emp, g01.departamento dpt
    where emp.cod_emp = dpt.cod_dept;

select *
    from g01.empregado emp
    inner join g01.departamento dpt
    on emp.cod_emp = dpt.cod_dept;    