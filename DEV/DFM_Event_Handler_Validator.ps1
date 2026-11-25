<#
.SINOPSE
    Validador de Manipuladores de Eventos DFM

.DESCRIÇÃO
    Percorre recursivamente os arquivos Delphi (.pas) e verifica se os
    métodos de tratamento de eventos declarados na seção interface possuem
    uma associação correspondente nos arquivos DFM (.dfm).

    Identifica procedimentos que recebem os parâmetros Sender ou Control,
    mas que não estão associados a nenhuma propriedade de evento (OnEvent)
    no respectivo arquivo DFM.

    Útil para identificar possíveis manipuladores de eventos sem associação,
    inconsistências entre arquivos PAS e DFM e métodos remanescentes após
    modificações nos formulários.

.SAÍDA
    Exibe o nome do arquivo PAS e o nome de cada procedimento para o qual
    não foi encontrada uma associação de evento correspondente no DFM.

.OBSERVAÇÕES
    Requer Windows PowerShell ou PowerShell 7 ou superior.
    Não utiliza módulos ou dependências externas.
#>
Get-ChildItem -Recurse -Filter *.pas | ForEach-Object {
  $pasFile = $_.FullName
  $dfmFile = [IO.Path]::ChangeExtension($pasFile, '.dfm')
  if (-not (Test-Path $dfmFile)) { return }

  $pas   = Get-Content $pasFile -Raw
  $iface = ($pas -split '(?im)^\s*implementation')[0]   # só a seção interface
  $dfm   = Get-Content $dfmFile -Raw

  [regex]::Matches($iface, '(?im)^\s*procedure\s+(\w+)\s*\(\s*(Sender|Control)\s*:') |
  ForEach-Object {
    $nome = $_.Groups[1].Value
    if ($dfm -notmatch "(?im)^\s*On\w+\s*=\s*$nome\s*$") {
      "{0}  ->  {1}" -f (Split-Path $pasFile -Leaf), $nome
    }
  }
}