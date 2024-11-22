/* HOMEWORK 03 - TURMA 101 - GRUPO 01 */

/* Exercicio II - Exerc. 11
Liste o cliente (CustomerID, companyName) que colocou uma encomenda com o valor máximo
entre todas as encomendas. Liste também o salesorderid e o valor dessa encomenda. */

select customerid, companyname, salesorderid, totaldue, rank_totaldue
from
(select c.customerid, companyname, salesorderid, totaldue, rank() over (order by totaldue desc) rank_totaldue
from customer c join SalesOrderHeader sod
on c.CustomerID = sod.CustomerID) x
where rank_totaldue = 1

/* Exercicio II - Exerc. 12
Por CountryRegion liste o número de Clientes que fizeram encomendas cuja soma é superior a
$50000, bem como esse somatório por CountryRegion*/

select CountryRegion, count(*) 'numero de clientes', sum(sum_totaldue) 'soma de vendas por countryregion'
from
(select CountryRegion, c.customerid, sum(TotalDue) sum_totaldue
from Customer c
join CustomerAddress ca on c.CustomerID = ca.CustomerID
join Address a on ca.AddressID = a.AddressID
join SalesOrderHeader sod on c.CustomerID = sod.CustomerID
group by CountryRegion, c.CustomerID
having sum(TotalDue) > 50000) x
group by CountryRegion
