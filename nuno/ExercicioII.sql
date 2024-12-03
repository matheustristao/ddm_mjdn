/* Exercicio 1
Para cada Cliente (CompanyName), listar os diferentes Endereços identificando o Tipo de
Endereço*/

select CompanyName,AddressLine1,AddressLine2,AddressType
    from customer c
    left join CustomerAddress ca
        on c.CustomerID = ca.CustomerID
    left join Address a on ca.AddressID=a.AddressID;
-- Esta considera todos os clientes quer tenham morada ou não

SELECT CompanyName,AddressLine1,AddressLine2,AddressType
    from customer c 
    join CustomerAddress ca
        on c.CustomerID=ca.CustomerID 
    join Address a
        on ca.AddressID=a.AddressID;
-- Esta considera apenas os clientes que tenham morada

/* Exercicio 2
Para cada Produto listar o seu nº e a sua designação (ProductNumber, Name), bem como a
designação (productmodel.catalogdescription) e descrição (productdescription.description) do
respetivo modelo na língua (culture) inglesa (en) */

select ProductNumber, p.Name, pm.catalogdescription, pd.description
    from Product p
    join productmodel pm
        on p.ProductModelID = pm.ProductModelID
    join ProductModelProductDescription pmpd
        on pm.ProductModelID = pmpd.ProductDescriptionID
    join ProductDescription pd
        on pmpd.ProductDescriptionID = pd.ProductDescriptionID
    where culture = 'en';

/* Exercicio 3
Listar todas as identificações e designações de Categorias de Produto, juntamente com as
identificações e designações das Categorias de Nível Superior, ordenadas por identificação de
Categoria de Nível Superior*/

select pc1.productcategoryid, pc1.name , pc1.parentproductcategoryid, pc2.name
    from ProductCategory pc1
    left join ProductCategory pc2
        on pc2.ProductCategoryID = pc1.ParentProductCategoryID
    order by pc1.ProductCategoryID;

/* Exercicio 4
Listar os clientes (CustomerID e CompanyName) sem encomendas associadas
(SalesOrderHeader)*/

select c.CustomerID, CompanyName
    from Customer c
    left join SalesOrderHeader soh
        on c.CustomerID = soh.CustomerID
    where SalesOrderID is null;

/* Exercicio 5
Crie uma tabela CustomerWOrders com os atributos CustomerID, CompanyName dos clientes
sem nenhuma encomenda associada*/

create table CustomerWOrders_NP
    (CustomerID int primary key
    , CompanyName varchar(max));

insert into CustomerWOrders_NP
select c.CustomerID, CompanyName
    from Customer c
    left join SalesOrderHeader soh
        on c.CustomerID = soh.CustomerID
    where SalesOrderID is null;

/* Exercicio 6
Para o Produto com ProductNumber = ‘BK-M82B-48’ selecione os restantes Produtos da mesma
Categoria (ProductNumber e Name)*/

select ProductNumber, Name
    from product p
    where ProductCategoryID = (
        select ProductCategoryID
            from Product
            where ProductNumber = 'BK-M82B-48'
        )

/* Exercicio 7
Listar o CustomerID e CompanyName dos Clientes (Customers) que têm instalações na mesma
cidade que o Cliente com CompanyName= ‘Authentic Sales and Service’*/

select c.CustomerID, CompanyName
    from customer c
    join CustomerAddress ca
        on c.CustomerID = ca.CustomerID
    join Address a
        on ca.AddressID = a.AddressID
    where city = (
        select city
            from customer c
            join CustomerAddress ca
                on c.CustomerID = ca.CustomerID
            join Address a
                on ca.AddressID = a.AddressID
            where CompanyName = 'Authentic Sales and Service'
            );

/* Exercicio 8
Liste todos os produtos (Productid, name) da mesma categoria que o produto com productid=714*/

select ProductID, Name
    from product p
    where ProductCategoryID = (
        select ProductCategoryID
            from Product
            where Productid = 714
        )

/* Exercicio 9
Liste CustomerID, companyname e city de todos os clientes que tem morada no mesmo
stateprovince do cliente com companyname= ‘Bikes and Motorbikes’*/

select c.CustomerID, CompanyName, city
    from customer c
    join CustomerAddress ca
        on c.CustomerID = ca.CustomerID
    join Address a
        on ca.AddressID = a.AddressID
    where StateProvince = (
        select StateProvince
            from customer c
            join CustomerAddress ca
                on c.CustomerID = ca.CustomerID
            join Address a
                on ca.AddressID = a.AddressID
            where CompanyName = 'Bikes and Motorbikes'
            );

/* Exercicio 10
Listar o ProductID, o ProductNumber e o Name dos Produtos sem encomendas associadas,
utilizando o operador Exists*/

select productid, productnumber, name
    from product p
    where not exists (
        select *
            from SalesOrderDetail sod
            where p.ProductID = sod.ProductID
            );

/* Exercicio 11
Liste o cliente (CustomerID, companyName) que colocou uma encomenda com o valor máximo
entre todas as encomendas. Liste também o salesorderid e o valor dessa encomenda.*/

select c.CustomerID, companyName, salesorderid, totaldue
    from customer c
    join SalesOrderHeader soh
        on c.CustomerID = soh.CustomerID
        where totaldue = (
            select max(totaldue)
                from customer c1
                join SalesOrderHeader soh
                    on c1.CustomerID = soh.CustomerID
            );

