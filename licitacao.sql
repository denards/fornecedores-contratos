-- ===============================================
-- Script DDL - Módulo LICITAÇÃO (exemplo)
-- ===============================================

-- 1) Tabela principal: LICITACAO
CREATE TABLE licitacao (
    licitacao_id               BIGSERIAL           PRIMARY KEY,
    uasg                       INTEGER             NOT NULL,
    ano                        INTEGER             NOT NULL,
    numero                     INTEGER             NOT NULL,
    codigo_modalidade          INTEGER             NOT NULL,
    objeto                     TEXT                NOT NULL,
    data_entrega_edital        DATE,
    data_abertura_proposta     DATE,
    data_publicacao_edital     DATE,
    hora_abertura_proposta     TIME,
    informacoes_gerais         TEXT,
    observacao                 TEXT,
    situacao_licitacao         VARCHAR(50),
    data_disputa               DATE,
    hora_disputa               TIME,
    situacao_aviso             VARCHAR(50),
    instituicao_responsavel    VARCHAR(100),
    cpf_responsavel            VARCHAR(14),
    identificador              VARCHAR(255)
);

-- 2) LICITACAO_FASE
CREATE TABLE licitacao_fase (
    licitacao_fase_id  BIGSERIAL      PRIMARY KEY,
    licitacao_id       BIGINT         NOT NULL,
    fase_licitacao     VARCHAR(100)   NOT NULL,
    data_fase          DATE           NOT NULL,
    observacao_fase    TEXT,

    CONSTRAINT fk_licitacao_fase
        FOREIGN KEY (licitacao_id)
        REFERENCES licitacao (licitacao_id)
);

-- 3) LICITACAO_EVENTO
CREATE TABLE licitacao_evento (
    licitacao_evento_id BIGSERIAL      PRIMARY KEY,
    licitacao_id        BIGINT         NOT NULL,
    tipo_evento         VARCHAR(100)   NOT NULL,
    data_evento         DATE           NOT NULL,
    hora_evento         TIME,
    descricao_evento    TEXT,

    CONSTRAINT fk_licitacao_evento
        FOREIGN KEY (licitacao_id)
        REFERENCES licitacao (licitacao_id)
);

-- 4) LICITACAO_ITEM
CREATE TABLE licitacao_item (
    licitacao_item_id       BIGSERIAL        PRIMARY KEY,
    licitacao_id            BIGINT           NOT NULL,
    codigo_item             INTEGER          NOT NULL,
    nome_item               TEXT             NOT NULL,
    descricao_item          TEXT,
    quantidade_item         NUMERIC(15, 2),
    unidade_fornecimento    VARCHAR(50),
    valor_estimado          NUMERIC(15, 2),
    valor_estimado_sigiloso NUMERIC(15, 2),
    valor_adjudicado        NUMERIC(15, 2),
    situacao_item           VARCHAR(50),

    CONSTRAINT fk_licitacao_item
        FOREIGN KEY (licitacao_id)
        REFERENCES licitacao (licitacao_id)
);

-- 5) LICITACAO_PARTICIPANTE
CREATE TABLE licitacao_participante (
    licitacao_participante_id  BIGSERIAL     PRIMARY KEY,
    licitacao_id               BIGINT        NOT NULL,
    cnpj_cpf                   VARCHAR(14)   NOT NULL,
    razao_social               TEXT,
    situacao_participante      VARCHAR(50),
    data_entrada               DATE,
    data_saida                 DATE,
    valor_proposta             NUMERIC(15, 2),
    observacao_participante    TEXT,

    CONSTRAINT fk_licitacao_participante
        FOREIGN KEY (licitacao_id)
        REFERENCES licitacao (licitacao_id)
);

-- 6) LICITACAO_DOCUMENTO
CREATE TABLE licitacao_documento (
    licitacao_documento_id BIGSERIAL      PRIMARY KEY,
    licitacao_id           BIGINT         NOT NULL,
    tipo_documento         VARCHAR(50)    NOT NULL,
    titulo_documento       TEXT           NOT NULL,
    url_documento          TEXT,
    data_documento         DATE,
    observacao_documento   TEXT,

    CONSTRAINT fk_licitacao_documento
        FOREIGN KEY (licitacao_id)
        REFERENCES licitacao (licitacao_id)
);

-- 7) LICITACAO_RESULTADO (Opcional/conforme modelo)
CREATE TABLE licitacao_resultado (
    licitacao_resultado_id  BIGSERIAL     PRIMARY KEY,
    licitacao_id            BIGINT        NOT NULL,
    data_resultado          DATE          NOT NULL,
    descricao_resultado     TEXT,
    tipo_resultado          VARCHAR(50),

    CONSTRAINT fk_licitacao_resultado
        FOREIGN KEY (licitacao_id)
        REFERENCES licitacao (licitacao_id)
);

-- Exemplos de índices (ajuste conforme necessidade real)
CREATE INDEX idx_licitacao_uasg ON licitacao (uasg);
CREATE INDEX idx_licitacao_ano_numero ON licitacao (ano, numero);
CREATE INDEX idx_participante_cnpjcpf ON licitacao_participante (cnpj_cpf);
