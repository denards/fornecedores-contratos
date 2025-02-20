DROP VIEW IF EXISTS vw_licitacoes_detalhadas CASCADE;

CREATE VIEW vw_licitacoes_detalhadas AS
SELECT 
    l.id AS licitacao_id,
    l.numero AS licitacao_numero,
    l.ano AS licitacao_ano,
    l.mes AS licitacao_mes,
    l.num_processo,
    l.objeto,
    l.situacao,
    l.data_compra,
    l.data_abertura,
    l.valor AS licitacao_valor,
    
    -- Informações do órgão responsável
    o.codigo AS orgao_codigo,
    o.nome AS orgao_nome,
    
    -- Localização da licitação
    m.descricao AS municipio,
    u.sigla AS uf,
    
    -- Modalidade da licitação
    mod.descricao AS modalidade,
    
    -- Detalhes dos itens adquiridos
    i.item_codigo,
    i.item_descricao,
    i.item_qtde,
    i.item_valor,
    
    -- Informações do fornecedor vencedor
    cnpj.codigo AS fornecedor_cnpj,
    cnpj.nome AS fornecedor_nome,
    p.vencedor_flag
    
FROM licitacao l
INNER JOIN orgao o ON l.orgao_codigo = o.codigo
INNER JOIN municipio m ON l.municipio_id = m.id
INNER JOIN uf u ON m.uf_sigla = u.sigla
INNER JOIN modalidade mod ON l.modalidade_codigo = mod.codigo
INNER JOIN item i ON l.id = i.licitacao_id
INNER JOIN participante p ON i.id = p.item_id
INNER JOIN cnpj ON p.cnpj_codigo = cnpj.codigo
WHERE p.vencedor_flag = 'S'::CHAR;
