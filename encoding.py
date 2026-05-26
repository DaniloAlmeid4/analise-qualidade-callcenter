import pandas as pd

# lê e regrava com UTF-8-sig (BOM)
for arq in ['operadores', 'atendimentos', 'monitorias']:
  df = pd.read_csv(f'{arq}.csv', encoding='utf-8')
  df.to_csv(f'{arq}.csv', index=False, encoding='utf-8-sig')
  print(f'{arq}.csv corrigido!')

print('Todos os arquivos corrigidos.')