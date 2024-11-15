-- SQL Exercícios II

-- 39 Escreva um comando sql que liste idpeca-filho, nomepeca-filho, idpeca-pai, nomepeca-pai,
--    quantidade do filho que é necessária para o fabrico do pai. A Peça A (Produto Final) que não
--    tem pai também deve aparecer na listagem.

select h.idfilho "idpeca-filho",
       p_filho.nomepeca "nomepeca-filho", 
       p.idpeca "idpeca-pai", 
       p.nomepeca "nomepeca-pai", 
       h.qtd
    from peca p 
    left join hch h
        on p.idpeca = h.idpai
    left join peca p_filho
        on h.idfilho = p_filho.idpeca        
                      