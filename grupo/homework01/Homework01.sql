-- Tópico 2

-- SQL - Exercícios II

--Exerc. 1 - Para cada Cliente (CompanyName), listar os diferentes Endereços identificando o Tipo de Endereço
select distinct cus.CompanyName, ca.AddressType,ad.AddressLine1, ad.AddressLine2, ad.City, ad.StateProvince, ad.CountryRegion, ad.PostalCode
    from Customer as cus
    join CustomerAddress as ca
        on cus.CustomerID = ca.CustomerID
    join Address as ad 
        on ca.AddressID = ad.AddressID   
    order by cus.CompanyName     

--Exerc. 4 - Listar os clientes (CustomerID e CompanyName) sem encomendas associadas (SalesOrderHeader)
select cus.CustomerID, cus.CompanyName, soh.CustomerID
    FROM Customer cus
    left join SalesOrderHeader soh
        on cus.CustomerID=soh.CustomerID 
        where soh.CustomerID is null


/* Exerc. 50 - Comando select para listar: idpeca-filho, nomepeça-filho, idpeca-pai,
nomepeça-pai, quantidade do filho para fabricar o pai. A peça A que é o topo da estrutura (produto
final) também deve ser listada. */

select pnf.idpeca "idpeca-filho", pnf.nomepeca "nomepeça-filho", pnp.idpeca "idpeca-pai", pnp.nomepeca "nomepeça-pai", pnf.qtd "quantidade-filho" 
    from pecanew pnf left join pecanew pnp 
    on pnf.idpai = pnp.idpeca

-- Tópico 3

-- Lab 4 - Challenge 2

-- Exerc. 1 - Retrieve customers with only a main office address

-- Rascunho 1
select distinct cus.CompanyName
    from Customer as cus
    where cus.CustomerID not in (
        select cus.CustomerID
            from Customer as cus
            inner join CustomerAddress as ca 
                on cus.CustomerID = ca.CustomerID  
                and ca.AddressType = 'Shipping' 
    )
order by 1    

-- Racunho 2
select distinct cus.CompanyName
    from Customer as cus
    join (
        select cus_aux.CustomerID
            from Customer as cus_aux
        except
        select ca.CustomerID
            from CustomerAddress as ca
            where ca.AddressType = 'Shipping'
        ) j
    on cus.CustomerID = j.CustomerID


      









