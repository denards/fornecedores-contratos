-- Criação do banco de dados
CREATE DATABASE pncp;

-- Esquema para organizar as tabelas
CREATE SCHEMA IF NOT EXISTS pncp;

-- Tabelas de domínio
CREATE TABLE pncp.tipo_instrumento_convocatorio (
    id SMALLINT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT
);

CREATE TABLE pncp.modalidade_contratacao (
    id SMALLINT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT
);

CREATE TABLE pncp.modo_disputa (
    id SMALLINT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT
);

CREATE TABLE pncp.criterio_julgamento (
    id SMALLINT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT
);

CREATE TABLE pncp.situacao_contratacao (
    id SMALLINT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT
);

CREATE TABLE pncp.tipo_beneficio (
    id SMALLINT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT
);

CREATE TABLE pncp.tipo_contrato (
    id SMALLINT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT
);

CREATE TABLE pncp.categoria_processo (
    id SMALLINT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT
);

CREATE TABLE pncp.tipo_documento (
    id SMALLINT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT
);

CREATE TABLE pncp.natureza_juridica (
    id VARCHAR(4) PRIMARY KEY,
    nome VARCHAR(200) NOT NULL,
    descricao TEXT
);

CREATE TABLE pncp.porte_empresa (
    id SMALLINT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT
);

CREATE TABLE pncp.amparo_legal (
    id SMALLINT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    artigo VARCHAR(50) NOT NULL,
    lei VARCHAR(50) NOT NULL
);

-- Tabelas principais
CREATE TABLE pncp.orgao (
    cnpj VARCHAR(14) PRIMARY KEY,
    razao_social VARCHAR(200) NOT NULL,
    natureza_juridica_id VARCHAR(4) NOT NULL REFERENCES pncp.natureza_juridica(id),
    poder_id CHAR(1) NOT NULL, -- E: Executivo, L: Legislativo, J: Judiciário
    esfera_id CHAR(1) NOT NULL, -- F: Federal, E: Estadual, M: Municipal, D: Distrital
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE pncp.unidade_administrativa (
    id SERIAL PRIMARY KEY,
    codigo VARCHAR(20) NOT NULL,
    nome VARCHAR(200) NOT NULL,
    orgao_cnpj VARCHAR(14) NOT NULL REFERENCES pncp.orgao(cnpj),
    codigo_municipio_ibge VARCHAR(7),
    uf CHAR(2),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(codigo, orgao_cnpj)
);

CREATE TABLE pncp.plano_contratacao (
    id VARCHAR(30) PRIMARY KEY, -- Número de Controle PNCP
    ano INTEGER NOT NULL,
    orgao_cnpj VARCHAR(14) NOT NULL REFERENCES pncp.orgao(cnpj),
    unidade_administrativa_id INTEGER NOT NULL REFERENCES pncp.unidade_administrativa(id),
    sequencial INTEGER NOT NULL,
    data_publicacao TIMESTAMP NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE pncp.item_plano_contratacao (
    id SERIAL PRIMARY KEY,
    plano_contratacao_id VARCHAR(30) NOT NULL REFERENCES pncp.plano_contratacao(id),
    numero_item INTEGER NOT NULL,
    descricao TEXT NOT NULL,
    quantidade DECIMAL(15,4) NOT NULL,
    valor_unitario DECIMAL(15,4) NOT NULL,
    valor_total DECIMAL(15,4) NOT NULL,
    valor_orcamento_exercicio DECIMAL(15,4),
    unidade_fornecimento VARCHAR(50) NOT NULL,
    codigo_item VARCHAR(100),
    categoria_item_id SMALLINT NOT NULL,
    data_desejada DATE NOT NULL,
    unidade_requisitante VARCHAR(200),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE pncp.contratacao (
    id VARCHAR(30) PRIMARY KEY, -- Número de Controle PNCP
    numero VARCHAR(50) NOT NULL,
    ano INTEGER NOT NULL,
    sequencial INTEGER NOT NULL,
    processo VARCHAR(50),
    objeto TEXT NOT NULL,
    informacao_complementar TEXT,
    valor_total_estimado DECIMAL(15,4),
    data_abertura_proposta TIMESTAMP,
    data_encerramento_proposta TIMESTAMP,
    orgao_cnpj VARCHAR(14) NOT NULL REFERENCES pncp.orgao(cnpj),
    unidade_administrativa_id INTEGER NOT NULL REFERENCES pncp.unidade_administrativa(id),
    modalidade_id SMALLINT NOT NULL REFERENCES pncp.modalidade_contratacao(id),
    tipo_instrumento_id SMALLINT NOT NULL REFERENCES pncp.tipo_instrumento_convocatorio(id),
    modo_disputa_id SMALLINT REFERENCES pncp.modo_disputa(id),
    criterio_julgamento_id SMALLINT REFERENCES pncp.criterio_julgamento(id),
    situacao_id SMALLINT NOT NULL REFERENCES pncp.situacao_contratacao(id),
    srp BOOLEAN NOT NULL DEFAULT FALSE,
    data_publicacao TIMESTAMP NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE pncp.item_contratacao (
    id SERIAL PRIMARY KEY,
    contratacao_id VARCHAR(30) NOT NULL REFERENCES pncp.contratacao(id),
    numero_item INTEGER NOT NULL,
    descricao TEXT NOT NULL,
    quantidade DECIMAL(15,4) NOT NULL,
    valor_unitario DECIMAL(15,4) NOT NULL,
    valor_total DECIMAL(15,4) NOT NULL,
    unidade_fornecimento VARCHAR(50) NOT NULL,
    codigo_item VARCHAR(100),
    situacao_item_id SMALLINT NOT NULL,
    tipo_beneficio_id SMALLINT REFERENCES pncp.tipo_beneficio(id),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE pncp.resultado_item (
    id SERIAL PRIMARY KEY,
    item_contratacao_id INTEGER NOT NULL REFERENCES pncp.item_contratacao(id),
    valor DECIMAL(15,4) NOT NULL,
    quantidade DECIMAL(15,4) NOT NULL,
    fornecedor_tipo CHAR(2) NOT NULL, -- PJ, PF, PE
    fornecedor_documento VARCHAR(30) NOT NULL,
    fornecedor_nome VARCHAR(200) NOT NULL,
    marca VARCHAR(100),
    modelo VARCHAR(100),
    situacao_id SMALLINT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE pncp.ata_registro_preco (
    id VARCHAR(35) PRIMARY KEY, -- Número de Controle PNCP
    contratacao_id VARCHAR(30) NOT NULL REFERENCES pncp.contratacao(id),
    numero VARCHAR(50) NOT NULL,
    ano INTEGER NOT NULL,
    data_assinatura DATE NOT NULL,
    vigencia_inicio DATE NOT NULL,
    vigencia_fim DATE NOT NULL,
    cancelada BOOLEAN NOT NULL DEFAULT FALSE,
    data_cancelamento DATE,
    data_publicacao TIMESTAMP NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE pncp.contrato (
    id VARCHAR(30) PRIMARY KEY, -- Número de Controle PNCP
    contratacao_id VARCHAR(30) REFERENCES pncp.contratacao(id),
    numero VARCHAR(50) NOT NULL,
    ano INTEGER NOT NULL,
    processo VARCHAR(50),
    tipo_contrato_id SMALLINT NOT NULL REFERENCES pncp.tipo_contrato(id),
    categoria_processo_id SMALLINT NOT NULL REFERENCES pncp.categoria_processo(id),
    objeto TEXT NOT NULL,
    informacao_complementar TEXT,
    receita BOOLEAN NOT NULL DEFAULT FALSE,
    valor_inicial DECIMAL(15,4) NOT NULL,
    valor_global DECIMAL(15,4) NOT NULL,
    numero_parcelas INTEGER,
    valor_parcela DECIMAL(15,4),
    valor_acumulado DECIMAL(15,4),
    data_assinatura DATE NOT NULL,
    vigencia_inicio DATE NOT NULL,
    vigencia_fim DATE NOT NULL,
    numero_retificacoes INTEGER NOT NULL DEFAULT 0,
    orgao_cnpj VARCHAR(14) NOT NULL REFERENCES pncp.orgao(cnpj),
    unidade_administrativa_id INTEGER NOT NULL REFERENCES pncp.unidade_administrativa(id),
    fornecedor_tipo CHAR(2) NOT NULL, -- PJ, PF, PE
    fornecedor_documento VARCHAR(30) NOT NULL,
    fornecedor_nome VARCHAR(200) NOT NULL,
    data_publicacao TIMESTAMP NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE pncp.documento (
    id SERIAL PRIMARY KEY,
    tipo_documento_id SMALLINT NOT NULL REFERENCES pncp.tipo_documento(id),
    contratacao_id VARCHAR(30) REFERENCES pncp.contratacao(id),
    ata_id VARCHAR(35) REFERENCES pncp.ata_registro_preco(id),
    contrato_id VARCHAR(30) REFERENCES pncp.contrato(id),
    titulo VARCHAR(200) NOT NULL,
    descricao TEXT,
    url TEXT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CHECK (
        (contratacao_id IS NOT NULL AND ata_id IS NULL AND contrato_id IS NULL) OR
        (contratacao_id IS NULL AND ata_id IS NOT NULL AND contrato_id IS NULL) OR
        (contratacao_id IS NULL AND ata_id IS NULL AND contrato_id IS NOT NULL)
    )
);

-- Índices
CREATE INDEX idx_contratacao_data_pub ON pncp.contratacao(data_publicacao);
CREATE INDEX idx_contratacao_orgao ON pncp.contratacao(orgao_cnpj);
CREATE INDEX idx_ata_vigencia ON pncp.ata_registro_preco(vigencia_inicio, vigencia_fim);
CREATE INDEX idx_contrato_data_pub ON pncp.contrato(data_publicacao);
CREATE INDEX idx_item_contratacao_contratacao ON pncp.item_contratacao(contratacao_id);
CREATE INDEX idx_resultado_item_item ON pncp.resultado_item(item_contratacao_id);

-- Triggers para atualizar updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_orgao_updated_at
    BEFORE UPDATE ON pncp.orgao
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Repetir para todas as outras tabelas principais