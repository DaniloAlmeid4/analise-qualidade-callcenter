USE CallCenter;
GO

BULK INSERT dbo.operadores
FROM 'C:\Users\Danilo\Desktop\PROJETO\operadores.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    CODEPAGE = 'ACP',
    TABLOCK
);
GO

SELECT COUNT(*) AS total_operadores
FROM dbo.operadores;
GO

USE CallCenter;
GO

BULK INSERT dbo.atendimentos
FROM 'C:\Users\Danilo\Desktop\PROJETO\atendimentos.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    CODEPAGE = 'ACP',
    TABLOCK
);
GO

BULK INSERT dbo.monitorias
FROM 'C:\Users\Danilo\Desktop\PROJETO\monitorias.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    CODEPAGE = 'ACP',
    TABLOCK
);
GO