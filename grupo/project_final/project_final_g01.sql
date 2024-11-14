/* 
    Matheus dos Anjos
    Nuno
    Diogo
    Jesus

    Data Management
*/

-- 1. Listar os títulos de todos os filmes dirigidos por Steven Spielberg.
select titulo
    from Filme 
    where realizador = 'Steven Spielberg';

-- 2. Listar todos os anos em que foi produzido um filme que recebeu uma classificação de 4 ou 5, e ordene-os por ordem crescente.
select distinct f.ano
    from Filme f 
    join Classificacao c 
        on f.fID = c.fID
    where c.estrelas in (4,5)
    order by f.ano;  

-- 3. Listar os títulos de todos os filmes que não têm nenhuma classificação.
select distinct f.titulo
    from Filme f 
    where not EXISTS
        (select c.cID
            from Classificacao c 
            where f.fID = c.fID);
