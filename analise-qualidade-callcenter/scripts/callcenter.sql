-- =====================================================
-- PROJETO: ANÁLISE DE QUALIDADE DE CALL CENTER
-- BANCO:   SQL Server
-- AUTOR:   Analista de Qualidade
-- =====================================================


-- =====================================================
-- PARTE 1 — CRIAR O BANCO DE DADOS
-- =====================================================

-- Cria o banco chamado CallCenter
CREATE DATABASE CallCenter;
GO

-- Seleciona o banco para usar
USE CallCenter;
GO


-- =====================================================
-- PARTE 2 — CRIAR AS TABELAS
-- =====================================================

-- Tabela de Operadores (cadastro)
-- Cada operador aparece 1 vez aqui
CREATE TABLE operadores (
    AVAYALOGIN   INT           PRIMARY KEY,
    NOME         VARCHAR(100)  NOT NULL,
    SUPERVISOR   VARCHAR(50)   NOT NULL,
    SEGMENTO     VARCHAR(50)   NOT NULL,
    TURNO        VARCHAR(30)   NOT NULL,
    TEMPODECASA  VARCHAR(30)   NOT NULL,
    STATUS       VARCHAR(20)   NOT NULL
);
GO

-- Tabela de Atendimentos (registros diários)
-- Cada linha = 1 operador em 1 dia
CREATE TABLE atendimentos (
    ID           INT           IDENTITY(1,1) PRIMARY KEY,  -- ID automático
    DATA         DATE          NOT NULL,
    AVAYALOGIN   INT           NOT NULL,
    SUPERVISOR   VARCHAR(50)   NOT NULL,
    SEGMENTO     VARCHAR(50)   NOT NULL,
    STATUS       VARCHAR(20)   NOT NULL,
    TEMPODECASA  VARCHAR(30)   NOT NULL,
    TURNO        VARCHAR(30)   NOT NULL,
    ATENDIDAS    INT           NOT NULL,
    RECH         INT           NOT NULL,
    TMA          INT           NOT NULL,   -- em segundos
    TALKTIME     INT           NOT NULL,   -- em segundos
    ACW          INT           NOT NULL,   -- em segundos
    TRANSF       INT           NOT NULL,
    AVALIADAS    INT           NOT NULL,
    PROMOTORAS   INT           NOT NULL,
    NEUTRAS      INT           NOT NULL,
    DETRATORAS   INT           NOT NULL,

    -- Chave estrangeira: garante que o login existe na tabela operadores
    CONSTRAINT fk_atendimentos_operador
        FOREIGN KEY (AVAYALOGIN) REFERENCES operadores(AVAYALOGIN)
);
GO

-- Tabela de Monitorias (notas de qualidade)
-- Cada linha = 1 escuta de 1 operador feita por 1 analista
CREATE TABLE monitorias (
    ID_MONITORIA                  INT           PRIMARY KEY,
    DATA                          DATE          NOT NULL,
    AVAYALOGIN                    INT           NOT NULL,
    SUPERVISOR                    VARCHAR(50)   NOT NULL,
    SEGMENTO                      VARCHAR(50)   NOT NULL,
    ANALISTA                      VARCHAR(100)  NOT NULL,
    NOTA_FINAL                    DECIMAL(4,1)  NOT NULL,
    SAUDACAO_IDENTIFICACAO        INT           NOT NULL,
    ESCUTA_ATIVA                  INT           NOT NULL,
    CLAREZA_COMUNICACAO           INT           NOT NULL,
    RESOLUCAO_PRIMEIRO_CONTATO    INT           NOT NULL,
    EMPATIA_CLIENTE               INT           NOT NULL,
    CONHECIMENTO_PRODUTO          INT           NOT NULL,
    SEGUIU_SCRIPT                 INT           NOT NULL,
    ENCERRAMENTO_ADEQUADO         INT           NOT NULL,

    CONSTRAINT fk_monitorias_operador
        FOREIGN KEY (AVAYALOGIN) REFERENCES operadores(AVAYALOGIN)
);
GO


-- =====================================================
-- PARTE 3 — IMPORTAR OS CSVs
-- =====================================================

-- ⚠️  ATENÇÃO: ajuste o caminho abaixo para onde estão
--     seus arquivos CSV no computador.
--     Exemplo: C:\Users\SeuNome\Downloads\

BULK INSERT operadores
FROM 'C:\Users\SeuNome\Downloads\operadores.csv'
WITH (
    FORMAT         = 'CSV',
    FIRSTROW       = 2,          -- pula o cabeçalho
    FIELDTERMINATOR = ',',
    ROWTERMINATOR  = '\n',
    CODEPAGE       = '65001'     -- UTF-8
);
GO

BULK INSERT atendimentos
FROM 'C:\Users\SeuNome\Downloads\atendimentos.csv'
WITH (
    FORMAT         = 'CSV',
    FIRSTROW       = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR  = '\n',
    CODEPAGE       = '65001'
);
GO

BULK INSERT monitorias
FROM 'C:\Users\SeuNome\Downloads\monitorias.csv'
WITH (
    FORMAT         = 'CSV',
    FIRSTROW       = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR  = '\n',
    CODEPAGE       = '65001'
);
GO


-- =====================================================
-- PARTE 4 — VERIFICAR SE IMPORTOU CERTO
-- =====================================================

-- Quantos registros foram importados em cada tabela?
SELECT 'operadores'   AS tabela, COUNT(*) AS total FROM operadores
UNION ALL
SELECT 'atendimentos' AS tabela, COUNT(*) AS total FROM atendimentos
UNION ALL
SELECT 'monitorias'   AS tabela, COUNT(*) AS total FROM monitorias;
GO

-- Visualizar as primeiras linhas de cada tabela
SELECT TOP 5 * FROM operadores;
SELECT TOP 5 * FROM atendimentos;
SELECT TOP 5 * FROM monitorias;
GO


-- =====================================================
-- PARTE 5 — QUERIES DE ANÁLISE (KPIs)
-- =====================================================

-- ─────────────────────────────────────────────────────
-- Q1: % RECH por Supervisor
-- Mostra quais supervisores têm mais chamadas abandonadas
-- ─────────────────────────────────────────────────────
SELECT
    SUPERVISOR,
    SUM(ATENDIDAS)                                          AS total_atendidas,
    SUM(RECH)                                               AS total_rech,
    CAST(
        SUM(RECH) * 100.0 / NULLIF(SUM(ATENDIDAS), 0)
    AS DECIMAL(5,2))                                        AS perc_rech
FROM atendimentos
GROUP BY SUPERVISOR
ORDER BY perc_rech DESC;
GO

-- ─────────────────────────────────────────────────────
-- Q2: NPS por Supervisor
-- NPS = (Promotoras - Detratoras) / Avaliadas * 100
-- ─────────────────────────────────────────────────────
SELECT
    SUPERVISOR,
    SUM(PROMOTORAS)                                          AS promotoras,
    SUM(NEUTRAS)                                             AS neutras,
    SUM(DETRATORAS)                                          AS detratoras,
    SUM(AVALIADAS)                                           AS avaliadas,
    CAST(
        (SUM(PROMOTORAS) - SUM(DETRATORAS)) * 100.0
        / NULLIF(SUM(AVALIADAS), 0)
    AS DECIMAL(5,2))                                         AS nps
FROM atendimentos
GROUP BY SUPERVISOR
ORDER BY nps DESC;
GO

-- ─────────────────────────────────────────────────────
-- Q3: TMA médio por Supervisor (em minutos)
-- ─────────────────────────────────────────────────────
SELECT
    SUPERVISOR,
    CAST(AVG(TMA) / 60.0 AS DECIMAL(4,1))   AS tma_medio_minutos,
    CAST(AVG(TALKTIME) / 60.0 AS DECIMAL(4,1)) AS talktime_medio_minutos,
    CAST(AVG(ACW) / 60.0 AS DECIMAL(4,1))   AS acw_medio_minutos
FROM atendimentos
GROUP BY SUPERVISOR
ORDER BY tma_medio_minutos DESC;
GO

-- ─────────────────────────────────────────────────────
-- Q4: Operadores com % RECH acima de 15% (fora da meta)
-- ─────────────────────────────────────────────────────
SELECT
    a.AVAYALOGIN,
    o.NOME,
    a.SUPERVISOR,
    a.SEGMENTO,
    SUM(a.ATENDIDAS)                                         AS total_atendidas,
    SUM(a.RECH)                                              AS total_rech,
    CAST(
        SUM(a.RECH) * 100.0 / NULLIF(SUM(a.ATENDIDAS), 0)
    AS DECIMAL(5,2))                                         AS perc_rech
FROM atendimentos a
INNER JOIN operadores o ON a.AVAYALOGIN = o.AVAYALOGIN
GROUP BY a.AVAYALOGIN, o.NOME, a.SUPERVISOR, a.SEGMENTO
HAVING
    SUM(a.ATENDIDAS) > 0
    AND SUM(a.RECH) * 100.0 / SUM(a.ATENDIDAS) > 15
ORDER BY perc_rech DESC;
GO

-- ─────────────────────────────────────────────────────
-- Q5: Operadores com menos de 2 monitorias no mês
-- Importante para garantir cobertura de qualidade
-- ─────────────────────────────────────────────────────
SELECT
    o.AVAYALOGIN,
    o.NOME,
    o.SUPERVISOR,
    o.STATUS,
    YEAR(m.DATA)                 AS ano,
    MONTH(m.DATA)                AS mes,
    COUNT(m.ID_MONITORIA)        AS qtd_monitorias
FROM operadores o
LEFT JOIN monitorias m ON o.AVAYALOGIN = m.AVAYALOGIN
WHERE o.STATUS = 'Ativo'
GROUP BY o.AVAYALOGIN, o.NOME, o.SUPERVISOR, o.STATUS, YEAR(m.DATA), MONTH(m.DATA)
HAVING COUNT(m.ID_MONITORIA) < 2
ORDER BY o.SUPERVISOR, qtd_monitorias;
GO

-- ─────────────────────────────────────────────────────
-- Q6: Nota média de monitoria por Supervisor e Critério
-- Revela em qual critério cada equipe é mais fraca
-- ─────────────────────────────────────────────────────
SELECT
    SUPERVISOR,
    CAST(AVG(CAST(SAUDACAO_IDENTIFICACAO     AS FLOAT)) AS DECIMAL(4,1)) AS saudacao,
    CAST(AVG(CAST(ESCUTA_ATIVA               AS FLOAT)) AS DECIMAL(4,1)) AS escuta_ativa,
    CAST(AVG(CAST(CLAREZA_COMUNICACAO        AS FLOAT)) AS DECIMAL(4,1)) AS clareza,
    CAST(AVG(CAST(RESOLUCAO_PRIMEIRO_CONTATO AS FLOAT)) AS DECIMAL(4,1)) AS fcr,
    CAST(AVG(CAST(EMPATIA_CLIENTE            AS FLOAT)) AS DECIMAL(4,1)) AS empatia,
    CAST(AVG(CAST(CONHECIMENTO_PRODUTO       AS FLOAT)) AS DECIMAL(4,1)) AS conhecimento,
    CAST(AVG(CAST(SEGUIU_SCRIPT              AS FLOAT)) AS DECIMAL(4,1)) AS script,
    CAST(AVG(CAST(ENCERRAMENTO_ADEQUADO      AS FLOAT)) AS DECIMAL(4,1)) AS encerramento,
    CAST(AVG(NOTA_FINAL)                               AS DECIMAL(4,1)) AS nota_final_media
FROM monitorias
GROUP BY SUPERVISOR
ORDER BY nota_final_media DESC;
GO

-- ─────────────────────────────────────────────────────
-- Q7: Evolução mensal do NPS geral da operação
-- Mostra se a qualidade está melhorando ou piorando
-- ─────────────────────────────────────────────────────
SELECT
    YEAR(DATA)   AS ano,
    MONTH(DATA)  AS mes,
    SUM(PROMOTORAS)                                          AS promotoras,
    SUM(DETRATORAS)                                          AS detratoras,
    SUM(AVALIADAS)                                           AS avaliadas,
    CAST(
        (SUM(PROMOTORAS) - SUM(DETRATORAS)) * 100.0
        / NULLIF(SUM(AVALIADAS), 0)
    AS DECIMAL(5,2))                                         AS nps
FROM atendimentos
GROUP BY YEAR(DATA), MONTH(DATA)
ORDER BY ano, mes;
GO

-- ─────────────────────────────────────────────────────
-- Q8: Ranking geral dos operadores (Top 10 por NPS)
-- ─────────────────────────────────────────────────────
SELECT TOP 10
    a.AVAYALOGIN,
    o.NOME,
    a.SUPERVISOR,
    a.SEGMENTO,
    SUM(a.AVALIADAS)                                         AS avaliadas,
    CAST(
        (SUM(a.PROMOTORAS) - SUM(a.DETRATORAS)) * 100.0
        / NULLIF(SUM(a.AVALIADAS), 0)
    AS DECIMAL(5,2))                                         AS nps,
    CAST(AVG(m.NOTA_FINAL) AS DECIMAL(4,1))                 AS nota_monitoria
FROM atendimentos a
INNER JOIN operadores o  ON a.AVAYALOGIN = o.AVAYALOGIN
LEFT  JOIN monitorias m  ON a.AVAYALOGIN = m.AVAYALOGIN
WHERE a.AVALIADAS > 0
GROUP BY a.AVAYALOGIN, o.NOME, a.SUPERVISOR, a.SEGMENTO
ORDER BY nps DESC;
GO
