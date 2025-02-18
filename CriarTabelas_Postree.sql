-- Excluir tabelas se existirem (respeitando dependências)
DROP TABLE IF EXISTS auditoria CASCADE;
DROP TABLE IF EXISTS participante CASCADE;
DROP TABLE IF EXISTS cnpj CASCADE;
DROP TABLE IF EXISTS item CASCADE;
DROP TABLE IF EXISTS licitacao CASCADE;
DROP TABLE IF EXISTS modalidade CASCADE;
DROP TABLE IF EXISTS orgao CASCADE;

-- Criar tabelas novamente

CREATE TABLE orgao (
    codigo VARCHAR(20) PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    tipo_adm CHAR(2),
    tipo_esfera VARCHAR(10),
    tipo_poder CHAR(1),
    ativo BOOLEAN
);

CREATE TABLE modalidade (
    codigo SERIAL PRIMARY KEY,
    descricao VARCHAR(100) NOT NULL
);

CREATE TABLE licitacao (
    id BIGSERIAL PRIMARY KEY,
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

CREATE TABLE participante (
    licitacao_id BIGINT,
    cnpj_codigo VARCHAR(20),
    PRIMARY KEY (licitacao_id, cnpj_codigo),
    FOREIGN KEY (licitacao_id) REFERENCES licitacao(id) ON DELETE CASCADE,
    FOREIGN KEY (cnpj_codigo) REFERENCES cnpj(codigo) ON DELETE CASCADE
);

CREATE TABLE item (
    id BIGSERIAL PRIMARY KEY,
    codigo VARCHAR(30) NOT NULL,
    descricao TEXT NOT NULL,
    quantidade INT NOT NULL,
    valor DECIMAL(15,2),
    licitacao_id BIGINT,
    vencedor_codigo VARCHAR(20),  
    FOREIGN KEY (licitacao_id) REFERENCES licitacao(id) ON DELETE CASCADE,
    FOREIGN KEY (vencedor_codigo) REFERENCES cnpj(codigo) ON DELETE CASCADE
);

CREATE TABLE auditoria (
    id BIGSERIAL PRIMARY KEY,
    valor_total_antigo DECIMAL(15,2),
    valor_total_novo DECIMAL(15,2),
    operacao VARCHAR(20),
    alterado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario VARCHAR(200)
);
