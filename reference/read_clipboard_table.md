# Ler tabela da área de transferência

Nome moderno para o fluxo histórico de \[read_excel()\]. A função lê
texto tabulado da área de transferência nativa do Windows; não abre
arquivos XLSX.

## Usage

``` r
read_clipboard_table(header = TRUE, ...)
```

## Arguments

- header:

  A primeira linha contém nomes de colunas?

- ...:

  Argumentos adicionais para \[utils::read.table()\].

## Value

\`data.frame\`.

## Details

Consulte as vinhetas do pacote para interpretação, limitações e fluxos
integrados. A função não deve substituir a avaliação do delineamento e
da pergunta científica.

## Examples

``` r
if (FALSE) dados <- read_clipboard_table() # \dontrun{}

if (FALSE) dados <- read_clipboard_table(dec = ",", na.strings = c("", "NA")) # \dontrun{}

if (FALSE) dados <- read_clipboard_table(header = FALSE) # \dontrun{}
```
