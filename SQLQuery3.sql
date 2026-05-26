USE CallCenter;
GO

IF OBJECT_ID('dbo.atendimentos_import', 'U') IS NOT NULL
    DROP TABLE dbo.atendimentos_import;
GO

CREATE TABLE dbo.atendimentos_import (
    DATA         DATE          NOT NULL,
    AVAYALOGIN   INT           NOT NULL,
    SUPERVISOR   VARCHAR(50)   NOT NULL,
    SEGMENTO     VARCHAR(50)   NOT NULL,
    STATUS       VARCHAR(20)   NOT NULL,
    TEMPODECASA  VARCHAR(30)   NOT NULL,
    TURNO        VARCHAR(30)   NOT NULL,
    ATENDIDAS    INT           NOT NULL,
    RECH         INT           NOT NULL,
    TMA          INT           NOT NULL,
    TALKTIME     INT           NOT NULL,
    ACW          INT           NOT NULL,
    TRANSF       INT           NOT NULL,
    AVALIADAS    INT           NOT NULL,
    PROMOTORAS   INT           NOT NULL,
    NEUTRAS      INT           NOT NULL,
    DETRATORAS   INT           NOT NULL
);
GO

BULK INSERT dbo.atendimentos_import
FROM 'C:\Users\Danilo\Desktop\PROJETO\atendimentos.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    CODEPAGE = 'ACP',
    TABLOCK
);
GO

INSERT INTO dbo.atendimentos (
    DATA,
    AVAYALOGIN,
    SUPERVISOR,
    SEGMENTO,
    STATUS,
    TEMPODECASA,
    TURNO,
    ATENDIDAS,
    RECH,
    TMA,
    TALKTIME,
    ACW,
    TRANSF,
    AVALIADAS,
    PROMOTORAS,
    NEUTRAS,
    DETRATORAS
)
SELECT
    DATA,
    AVAYALOGIN,
    SUPERVISOR,
    SEGMENTO,
    STATUS,
    TEMPODECASA,
    TURNO,
    ATENDIDAS,
    RECH,
    TMA,
    TALKTIME,
    ACW,
    TRANSF,
    AVALIADAS,
    PROMOTORAS,
    NEUTRAS,
    DETRATORAS
FROM dbo.atendimentos_import;
GO

SELECT 'operadores' AS tabela, COUNT(*) AS total FROM dbo.operadores
UNION ALL
SELECT 'atendimentos', COUNT(*) FROM dbo.atendimentos
UNION ALL
SELECT 'monitorias', COUNT(*) FROM dbo.monitorias;
GO