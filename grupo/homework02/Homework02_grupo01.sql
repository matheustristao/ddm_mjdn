-- SQL Exercícios II

-- 39 Escreva um comando sql que liste idpeca-filho, nomepeca-filho, idpeca-pai, nomepeca-pai,
--    quantidade do filho que é necessária para o fabrico do pai. A Peça A (Produto Final) que não
--    tem pai também deve aparecer na listagem.

select h.idfilho "idpeca-filho",
       p_filho.nomepeca "nomepeca-filho", 
       p.idpeca "idpeca-pai", 
       p.nomepeca "nomepeca-pai", 
       h.qtd
    from peca p 
    left join hch h
        on p.idpeca = h.idpai
    left join peca p_filho
        on h.idfilho = p_filho.idpeca;

-- 52. Liste o ProductNumber, Name e média do preço de venda dos Produtos em que essa média é
--     superior à média do preço de venda de todos os produtos. Ordene por média do preço de venda
--     descendente.              

select ProductNumber, Name, avg(ListPrice) avg_listPrice
    from Product p
    group by ProductNumber, Name
    having avg(ListPrice) > (
        select avg(ListPrice)
            from Product
    )
    order by avg(ListPrice) desc;

-- 23. Liste o Código das categorias, o código do modelo, o código dos produtos e o somatório de
-- vendas por: código de categoria, (código de categoria, código do modelo),
-- (código de categoria, código do modelo, código de produto) e total geral    

select ProductCategoryID, ProductModelID, ProductNumber, sum(ListPrice) sum_ListPrice
    from Product
    group by rollup(ProductCategoryID, ProductModelID, ProductNumber);
                      