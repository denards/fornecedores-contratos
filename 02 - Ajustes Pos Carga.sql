UPDATE participante p
   SET item_id = i.id
  FROM item i
 WHERE p.item_codigo = i.item_codigo;

delete
  from participante
where item_id is null;

UPDATE participante p
SET cnpj_codigo = i.vencedor_cnpj
FROM item i
WHERE p.item_id = i.id;

DELETE FROM item i
USING participante p
WHERE i.id = p.item_id
  AND p.vencedor_flag = 'S'
  AND (p.cnpj_codigo IS NULL OR i.vencedor_cnpj <> p.cnpj_codigo);


ALTER TABLE item DROP COLUMN vencedor_cnpj;
