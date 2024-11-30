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

/*Pergunta 11
Para cada filme liste uma linha para cada classificação que obteve com os seguintes atributos: 
título do filme, nome do realizador, nome do crítico, classificação, data da classificação, 
classificação média do filme e classificação média do crítico, ordenado por nº do filme, nº do crítico.*/

-- Using Correlated Subquery in SELECT clause
select titulo, realizador, nome, estrelas, dataClassificacao,
(select avg(estrelas) from Classificacao cl where f.fID=cl.fID) avg_estrelas_filme, 
(select avg(estrelas) from Classificacao cl where cl.cID=cr.cid) avg_estrelas_critico
from Filme f 
    join Classificacao cl 
    on f.fID=cl.fID 
    join Critico cr 
    on cl.cID=cr.cID
order by f.fID, cr.cid

-- Using Window Functions (Partition by)
select titulo, realizador, nome, estrelas, dataClassificacao,
avg(estrelas) over (partition by titulo order by f.fid) as avg_estrelas_filme, 
avg(estrelas) over (partition by nome order by cr.cid) as avg_estrelas_critico
from Filme f 
    join Classificacao cl on f.fID=cl.fID 
    join Critico cr on cl.cID=cr.cID
order by f.fID, cr.cid

/*Pergunta 12
Para cada filme, listar o seu título e a diferença entre a classificação mais alta e mais baixa que lhe foram atribuídas. 
Ordenar por ordem descendente da diferença de classificações e depois pelo título do filme.*/

select titulo, max(estrelas)-min(estrelas) diferenca_estrelas
from filme f 
    join Classificacao cl 
    on f.fID=cl.fID
group by titulo
order by diferenca_estrelas desc, titulo
-- Uma vez que apenas é mencionada a orientação da ordem para as dif. de classificações não especificámos ordem para o título

/*Pergunta 13
Listar a diferença entre as médias das classificações dos filmes produzidos antes de 1980 e no ano de 1980 e seguintes. 
Deve ser calculada a média da classificação para cada filme e depois calculada a média das médias para os filmes anteriores a 1980 
e os produzidos nos anos de 1980 e seguintes.*/

select(select avg(avg_estrelas_ant1980) avg_avg_antes1980 from (select distinct titulo, avg(estrelas) over (PARTITION by titulo order by f.fid) avg_estrelas_ant1980
from filme f join Classificacao cl on f.fID=cl.fID
where ano < 1980) x)
-
(select avg(avg_estrelas_pos1980) avg_avg_depois1980 from (select distinct titulo, avg(estrelas) over (PARTITION by titulo order by f.fid) avg_estrelas_pos1980
from filme f join Classificacao cl on f.fID=cl.fID
where ano >= 1980) y) 'dif avg_avg_antes1980 avg_avg_depois1980'

/* Pergunta 14
Para todos os realizadores de mais de um filme, listar o seu nome e os títulos dos filmes que realizaram, 
ordenados por nome do realizador, título do filme.*/

select realizador, titulo
    from Filme f 
    where realizador in
        (select realizador
            from Filme f
            group by realizador    
            having count(f.fid) > 1)
    order by realizador,titulo;

/*Pergunta 15
Listar o(s) título(s) do(s)filme(s) com a maior média de classificações, bem como essa média.*/

with cte_mediafilme (titulo, media_estrelas) as 
(select titulo, avg(estrelas) media_estrelas
from Filme f join Classificacao cl on f.fID=cl.fid
group by titulo
)
select titulo, media_estrelas as max_media_estrelas
from cte_mediafilme
where media_estrelas=(select max(media_estrelas) from cte_mediafilme)

/*Pergunta 16
Para cada par filme, crítico (título do filme e nome do crítico) liste o nº de classificações 
(um filme pode ser avaliado mais do que uma vez por um crítico, em datas diferentes). 
Listar também o nº de classificações por filme e por crítico, bem como o nº total de classificações.*/

select titulo, nome, count(estrelas) n_estrelas
    from filme f 
    join Classificacao cl 
    on f.fid=cl.fid
    join Critico cr 
    on cr.cid=cl.cID
    group by cube (titulo,nome)
    order by titulo, nome;

/*Pergunta 17
Apresente o ranking dos filmes por ordem descendente de média de classificação.*/

select titulo, avg(estrelas) avg_estrelas,
dense_rank() over (order by avg(estrelas) desc) rank_estrelas
from filme f join Classificacao cl on f.fID=cl.fID
group by titulo
--Consideramos que é um dense_rank porque o rank está atribuído ao valor da média de estrelas e não à posição da linha

/*Pergunta 18
Para cada realizador, apresente o ranking dos seus filmes por ordem descendente de média de classificação.*/

select realizador, titulo, avg(estrelas) avg_estrelas,
dense_rank() over(partition by realizador, titulo order by avg(estrelas)desc) rank_titulo
from filme f join Classificacao cl on f.fID=cl.fID
group by realizador,titulo

/*Pergunta 19
Acrescente à Tabela Filme os atributos duracao (int) e lucro_bruto (numeric (5,2). 
Crie as tabelas Ator (aid, nome) e Ator_Filme (aid, fid) que representam respetivamente os atores e os filmes em que participaram. 
Tipos de dados dos atributos: aid (int), nome (varchar(30)). 
Não se esqueça de identificar as chaves primárias e estrangeiras nas tabelas criadas.*/

/*Alter table filme
add duracao int, 
lucro_bruto numeric (5,2)

create table Ator
(aid int primary key,
nome varchar(30))

(aid int,
create table Ator_Filme
fid int, 
primary key (aid,fid),
foreign key (aid) references Ator,
foreign key (fid) references Filme
on delete cascade
on update cascade);*/
