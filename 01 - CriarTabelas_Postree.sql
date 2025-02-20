-- Excluir tabelas se existirem (respeitando dependências)
DROP TABLE IF EXISTS auditoria CASCADE;
DROP TABLE IF EXISTS participante CASCADE;
DROP TABLE IF EXISTS cnpj CASCADE;
DROP TABLE IF EXISTS item CASCADE;
DROP TABLE IF EXISTS licitacao CASCADE;
DROP TABLE IF EXISTS modalidade CASCADE;
DROP TABLE IF EXISTS orgao CASCADE;
DROP TABLE IF EXISTS uf CASCADE;
DROP TABLE IF EXISTS municipio CASCADE;

-- Criar tabelas novamente

CREATE TABLE orgao (
    codigo VARCHAR(20) PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    tipo_adm CHAR(2),
    tipo_esfera VARCHAR(10),
    tipo_poder CHAR(1),
    ativo BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE modalidade (
    codigo SERIAL PRIMARY KEY,
    descricao VARCHAR(100) NOT NULL
);

CREATE TABLE uf (
    sigla CHAR(2) PRIMARY KEY,
    descricao VARCHAR(50) NOT NULL
);

CREATE TABLE municipio (
    id BIGSERIAL PRIMARY KEY,
    uf_sigla CHAR(2) NOT NULL,
    descricao VARCHAR(50) NOT NULL,
    FOREIGN KEY (uf_sigla) REFERENCES uf(sigla) ON DELETE CASCADE
);

CREATE TABLE licitacao (
    id BIGSERIAL PRIMARY KEY,
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
    municipio_id INT,
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
    id BIGSERIAL PRIMARY KEY,
    licitacao_id BIGINT NOT NULL,
    item_codigo VARCHAR(30) NOT NULL,
    item_descricao VARCHAR(200) NOT NULL,
    item_qtde INT NOT NULL,
    item_valor DECIMAL(15,6),
    vencedor_cnpj VARCHAR(20),
    FOREIGN KEY (licitacao_id) REFERENCES licitacao(id) ON DELETE CASCADE
);

CREATE TABLE participante (
    id BIGSERIAL PRIMARY KEY,
    item_id BIGINT NULL,
    item_codigo VARCHAR(30) NULL,
    cnpj_codigo VARCHAR(20) NOT NULL,
    vencedor_flag CHAR(1) CHECK (vencedor_flag IN ('S', 'N')),
    FOREIGN KEY (item_id) REFERENCES item(id) ON DELETE CASCADE,
    FOREIGN KEY (cnpj_codigo) REFERENCES cnpj(codigo) ON DELETE CASCADE
);

-- Criar tabela de auditoria
CREATE TABLE auditoria (
    id BIGSERIAL PRIMARY KEY,
    licitacao_id BIGINT,
    valor_total_antigo DECIMAL(15,2),
    valor_total_novo DECIMAL(15,2),
    operacao VARCHAR(20) NOT NULL,
    alterado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario VARCHAR(200) NOT NULL,
    FOREIGN KEY (licitacao_id) REFERENCES licitacao(id) ON DELETE SET NULL
);

-- Criar função de auditoria
CREATE OR REPLACE FUNCTION auditoria_licitacao()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO auditoria (licitacao_id, valor_total_antigo, valor_total_novo, operacao, usuario)
        VALUES (NEW.id, NULL, NEW.valor, 'INSERT', current_user);
        RETURN NEW;
    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO auditoria (licitacao_id, valor_total_antigo, valor_total_novo, operacao, usuario)
        VALUES (NEW.id, OLD.valor, NEW.valor, 'UPDATE', current_user);
        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO auditoria (licitacao_id, valor_total_antigo, valor_total_novo, operacao, usuario)
        VALUES (OLD.id, OLD.valor, NULL, 'DELETE', current_user);
        RETURN OLD;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Criar trigger para auditoria
CREATE TRIGGER trg_auditoria_licitacao
AFTER INSERT OR UPDATE OR DELETE ON licitacao
FOR EACH ROW EXECUTE FUNCTION auditoria_licitacao();
