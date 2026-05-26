📊 Análise de Qualidade — Call Center
Dashboard completo de análise de qualidade de call center desenvolvido com Python, SQL Server, Excel e Power BI.

🎯 Sobre o Projeto
Este projeto simula o trabalho real de um Analista de Qualidade de Call Center, cobrindo todo o fluxo de dados: da geração da base até o dashboard executivo. Foi desenvolvido como projeto de portfólio para demonstrar habilidades em análise de dados aplicadas ao contexto de operações de call center.

🛠️ Tecnologias Utilizadas
FerramentaFinalidadePythonGeração da base de dados fictícia, limpeza e tratamentoSQL ServerBanco de dados relacional com 3 tabelas e queries analíticasExcelRelatório gerencial com SUMIF, INDEX/MATCH e tabelas dinâmicasPower BIDashboard interativo com DAX e visualizações profissionais

📁 Estrutura do Projeto
analise-qualidade-callcenter/
│
├── dados/
│   ├── operadores.csv        # Cadastro de 200 operadores
│   ├── atendimentos.csv      # 7.476 registros diários (Jan-Mar 2024)
│   └── monitorias.csv        # 1.836 monitorias de qualidade
│
├── scripts/
│   ├── gerar_base.py         # Geração da base fictícia com Faker
│   ├── corrigir_encoding.py  # Correção de encoding UTF-8
│   └── callcenter.sql        # Criação das tabelas e queries analíticas
│
├── powerbi/
│   ├── dashboard_visao_geral.png
│   └── dashboard_detalhe.png
│
└── README.md

📐 Modelo de Dados
Três tabelas conectadas pelo campo AVAYALOGIN:

operadores — cadastro com nome, supervisor, segmento, turno, tempo de casa e status
atendimentos — registros diários com KPIs: atendidas, RECH, TMA, talktime, ACW, transferências e NPS
monitorias — notas de qualidade com 8 critérios avaliados por ligação


📈 KPIs Analisados

% RECH — taxa de abandono de chamadas por supervisor
NPS — Net Promoter Score calculado como (Promotoras - Detratoras) / Avaliadas × 100
TMA — Tempo Médio de Atendimento em minutos
ACW — After Call Work (tempo pós-atendimento)
Nota de Monitoria — média das avaliações de qualidade por operador


🗄️ Queries SQL Implementadas

% RECH por supervisor
NPS por supervisor
TMA e ACW médio por equipe
Operadores fora da meta (RECH > 15%)
Operadores com menos de 2 monitorias no mês
Notas por critério de qualidade
Evolução mensal do NPS
Ranking top 10 operadores


📊 Dashboard Power BI
O dashboard foi construído com medidas DAX e conta com:

5 cartões KPI no topo (Total Atendidas, % RECH, NPS, TMA, Nota Monitoria)
Gráfico de barras: % RECH por supervisor
Gráfico de barras: NPS por supervisor
Gráfico de linha: evolução mensal do NPS
Tabela ranking de operadores com formatação condicional
Filtros interativos por Supervisor, Segmento, Turno e Status


🚀 Como Executar
1. Gerar a base de dados:
bashpip install pandas faker
python scripts/gerar_base.py
2. Criar o banco no SQL Server:

Abra o scripts/callcenter.sql no SSMS
Ajuste o caminho dos CSVs na seção BULK INSERT
Execute com Ctrl+A → F5

3. Visualizar o dashboard:

Abra o Power BI Desktop
Conecte ao banco CallCenter no SQL Server local
Importe o tema tema_callcenter_azul.json


👨‍💻 Sobre o Autor
Profissional com experiência como operador de call center na AeC (atendimento Bradesco Saúde) e formação em Eng. da Computação. Essa vivência prática no ambiente de call center combinada com o conhecimento técnico em dados permite uma visão diferenciada na análise de KPIs operacionais.

📬 Contato

LinkedIn: DaniloAlmeid4
E-mail: daniloalmeidadosssantos@gmail.com
