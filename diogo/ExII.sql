-- Exercícios II

/* 1. Para cada Cliente (CompanyName), listar os diferentes Endereços identificando o Tipo de Endereço*/

SELECT CompanyName,AddressLine1,AddressLine2,AddressType
from customer c 
left join CustomerAddress ca on c.CustomerID=ca.CustomerID 
left join Address a on ca.AddressID=a.AddressID
-- Esta considera todos os clientes quer tenham morada ou não

SELECT CompanyName,AddressLine1,AddressLine2,AddressType
from customer c 
join CustomerAddress ca on c.CustomerID=ca.CustomerID 
join Address a on ca.AddressID=a.AddressID
-- Esta apenas considera os clientes que têm morada

/*2.
Para cada Produto listar o seu nº e a sua designação (ProductNumber, Name), bem como a designação (productmodel.catalogdescription) 
e descrição (productdescription.description) do respetivo modelo na língua (culture) inglesa (en)*/

select productnumber, p.name, CatalogDescription, pd.description
from product p
join productmodel pm on p.ProductModelID=pm.ProductModelID 
join ProductModelProductDescription pmpd on pm.ProductModelID=pmpd.ProductModelID
join ProductDescription pd on pmpd.ProductDescriptionID=pd.ProductDescriptionID
where pmpd.Culture = 'en'

/*3.
Listar todas as identificações e designações de Categorias de Produto, 
juntamente com as identificações e designações das Categorias de Nível Superior, 
ordenadas por identificação de Categoria de Nível Superior*/

select pc1.ProductCategoryid, pc1.name, pc1.ParentProductCategoryID, pc2.name
    FROM ProductCategory pc1 
    left join ProductCategory pc2 
    on pc1.ParentProductCategoryID=pc2.ProductCategoryID

/*4.
Listar os clientes (CustomerID e CompanyName) sem encomendas associadas (SalesOrderHeader)*/

--Nested Query

select customerid, companyname
from customer c
where customerid not in (select c.CustomerID
from customer c join SalesOrderHeader soh on c.CustomerID=soh.CustomerID)

select c.customerid, companyname
from customer c left join SalesOrderHeader soh on c.CustomerID=soh.CustomerID
where soh.CustomerID is null

/*5
Crie uma tabela CustomerWOrders com os atributos CustomerID, CompanyName dos clientes sem nenhuma encomenda associada

Create table CustomerWOrdersDG
(CustomerID int primary key,
CompanyName nvarchar(128))

insert into CustomerWOrdersDG (CustomerID,CompanyName)
select c.customerid, companyname
from customer c 
left join SalesOrderHeader soh on c.CustomerID=soh.CustomerID
where soh.CustomerID is null*/

/*6
Para o Produto com ProductNumber = ‘BK-M82B-48’ selecione os restantes Produtos da mesma Categoria (ProductNumber e Name)*/

select ProductNumber, Name, ProductCategoryID
from Product P
where ProductCategoryID= (
    select ProductCategoryid
    from Product P
    where ProductNumber='BK-M82B-48'
)

/*7.
Listar o CustomerID e CompanyName dos Clientes (Customers) que têm instalações na mesma cidade
que o Cliente com CompanyName= ‘Authentic Sales and Service’*/

select c.customerid, companyname,City
from Customer c join CustomerAddress ca on c.CustomerID=ca.CustomerID join Address a on ca.AddressID=a.AddressID
where City = (
    select City
    from CustomerAddress ca join Address a on ca.AddressID=a.AddressID join Customer c on c.CustomerID=ca.CustomerID
    where CompanyName='Authentic Sales and Service'
)

/*8
Liste todos os produtos (Productid, name) da mesma categoria que o produto com productid=714*/

select p.productid,name, ProductCategoryID 
from product p 
where ProductCategoryID=(
    select ProductCategoryID
    from Product p 
    where ProductID=714
)

/*9
Liste CustomerID, companyname e city de todos os clientes que tem morada no mesmo 
stateprovince do cliente com companyname= ‘Bikes and Motorbikes’*/

select c.customerid, companyname, city,StateProvince
from customer c join CustomerAddress ca on c.CustomerID=ca.CustomerID join Address a on ca.AddressID=a.AddressID
where StateProvince=(
    select StateProvince
    from customer c join CustomerAddress ca on c.CustomerID=ca.CustomerID join Address a on ca.AddressID=a.AddressID
    where CompanyName='Bikes and Motorbikes'
)

/*10.
Listar o ProductID, o ProductNumber e o Name dos Produtos sem encomendas associadas, utilizando o operador Exists*/

select p.productid, productnumber, name 
from Product p 
where not exists(
    select *
    from SalesOrderDetail sod
    where p.ProductID=sod.productid
)

/*11.
Liste o cliente (CustomerID, companyName) que colocou uma encomenda com o valor máximo entre todas as encomendas. 
Liste também o salesorderid e o valor dessa encomenda.*/

--subquery
select c.customerid, companyname, salesorderid, totaldue
from customer c join SalesOrderHeader soh on c.CustomerID=soh.CustomerID
where totaldue=(
    select max(TotalDue)
    from customer c join SalesOrderHeader soh on c.CustomerID=soh.CustomerID
)

/*12.
Por CountryRegion liste o número de Clientes que fizeram encomendas cuja soma é superior a $50000, 
bem como esse somatório por CountryRegion*/

select countryregion, count(c.customerid) countcustomer, sum(totaldue) sumtotaldue
from customer c join CustomerAddress ca on c.CustomerID=ca.CustomerID join Address a on a.AddressID=ca.AddressID join SalesOrderHeader soh on c.CustomerID=soh.CustomerID
where TotalDue > 50000
GROUP by CountryRegion

/*13
liste a média das médias das vendas para o par modelo, produto.*/

--Inline view
select avg(avglinetotal) avgavglinetotal 
from (
    select productmodelid,p.productid, avg(linetotal) avglinetotal
        from Product p join SalesOrderDetail sod on p.ProductID=sod.ProductID
        group by productmodelid,p.productid) subquery

--cte
with cte_avglinetotal (productmodelid,productid,avglinetotal) AS
(select productmodelid,p.productid, avg(linetotal) avglinetotal
from Product p join SalesOrderDetail sod on p.ProductID=sod.ProductID
        group by productmodelid,p.productid)

select avg(avglinetotal) as avgavglinetotal 
from cte_avglinetotal;


/*14.
Indique quantos customers existem sem nenhuma encomenda associada.*/

select count(customerid) countcustomer
    from customer c
    where not exists(
        select *
        from SalesOrderHeader soh 
        where c.CustomerID=soh.CustomerID)

/*15.
Liste o código das categorias, o código dos produtos e o somatório de vendas (código de categoria, código de produto)*/

select productcategoryid, p.productid, sum(linetotal)
    from Product p 
    join SalesOrderDetail sod 
    on p.ProductID=sod.ProductID
    group by rollup(ProductCategoryID,p.ProductID)

/*16.
Para cada nome de Categoria de Produtos liste o máximo do preço de venda dos produtos que a compõem.*/

select pc.name, max(listprice)
    from Product p 
    join ProductCategory pc 
    on p.ProductCategoryID=pc.ProductCategoryID
    group by pc.Name

select pc.name, p.name, 
max(ListPrice) over (partition by pc.name) as maxlistprice
from Product p join ProductCategory pc on p.ProductCategoryID=pc.ProductCategoryID
order by ListPrice desc

/*17.
Identifique o(s) ProductNumber do(s) produto(s) com a máxima média de preço unitário de venda (unitprice), bem como essa média.*/

--subquery
select productnumber, avg(UnitPrice) avgunitprice
from Product p join SalesOrderDetail sod on p.ProductID=sod.ProductID
group by productnumber
having avg(unitprice)= (
    select max(UnitPrice)
    from Product p join SalesOrderDetail sod on p.ProductID=sod.ProductID
)

--cte 
with cte_mediaproduto (productnumber,mediaproduto) AS
(select productnumber, avg(unitprice) mediaproduto
from product p 
join SalesOrderDetail sod
on p.ProductID=sod.ProductID
group by productnumber)

select productnumber, mediaproduto maxmedia
from cte_mediaproduto
where mediaproduto=(
    select max(mediaproduto)
    from cte_mediaproduto
)


/*18.
Liste o Código das categorias, o código dos produtos e o somatório de vendas por: código de categoria, 
(código de categoria, código de produto) e total geral*/

select p.productcategoryid, p.productid, sum(linetotal)
    from product p 
    join ProductCategory pc 
    on p.ProductCategoryID=pc.ProductCategoryID 
    join SalesOrderDetail sod 
    on p.ProductID=sod.ProductID
    group by rollup (p.ProductCategoryID,p.ProductID)

/*19. 
Liste a média das vendas em valor para o par (modelo, produto), 
para os casos em que essa média é superior à média das vendas do respetivo modelo.*/

select ProductModelID, p.ProductID, avg(LineTotal)
    from Product p 
    join SalesOrderDetail sod 
    on p.ProductID=sod.ProductID
    group by p.ProductModelID, p.ProductID
    having avg(linetotal)>(
        select avg(LineTotal)
        from Product psub
        join SalesOrderDetail sodsub
        on psub.ProductID=sodsub.ProductID
        where psub.ProductModelID=p.ProductModelID
    )
    order by ProductModelID, p.ProductID

/*20.
Liste os clientes (CustomerID, companyname e média de compras) cuja média de compras é superior à média de todas as compras efetuadas*/

select c.CustomerID, companyname, avg(totaldue) avgtotaldue
from customer c join SalesOrderHeader soh on c.CustomerID=soh.CustomerID
group by c.CustomerID, companyname
having avg(TotalDue)>(
select avg(totaldue)
from SalesOrderHeader soh) 

/*21.
Liste o código das categorias, o código dos produtos e o somatório de vendas por: código de categoria, código de produto, 
(código de categoria, código de produto) e total geral, ordenados por código de categoria, código de produto*/

select ProductCategoryid, p.productid, sum(linetotal)
from Product p 
join SalesOrderDetail sod 
on p.ProductID=sod.ProductID
group by cube (ProductCategoryID,p.ProductID)
order by ProductCategoryID, p.ProductID

/*22.
Analise o seguinte Select e substitua ‘Group by cube’ por ‘Group by Grouping sets’ 
Select parentproductcategoryid, p.productcategoryid, p.productid, sum(linetotal) 
from Product p 
join SalesOrderDetail sod 
on p.productid=sod.ProductID 
join ProductCategory pc 
on p.productcategoryid=pc.productcategoryid 
group by cube (parentproductcategoryid,p.productcategoryid, p.productid)*/

select parentproductcategoryid, p.productcategoryid, p.productid, sum(linetotal)
from Product p 
join SalesOrderDetail sod
on p.ProductID=sod.ProductID
join ProductCategory pc
on p.ProductCategoryID=pc.ProductCategoryID
group by GROUPING sets(
    ParentProductCategoryID,
    p.ProductCategoryID,
    p.ProductID,
    (ParentProductCategoryID, p.ProductCategoryID),
    (ParentProductCategoryID, p.ProductID),
    (p.ProductCategoryID,p.ProductID),
    (parentproductcategoryid, p.productcategoryid, p.productid),
    ()
    )

/*23
Liste o Código das categorias, o código do modelo, o código dos produtos e o somatório de vendas por: 
código de categoria, (código de categoria, código do modelo), 
(código de categoria, código do modelo, código de produto) e total geral*/

--Grouping sets 
select ProductCategoryID, ProductModelID, p.ProductID, sum(LineTotal)
from product p 
join SalesOrderDetail sod
on p.ProductID=sod.ProductID
group by GROUPING sets (
    ProductCategoryID,
    (ProductCategoryID,ProductModelID), 
    (ProductCategoryID,ProductModelID,p.ProductID),
    ()
    )
order by ProductCategoryID, ProductModelID, p.ProductID

--Rollup
select ProductCategoryID, ProductModelID, p.ProductID, sum(LineTotal)
from product p 
join SalesOrderDetail sod
on p.ProductID=sod.ProductID
group by rollup (ProductCategoryID, ProductModelID, p.ProductID)
order by ProductCategoryID, ProductModelID, p.ProductID

/*24.
Liste o Código das categorias, o código do modelo, o código dos produtos e o somatório de vendas por: 
código de categoria, código de modelo, código de produto, 
(código de categoria, código do modelo), (código de categoria, código de produto),
(código de modelo, código de produto) e 
(código de categoria, código do modelo, código de produto) e total geral*/

--grouping sets
select ProductCategoryID, ProductModelID, p.ProductID
from product p
join SalesOrderDetail sod 
on p.ProductID=sod.ProductID
group by GROUPING SETS(
    ProductCategoryID,
    ProductModelID, 
    p.ProductID,
    (ProductCategoryID, ProductModelID),
    (ProductCategoryID, p.ProductID),
    (ProductModelID,p.ProductID),
    (ProductCategoryID, ProductModelID, p.ProductID),
    ()
)

--cube
select ProductCategoryID, ProductModelID, p.ProductID
from product p
join SalesOrderDetail sod 
on p.ProductID=sod.ProductID
group by cube (ProductCategoryID, ProductModelID, p.ProductID)

/*25.
Encontre as encomendas que contemplam todos os produtos do modelo 37.*/

--Com a grande ajuda do 5º colega, não me ocorreria comparar a contagem dos produtos entre query e subquery
select SalesOrderID
from SalesOrderDetail sod
where ProductID in (
    select ProductID
    from product p 
    where ProductModelID='37')
group by SalesOrderID
having count(distinct sod.ProductID)= 
(select (count(distinct p.ProductID))
from Product p
where ProductModelID='37')

/*26.
Para cada modelo de produto liste o total e o ranking das vendas de cada produto ordenado por ordem descendente de vendas.*/

select productmodelid, p.productid, sum(linetotal), 
rank() over(partition by productmodelid order by sum(linetotal) desc) salesrank
from product p join SalesOrderDetail sod on p.productid=sod.productid 
group by ProductModelID, p.productid

/*27.
Para cada ProductCategory (name) listar o(s) Product(s) (name) que tem o menor preço de venda (listprice), 
bem como esse preço, ordenando por ProductCategory (name).*/

select category, product, listprice, rank
from (
    select pc.name category, p.name product, listprice,
    rank() over(partition by pc.name 
    order by listprice asc) rank 
    from  Product p join  ProductCategory pc on pc.ProductCategoryID=p.ProductCategoryID) X
where rank=1 

/*28.
Insira uma classificação de 4 estrelas ao filme ‘Avatar’ atribuída pela crítica ‘Sara Martins’ no dia 2021-05-25 
e de 5 estrelas pelo crítico ‘Daniel Morgado’ no filme ‘E.T.’ efetuada hoje. 
Depois faça um Select à Classificação para verificar a correção da inserção.*/

/*insert into classificacao (cid, fid, estrelas, dataclassificacao) 
values (
    (select cid from critico c where nome='Sara Martins'),
    (select fid from filme f where titulo='Avatar'),
    4,
    '2021-05-25'
)

insert into classificacao (cid, fid, estrelas, dataclassificacao) 
values (
    (select cid from critico c where nome= 'Daniel Morgado'),
    (select fid from filme f where titulo='E.T.'),
    5,
    GETDATE()
)

select cid,fid,estrelas, dataclassificacao
from classificacao cl*/

/*29.
Crie uma tabela Aluno2 com a seguinte estrutura Aluno2 (idaluno, NIFaluno, nome,dataNasc) 
Em que idaluno é uma PK surrogate com início em 1 e salto de 1 em 1 e NIFaluno é uma chave candidata. 
Insira algumas linhas na tabela Aluno*/

/*create table Aluno2
(idaluno int identity (1,1) primary key,
NIFaluno int unique not null,
nome varchar(30),
dataNasc date)

insert into aluno2 (NIFaluno,nome,dataNasc)
VALUES(123456,'André','2024-02-01')

insert into aluno2 (NIFaluno,nome,dataNasc)
VALUES(123486,'Andreia','2024-03-01')*/

/*30
30.1.
Crie as seguintes tabelas
• PG (idPG, nome) • EdicaoPG (idPG, edicao, dataInicio, dataFim) 
Pretende-se que caso a PG seja anulada, também o sejam as suas edições e caso idPG em PG seja alterado, 
também o seja nas suas edições. Insira várias linhas nas tabelas e veja o que acontece quando apagar uma PG ou quando alterar idPG.*/

/*Create table PGnew 
(idPG int primary key,
nome varchar(50))

Create table EdicaoPGnew
(idPG int references PGnew
on delete cascade
on update cascade,
edicao int,
dataInicio date,
dataFim date,
primary key (idPG,edicao))*/                                                                                      

/*34.
Crie uma View Sales que contenha para cada productid o somatório das vendas*/

Create view salesdg as 
select p.Productid, sum(linetotal) sumlinetotal
from Product p join SalesOrderDetail sod on p.ProductID=sod.ProductID
group by p.ProductID
