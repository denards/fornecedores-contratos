-- Excluir tabelas se existirem (respeitando dependências)
DROP TABLE IF EXISTS auditoria;
DROP TABLE IF EXISTS participante;
DROP TABLE IF EXISTS cnpj;
DROP TABLE IF EXISTS item;
DROP TABLE IF EXISTS licitacao;
DROP TABLE IF EXISTS modalidade;
DROP TABLE IF EXISTS orgao;

-- Criar tabelas novamente

CREATE TABLE orgao (
    codigo VARCHAR(20) PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    tipo_adm CHAR(2),
    tipo_esfera VARCHAR(10),
    tipo_poder CHAR(1),
    ativo TINYINT(1) -- BOOLEAN substituído por TINYINT(1)
);

CREATE TABLE modalidade (
    codigo INT AUTO_INCREMENT PRIMARY KEY,
    descricao VARCHAR(100) NOT NULL
);

CREATE TABLE licitacao (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    numero INT NOT NULL,
    orgao_codigo VARCHAR(20) NOT NULL,
    codigo_ug INT NOT NULL,
    modalidade_codigo INT NOT NULL,
    ano INT NOT NULL,
    mes INT NOT NULL,
    chave_unica VARCHAR(50) NULL,
    num_processo VARCHAR(20),
    objeto TEXT,
    situacao VARCHAR(100),
    uf CHAR(2) NOT NULL,
    municipio VARCHAR(100) NOT NULL,
    data_compra DATE,
    data_abertura DATE,
    valor DECIMAL(15,2),
    FOREIGN KEY (orgao_codigo) REFERENCES orgao(codigo) ON DELETE CASCADE,
    FOREIGN KEY (modalidade_codigo) REFERENCES modalidade(codigo) ON DELETE CASCADE
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
    cnpj_codigo VARCHAR(20),
    vencedor_flag CHAR(1),
    FOREIGN KEY (item_id) REFERENCES item(id) ON DELETE CASCADE,
    FOREIGN KEY (cnpj_codigo) REFERENCES cnpj(codigo) ON DELETE CASCADE
);

CREATE TABLE auditoria (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    valor_total_antigo DECIMAL(15,2),
    valor_total_novo DECIMAL(15,2),
    operacao VARCHAR(20),
    alterado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario VARCHAR(200)
);
