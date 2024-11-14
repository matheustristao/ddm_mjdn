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

-- 4. Escrever uma query que apresenta as classificações no seguinte formato: nome do crítico, título
--    do filme, nº de estrelas e data da classificação. Ordene o resultado por esta ordem: nome do
--    crítico, título do filme, nº de estrelas.            
select cr.nome, fi.titulo, cl.estrelas, cl.dataClassificacao
    from Critico cr 
    join Classificacao cl 
        on cl.cID = cr.cID
    join Filme fi 
        on fi.fID = cl.fID
    order by cr.nome, fi.titulo, cl.estrelas        

-- 5. Em todos os casos em que o mesmo crítico classificou o mesmo filme mais do que uma vez,
--    sendo uma classificação posterior superior a uma anterior, listar o nome do crítico e o título do filme

 select distinct cr.nome, fi.titulo
    from Classificacao cl 
    join (select cl_posterior.cID, cl_posterior.fID, cl_posterior.estrelas as estrelas_classificacao_posterior,cl_group.classificacao_posterior
            from Classificacao cl_posterior
            join (select cID, fID, max(dataClassificacao) classificacao_posterior
                    from Classificacao      
                    group by cID, fID
                    having count(*) > 1) cl_group
            on cl_posterior.cID = cl_group.cID
            and cl_posterior.fID = cl_group.fID     
            and cl_posterior.dataClassificacao = cl_group.classificacao_posterior) cl_classificacao_posterior   
    on cl.cID = cl_classificacao_posterior.cID
    and cl.fID = cl_classificacao_posterior.fID
    join (select cl_inicial.cID, cl_inicial.fID, cl_inicial.estrelas as estrelas_classificacao_inicial, cl_group.classificacao_inicial
            from Classificacao cl_inicial
            join (select cID, fID, min(dataClassificacao) classificacao_inicial
                    from Classificacao      
                    group by cID, fID
                    having count(*) > 1) cl_group
            on cl_inicial.cID = cl_group.cID
            and cl_inicial.fID = cl_group.fID     
            and cl_inicial.dataClassificacao = cl_group.classificacao_inicial) cl_classificacao_inicial 
    on cl.cID = cl_classificacao_inicial.cID
    and cl.fID = cl_classificacao_inicial.fID    
    join Filme fi 
        on fi.fID = cl.fID
    join Critico cr 
        on cr.cID = cl.cID        
    where cl_classificacao_inicial.estrelas_classificacao_inicial < cl_classificacao_posterior.estrelas_classificacao_posterior;  

-- 6. Para cada filme com pelo menos uma classificação, pesquisar a classificação máxima que lhe foi
--    atribuída. Listar o título do filme e a classificação máxima, ordenando por título do filme
select fi.titulo, Max_classificacao.estrelas
    from Filme fi 
    join 
    (select fID, MAX(estrelas) estrelas
        from Classificacao cl 
        group by fID) Max_classificacao
    on fi.fID = Max_classificacao.fID
    order by fi.titulo;

-- 7. Para cada filme com pelo menos uma classificação, listar os seus títulos e as médias das
-- classificações por ordem decrescente destas últimas. Listar por ordem alfabética os filmes com
-- as mesmas médias.
select fi.titulo, Avg_classificacao.estrelas
    from Filme fi 
    join 
    (select fID, avg(estrelas) estrelas
        from Classificacao cl 
        group by fID) Avg_classificacao
    on fi.fID = Avg_classificacao.fID
    order by Avg_classificacao.estrelas desc, fi.titulo asc;

-- 8. Listar os nomes de todos os críticos que contribuíram com 3 ou mais classificações.
select cr.nome
    from Critico cr 
    where cr.cID in (
        select cID
            from Classificacao
        group by cID
        having count(*) >= 3);

-- 9. Adicione à base de dados uma classificação de 4 estrelas da crítica Ana Santos para o filme Star Wars com data do dia em que foi atribuída essa classificação. Utilize um único comando de SQL.        

-- LINHA JÁ INSERIDA. NÃO CORRA NOVAMENTE, CASO CONTRÁRIO IRÁ INSERIR UMA LINHA DUPLICADA
-- Insert comentado para evitar nova inserção
/*
    insert into Classificacao (cID,fID,estrelas,dataClassificacao)
    values (
        (select cID from Critico where nome = 'Ana Santos'),
        (select fID from Filme where titulo = 'Star Wars'),
        4,
        CAST(GETDATE() AS DATE)
     );
*/

-- 10. Atualizar para 5 a classificação atribuída pela crítica Sara Martins ao filme Gone with the Wind
-- em 2011-01-27, porque a anterior estava errada. Não altere a data porque é a correção de um erro 
-- e utilize um único comando de SQL.
update Classificacao 
    set estrelas = 5 
    where cId = (select cId from Critico where nome = 'Sara Martins')
    and fID = (select fID from Filme where titulo = 'Gone with the Wind')
    and dataClassificacao = '2011-01-27';

-- 11. Para cada filme liste uma linha para cada classificação que obteve com os seguintes atributos:
-- título do filme, nome do realizador, nome do crítico, classificação, data da classificação,
-- classificação média do filme e classificação média do crítico, ordenado por nº do filme, nº do crítico.
select fi.titulo, fi.realizador, cr.nome, cl.estrelas, cl.dataClassificacao,Fi_avg.avg_classificacao_filme ,Cr_avg.avg_classificacao_critico
    from Filme fi 
    join Classificacao cl 
        on fi.fID = cl.fID
    join Critico cr
        on cr.cID = cl.cID
    join (
        select fi_aux.fID, AVG(estrelas) avg_classificacao_filme
            from Filme fi_aux 
            join Classificacao cl_aux 
                on fi_aux.fID = cl_aux.fID
            group by fi_aux.fID
    ) Fi_avg   
        on fi.fID = Fi_avg.fID     
    join (
        select cr_aux.cID, AVG(estrelas) avg_classificacao_critico
            from Critico cr_aux 
            join Classificacao cl_aux 
                on cr_aux.cID = cl_aux.cID
            group by cr_aux.cID
    ) Cr_avg
        on cr.cID = Cr_avg.cID;
        
-- 12. Para cada filme, listar o seu título e a diferença entre a classificação mais alta e mais baixa que
-- lhe foram atribuídas. Ordenar por ordem descendente da diferença de classificações e depois
-- pelo título do filme.
select fi.titulo, max(estrelas) - min(estrelas) as diferenca_classificacao
    from Filme fi 
    join Classificacao cl 
        on fi.fID = cl.fID
    group by fi.titulo 
    order by diferenca_classificacao desc, fi.titulo asc;

-- 13. Listar a diferença entre as médias das classificações dos filmes produzidos antes de 1980 e no
-- ano de 1980 e seguintes. Deve ser calculada a média da classificação para cada filme e depois
-- calculada a média das médias para os filmes anteriores a 1980 e os produzidos nos anos de 1980 e seguintes.

select 
    (select avg(fi_avg_geral.avg_classificacao_filme) avg_classificacao_filme
        from Filme fi
        join (select fi.fID,fi.ano,avg(estrelas) avg_classificacao_filme
                from Filme fi 
                join Classificacao cl 
                    on fi.fID = cl.fID
                group by fi.fID, fi.ano) fi_avg_geral
        on fi.fID = fi_avg_geral.fId
        and fi.ano < 1980 ) 
    -
    (select avg(fi_avg_geral.avg_classificacao_filme) avg_classificacao_filme
        from Filme fi
        join (select fi.fID,fi.ano,avg(estrelas) avg_classificacao_filme
                from Filme fi 
                join Classificacao cl 
                    on fi.fID = cl.fID
                 group by fi.fID, fi.ano) fi_avg_geral
        on fi.fID = fi_avg_geral.fId
        and fi.ano >= 1980) as diferenca_media_antes_1980_a_partir_1980

          
    

