-- =====================================================
-- CORRIGIR ENCODING DOS DADOS NO SQL SERVER
-- Execute no SSMS com o banco CallCenter selecionado
-- =====================================================

USE CallCenter;
GO

-- PASSO 1: Verificar como estão os dados antes
SELECT DISTINCT TURNO   FROM operadores;
SELECT DISTINCT STATUS  FROM operadores;
SELECT TOP 5 NOME       FROM operadores;
GO

-- PASSO 2: Corrigir a tabela operadores
UPDATE operadores SET TURNO  = 'Manhã'    WHERE TURNO  = 'ManhÃ£';
UPDATE operadores SET TURNO  = 'Madrugada' WHERE TURNO = 'Madrugada';
UPDATE operadores SET STATUS = 'Férias'   WHERE STATUS = 'FÃ©rias';

-- Corrigir nomes com caracteres quebrados (padrões mais comuns)
UPDATE operadores SET NOME = REPLACE(NOME, 'Ã£', 'ã');
UPDATE operadores SET NOME = REPLACE(NOME, 'Ã©', 'é');
UPDATE operadores SET NOME = REPLACE(NOME, 'Ã­', 'í');
UPDATE operadores SET NOME = REPLACE(NOME, 'Ã³', 'ó');
UPDATE operadores SET NOME = REPLACE(NOME, 'Ãº', 'ú');
UPDATE operadores SET NOME = REPLACE(NOME, 'Ã¢', 'â');
UPDATE operadores SET NOME = REPLACE(NOME, 'Ãª', 'ê');
UPDATE operadores SET NOME = REPLACE(NOME, 'Ã´', 'ô');
UPDATE operadores SET NOME = REPLACE(NOME, 'Ã§', 'ç');
UPDATE operadores SET NOME = REPLACE(NOME, 'Ã ', 'à');
UPDATE operadores SET NOME = REPLACE(NOME, 'Ã\u0081', 'Á');
UPDATE operadores SET NOME = REPLACE(NOME, 'Ã\u0089', 'É');
UPDATE operadores SET NOME = REPLACE(NOME, 'Ã\u008d', 'Í');
UPDATE operadores SET NOME = REPLACE(NOME, 'Ã\u0093', 'Ó');
UPDATE operadores SET NOME = REPLACE(NOME, 'Ã\u009a', 'Ú');
UPDATE operadores SET NOME = REPLACE(NOME, 'Ã\u0082', 'Â');
UPDATE operadores SET NOME = REPLACE(NOME, 'Ã\u008a', 'Ê');
UPDATE operadores SET NOME = REPLACE(NOME, 'Ã\u0094', 'Ô');
UPDATE operadores SET NOME = REPLACE(NOME, 'Ã\u0087', 'Ç');
UPDATE operadores SET NOME = REPLACE(NOME, 'Ã\u0083', 'Ã');
UPDATE operadores SET NOME = REPLACE(NOME, 'Ã\u009c', 'Ü');
GO

-- PASSO 3: Verificar como ficou depois
SELECT DISTINCT TURNO   FROM operadores;
SELECT DISTINCT STATUS  FROM operadores;
SELECT TOP 10 NOME      FROM operadores ORDER BY NOME;
GO

-- PASSO 4: Corrigir tabela monitorias (coluna ANALISTA)
UPDATE monitorias SET ANALISTA = REPLACE(ANALISTA, 'Ã£', 'ã');
UPDATE monitorias SET ANALISTA = REPLACE(ANALISTA, 'Ã©', 'é');
UPDATE monitorias SET ANALISTA = REPLACE(ANALISTA, 'Ã­', 'í');
UPDATE monitorias SET ANALISTA = REPLACE(ANALISTA, 'Ã³', 'ó');
UPDATE monitorias SET ANALISTA = REPLACE(ANALISTA, 'Ãº', 'ú');
UPDATE monitorias SET ANALISTA = REPLACE(ANALISTA, 'Ã§', 'ç');
UPDATE monitorias SET ANALISTA = REPLACE(ANALISTA, 'Ã¢', 'â');
UPDATE monitorias SET ANALISTA = REPLACE(ANALISTA, 'Ãª', 'ê');
UPDATE monitorias SET ANALISTA = REPLACE(ANALISTA, 'Ã´', 'ô');
UPDATE monitorias SET ANALISTA = REPLACE(ANALISTA, 'Ã ', 'à');
GO

-- PASSO 5: Atualizar o Power BI
-- Após rodar tudo isso, volte ao Power BI e clique em Atualizar (F5)
PRINT 'Correção concluída! Agora clique em Atualizar no Power BI.';
GO

USE CallCenter;

UPDATE operadores SET TURNO  = 'Manhã'  WHERE TURNO  NOT IN ('Tarde','Noite','Madrugada');
UPDATE operadores SET STATUS = 'Férias' WHERE STATUS NOT IN ('Ativo','Afastado');
UPDATE operadores SET NOME   = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
    NOME,'VitÃ³ria','Vitória'),'Ã³','ó'),'Ã©','é'),'Ã£','ã'),'Ã­','í');

UPDATE monitorias SET ANALISTA = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
    ANALISTA,'VitÃ³ria','Vitória'),'Ã³','ó'),'Ã©','é'),'Ã£','ã'),'Ã­','í');

SELECT DISTINCT TURNO FROM operadores;
SELECT DISTINCT STATUS FROM operadores;
SELECT TOP 5 NOME FROM operadores ORDER BY NOME;

USE CallCenter;

UPDATE operadores SET STATUS = 'Férias' WHERE STATUS LIKE 'F%rias';

SELECT DISTINCT STATUS FROM operadores;
