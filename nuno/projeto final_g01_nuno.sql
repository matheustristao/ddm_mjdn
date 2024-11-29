-- PROJET FINAL - G01

/* Pergunta 1
Listar os títulos de todos os filmes dirigidos por Steven Spielberg*/

select titulo
    from Filme
    where realizador = 'Steven Spielberg';

/* Pergunta 2
Listar todos os anos em que foi produzido um filme que recebeu uma classificação de 4 ou 5, e
ordene-os por ordem crescente. */

select distinct ano
    from Filme f
    left join Classificacao c
        on  f.fID = c.fID
    where estrelas in (4,5)
    order by ano asc;

/* Considerámos que como pede para listar apenas os anos e não quais os filmes ou as 
estrelas, então aplicámos o distinct para não ter anos repetidos na listagem.*/

/* Pergunta 3
Listar os títulos de todos os filmes que não têm nenhuma classificação*/

select distinct titulo
    from Filme f
    left join Classificacao cl
        on  f.fID = cl.fID
    where estrelas is null;


/* Pergunta 4
Escrever uma query que apresenta as classificações no seguinte formato: nome do crítico, título
do filme, nº de estrelas e data da classificação. Ordene o resultado por esta ordem: nome do
crítico, título do filme, nº de estrelas.*/

select nome 'nome do crítico', titulo 'título do filme', estrelas 'nº de estrelas', dataclassificacao 'data da classificação'
    from Filme f
    join Classificacao cl
        on f.fID = cl.fID
    join Critico cr
        on cl.cID = cr.cID
    order by nome, titulo, estrelas

/* Pergunta 5
Em todos os casos em que o mesmo crítico classificou o mesmo filme mais do que uma vez,
sendo uma classificação posterior superior a uma anterior, listar o nome do crítico e o título do
filme.*/

select nome, titulo
    from Filme f
    join Classificacao cl1
        on f.fID = cl1.fID
    join Critico cr
        on cl1.cID = cr.cID
    join Classificacao cl2
        on cl1.fID = cl2.fID
    where cl1.cID = cl2.cID 
        and cl1.dataClassificacao<cl2.dataClassificacao
        and cl1.estrelas<cl2.estrelas;

/* Pergunta 6
Para cada filme com pelo menos uma classificação, pesquisar a classificação máxima que lhe foi
atribuída. Listar o título do filme e a classificação máxima, ordenando por título do filme.*/

select titulo, max(estrelas) max_classificacao
    from Filme f
    join classificacao cl
        on f.fid = cl.fid
    group by titulo
    order by titulo;

/* Pergunta 7
Para cada filme com pelo menos uma classificação, listar os seus títulos e as médias das
classificações por ordem decrescente destas últimas. Listar por ordem alfabética os filmes com
as mesmas médias.*/

select titulo, avg(estrelas) classificacao_media
    from Filme f
    join classificacao cl
        on f.fid = cl.fid
    group by titulo
    order by classificacao_media desc, titulo asc;

/* Pergunta 8
Listar os nomes de todos os críticos que contribuíram com 3 ou mais classificações.*/

select nome
    from Filme f
    join Classificacao cl
        on f.fid = cl.fID
    join Critico cr
        on cl.cid = cr.cID
    group by nome
    having count(f.fid) >= 3;

/* Pergunta 9
Adicione à base de dados uma classificação de 4 estrelas da crítica Ana Santos para o filme Star
Wars com data do dia em que foi atribuída essa classificação. Utilize um único comando de
SQL.*/

insert into Classificacao (cID, fID, estrelas, dataClassificacao)
values (
    (select cID from Critico where nome = 'Ana Santos'),
    (select fID from filme where titulo = 'Star Wars'),
    4,
    getdate()
);

/* Pergunta 10
Atualizar para 5 a classificação atribuída pela crítica Sara Martins ao filme Gone with the Wind
em 2011-01-27, porque a anterior estava errada. Não altere a data porque é a correção de um erro
e utilize um único comando de SQL.*/

update Classificacao
set estrelas = 5
where ciD = (select cID from critico where nome = 'Sara Martins')
    and fiD = (select fID from Filme where titulo = 'Gone with the Wind')
    and dataClassificacao = '2011-01-27';


