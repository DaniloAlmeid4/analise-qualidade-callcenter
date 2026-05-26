SELECT 'operadores' AS tabela, COUNT(*) AS total FROM dbo.operadores
UNION ALL
SELECT 'atendimentos', COUNT(*) FROM dbo.atendimentos
UNION ALL
SELECT 'monitorias', COUNT(*) FROM dbo.monitorias;