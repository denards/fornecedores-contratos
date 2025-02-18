-- Excluir tabelas se existirem (respeitando dependências)
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS auditoria;
DROP TABLE IF EXISTS fornecedor;
DROP TABLE IF EXISTS contrato;
DROP TABLE IF EXISTS participante;
DROP TABLE IF EXISTS cnpj;
DROP TABLE IF EXISTS item;
DROP TABLE IF EXISTS licitacao;
DROP TABLE IF EXISTS modalidade;
DROP TABLE IF EXISTS orgao;
SET FOREIGN_KEY_CHECKS = 1;

-- Criar tabelas novamente

CREATE TABLE orgao (
    codigo VARCHAR(20) PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    tipo_adm CHAR(2) DEFAULT NULL,
    tipo_esfera VARCHAR(10) DEFAULT NULL,
    tipo_poder CHAR(1) DEFAULT NULL,
    ativo TINYINT(1) DEFAULT NULL
) ENGINE=InnoDB;

CREATE TABLE modalidade (
    codigo INT PRIMARY KEY AUTO_INCREMENT,
    descricao VARCHAR(100) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE licitacao (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    numero INT NOT NULL,
    orgao_codigo VARCHAR(20) NOT NULL,
    codigo_ug INT NOT NULL,
    modalidade_codigo INT NOT NULL,
    ano INT NOT NULL,
    mes INT NOT NULL,
    num_processo VARCHAR(20) DEFAULT NULL,
    objeto TEXT DEFAULT NULL,
    situacao VARCHAR(100) DEFAULT NULL,
    uf CHAR(2) NOT NULL,
    municipio VARCHAR(100) NOT NULL,
    data_compra DATE DEFAULT NULL,
    data_abertura DATE DEFAULT NULL,
    valor DECIMAL(15,2) DEFAULT NULL,
    FOREIGN KEY (orgao_codigo) REFERENCES orgao(codigo) ON DELETE CASCADE,
    FOREIGN KEY (modalidade_codigo) REFERENCES modalidade(codigo) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE item (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    descricao TEXT NOT NULL,
    quantidade INT NOT NULL,
    unidade VARCHAR(50) DEFAULT NULL,
    valor_unitario DECIMAL(15,2) DEFAULT NULL,
    licitacao_id BIGINT,
    FOREIGN KEY (licitacao_id) REFERENCES licitacao(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE cnpj (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    numero VARCHAR(18) UNIQUE NOT NULL
) ENGINE=InnoDB;

CREATE TABLE participante (
    licitacao_id BIGINT,
    cnpj_id BIGINT,
    PRIMARY KEY (licitacao_id, cnpj_id),
    FOREIGN KEY (licitacao_id) REFERENCES licitacao(id) ON DELETE CASCADE,
    FOREIGN KEY (cnpj_id) REFERENCES cnpj(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE contrato (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    numero VARCHAR(50) NOT NULL,
    valor_total DECIMAL(15,2) DEFAULT NULL,
    data_assinatura DATE DEFAULT NULL,
    licitacao_id BIGINT,
    FOREIGN KEY (licitacao_id) REFERENCES licitacao(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE fornecedor (
    contrato_id BIGINT,
    cnpj_id BIGINT,
    PRIMARY KEY (contrato_id, cnpj_id),
    FOREIGN KEY (contrato_id) REFERENCES contrato(id) ON DELETE CASCADE,
    FOREIGN KEY (cnpj_id) REFERENCES cnpj(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE auditoria (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    valor_total_antigo DECIMAL(15,2) DEFAULT NULL,
    valor_total_novo DECIMAL(15,2) DEFAULT NULL,
    operacao VARCHAR(20) DEFAULT NULL,
    alterado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario VARCHAR(200) DEFAULT NULL,
    contrato_id BIGINT,
    FOREIGN KEY (contrato_id) REFERENCES contrato(id) ON DELETE CASCADE
) ENGINE=InnoDB;
