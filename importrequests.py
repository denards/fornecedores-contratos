import requests
import psycopg2

# Configuração do banco de dados PostgreSQL
DB_CONFIG = {
    'dbname': 'mydatabase',
    'user': 'admin',
    'password': 'admin123',
    'host': 'localhost',
    'port': '5432'
}

# Função para conectar ao banco de dados
def conectar_bd():
    return psycopg2.connect(**DB_CONFIG)

# Função para consumir API e carregar dados no PostgreSQL
def importar_licitacoes():
    url = "https://compras.dados.gov.br/licitacoes/v1/licitacoes.json"
    response = requests.get(url)
    
    if response.status_code == 200:
        dados = response.json()
        conn = conectar_bd()
        cursor = conn.cursor()
        
        for licitacao in dados["_embedded"]["licitacoes"]:
            cursor.execute(
                "INSERT INTO licitacao (numero, ano, objeto, data_abertura, id_orgao, id_modalidade) VALUES (%s, %s, %s, %s, %s, %s) RETURNING id", 
                (licitacao["numero"], licitacao["ano"], licitacao["objeto"], licitacao["data_abertura"], None, None)
            )
            licitacao_id = cursor.fetchone()[0]
            
            for item in licitacao.get("itens", []):
                cursor.execute(
                    "INSERT INTO item (descricao, quantidade, unidade, valor_unitario, id_licitacao) VALUES (%s, %s, %s, %s, %s)",
                    (item["descricao"], item.get("quantidade", 0), item.get("unidade", ""), item.get("valor_unitario", 0), licitacao_id)
                )
            
        conn.commit()
        cursor.close()
        conn.close()
        print("Dados importados com sucesso!")
    else:
        print("Erro ao acessar a API.")

if __name__ == "__main__":
    importar_licitacoes()
