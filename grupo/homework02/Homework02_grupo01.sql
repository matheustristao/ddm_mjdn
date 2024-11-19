-- Homework 02:

-- SQL Exercícios II

/* Exerc. 39 - Escreva um comando sql que liste idpeca-filho, nomepeca-filho, idpeca-pai, nomepeca-pai, quantidade
do filho que é necessária para o fabrico do pai. A Peça A (Produto Final) que não tem pai também deve aparecer na 
listagem. */

select p_filho.idpeca "idpeca-filho",
       p_filho.nomepeca "nomepeca-filho", 
       p_pai.idpeca "idpeca-pai", 
       p_pai.nomepeca "nomepeca-pai", 
       h.qtd "quantidade filho"
    from peca p_filho 
    left join hch h
        on p_filho.idpeca = h.idfilho
    left join peca p_pai
        on h.idpai = p_pai.idpeca;

/* Exerc. 52 - Liste o ProductNumber, Name e média do preço de venda dos Produtos em que essa média é
superior à média do preço de venda de todos os produtos. Ordene por média do preço de venda descendente. */

select ProductNumber, Name, avg(UnitPrice) "média do preço de venda"
    from Product p left join SalesOrderDetail sod on p.ProductID=sod.ProductID
    group by ProductNumber, Name
    having avg(UnitPrice) > (
        select avg(UnitPrice)
            from SalesOrderDetail
    )
    order by avg(UnitPrice) desc;

/* Exerc. 19 - Liste a média das vendas em valor para o par (modelo, produto), para os casos em que essa
média é superior à média das vendas do respetivo modelo */

select p1.ProductModelID, p1.ProductID, avg(sod1.LineTotal) "Média das vendas"
    from product p1
    join SalesOrderDetail sod1
        on p1.ProductID = sod1.ProductID
    group by p1.ProductModelID, p1.ProductID
    having avg(sod1.LineTotal) >
        (select avg(sod2.LineTotal)
            from SalesOrderDetail sod2
            join product p2
                on sod2.ProductID = p2.ProductID
            where p2.ProductModelID = p1.ProductModelID);

/* Exerc. 23 - Liste o Código das categorias, o código do modelo, o código dos produtos e o somatório de
vendas por: código de categoria, (código de categoria, código do modelo),
(código de categoria, código do modelo, código de produto) e total geral */

select p.ProductCategoryID, p.ProductModelID, p.ProductID, sum(LineTotal) "Somatório de Vendas"
    from Product p join SalesOrderDetail sod
    on p.productID = sod.ProductID
    group by rollup(p.ProductCategoryID, p.ProductModelID, p.ProductID);

-- Usando o Grouping Sets

select p.ProductCategoryID, p.ProductModelID, p.ProductID, sum(LineTotal) "Somatório de Vendas"
    from Product p join SalesOrderDetail sod
    on p.productID = sod.ProductID
    group by Grouping sets (p.ProductCategoryID, (p.ProductCategoryID, p.ProductModelID),
        (p.ProductCategoryID, p.ProductModelID, p.ProductID), ());
                      
/* Exerc 24 - Liste o Código das categorias, o código do modelo, o código dos produtos e o somatório de
vendas por: código de categoria, código de modelo, código de produto, (código de categoria,
código do modelo), (código de categoria, código de produto), (código de modelo, código de produto) e
(código de categoria, código do modelo, código de produto) e total geral */

select p.ProductCategoryID, p.ProductModelID, p.ProductID, sum(LineTotal) "Somatório de Vendas"
    from Product p join SalesOrderDetail sod
    on p.productID = sod.ProductID
    group by cube(p.ProductCategoryID, p.ProductModelID, p.ProductID);

-- Usando o Grouping Sets

select p.ProductCategoryID, p.ProductModelID, p.ProductID, sum(LineTotal) "Somatório de Vendas"
    from Product p join SalesOrderDetail sod
    on p.productID = sod.ProductID
    group by grouping sets (p.ProductCategoryID, p.ProductModelID, p.ProductID, (p.ProductCategoryID, p.ProductModelID)
    , (p.ProductCategoryID, p.ProductID), (p.ProductModelID, p.ProductID)
    , (p.ProductCategoryID, p.ProductModelID, p.ProductID),());