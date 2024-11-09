select nif_al, nome_al from g01.Aluno
EXCEPT
SELECT nif_doc, nome_Doc FROM g01.Docente;

select nif_al, nome_al from g01.Aluno
union
SELECT nif_doc, nome_Doc FROM g01.Docente;

select DISTINCT addresstype from customerAddress;

select * from productCategory;

select distinct * from ProductModelProductDescription