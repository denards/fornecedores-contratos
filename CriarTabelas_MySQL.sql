-- Excluir tabelas se existirem (respeitando dependências)
DROP TABLE IF EXISTS auditoria;
DROP TABLE IF EXISTS participante;
DROP TABLE IF EXISTS item;
DROP TABLE IF EXISTS cnpj;
DROP TABLE IF EXISTS licitacao;
DROP TABLE IF EXISTS modalidade;
DROP TABLE IF EXISTS orgao;
DROP TABLE IF EXISTS municipio;
DROP TABLE IF EXISTS uf;

-- Criar tabelas novamente
CREATE TABLE orgao (
    codigo VARCHAR(20) PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    tipo_adm CHAR(2),
    tipo_esfera VARCHAR(10),
    tipo_poder CHAR(1),
    ativo TINYINT(1) NOT NULL DEFAULT 1 -- Substituir BOOLEAN por TINYINT(1)
);

CREATE TABLE modalidade (
    codigo INT AUTO_INCREMENT PRIMARY KEY,
    descricao VARCHAR(100) NOT NULL
);

CREATE TABLE uf (
    sigla CHAR(2) PRIMARY KEY,
    descricao VARCHAR(50) NOT NULL
);

CREATE TABLE municipio (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    uf_sigla CHAR(2) NOT NULL,
    descricao VARCHAR(50) NOT NULL,
    FOREIGN KEY (uf_sigla) REFERENCES uf(sigla) ON DELETE CASCADE
);

CREATE TABLE licitacao (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    numero INT NOT NULL,
    orgao_codigo VARCHAR(20) NOT NULL,
    codigo_ug INT NOT NULL,
    modalidade_codigo INT NOT NULL,
    ano INT NOT NULL,
    mes INT NOT NULL, 
    chave_unica VARCHAR(50), 
    num_processo VARCHAR(20),
    objeto TEXT,
    situacao VARCHAR(100),
    municipio_id BIGINT,
    data_compra DATE,
    data_abertura DATE,
    valor DECIMAL(15,2),
    FOREIGN KEY (orgao_codigo) REFERENCES orgao(codigo) ON DELETE CASCADE,
    FOREIGN KEY (modalidade_codigo) REFERENCES modalidade(codigo) ON DELETE CASCADE,
    FOREIGN KEY (municipio_id) REFERENCES municipio(id) ON DELETE CASCADE
);

CREATE TABLE cnpj (
    codigo VARCHAR(20) PRIMARY KEY,
    nome VARCHAR(255) NOT NULL
);

CREATE TABLE item (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    licitacao_id BIGINT NOT NULL,
    item_codigo VARCHAR(30) NOT NULL,
    item_descricao VARCHAR(200) NOT NULL,
    item_qtde INT NOT NULL,
    item_valor DECIMAL(15,6),
    vencedor_cnpj VARCHAR(20),  
    FOREIGN KEY (licitacao_id) REFERENCES licitacao(id) ON DELETE CASCADE,
    FOREIGN KEY (vencedor_cnpj) REFERENCES cnpj(codigo) ON DELETE CASCADE
);

CREATE TABLE participante (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    item_id BIGINT NULL,
    cnpj_codigo VARCHAR(20) NOT NULL,
    vencedor_flag CHAR(1) NOT NULL, -- Removido CHECK pois MySQL não suporta
    FOREIGN KEY (item_id) REFERENCES item(id) ON DELETE CASCADE,
    FOREIGN KEY (cnpj_codigo) REFERENCES cnpj(codigo) ON DELETE CASCADE
);

CREATE TABLE auditoria (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    licitacao_id BIGINT,
    valor_total_antigo DECIMAL(15,2),
    valor_total_novo DECIMAL(15,2),
    operacao VARCHAR(20) NOT NULL,
    alterado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario VARCHAR(200) NOT NULL,
    FOREIGN KEY (licitacao_id) REFERENCES licitacao(id) ON DELETE SET NULL
);

-- Criar trigger para validar vencedor_flag (apenas 'S' ou 'N')
DELIMITER $$
CREATE TRIGGER trg_validar_vencedor_flag
BEFORE INSERT ON participante
FOR EACH ROW
BEGIN
    IF NEW.vencedor_flag NOT IN ('S', 'N') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Valor inválido para vencedor_flag. Use apenas S ou N.';
    END IF;
END$$
DELIMITER ;
