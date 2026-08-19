# Escrever tabela na área de transferência

Nome moderno para o fluxo histórico de \[write_excel()\]. Escreve uma
tabela separada por tabulações para colagem em Excel ou software
equivalente no Windows.

## Usage

``` r
write_clipboard_table(x, row.names = FALSE, col.names = TRUE, ...)
```

## Arguments

- x:

  Objeto tabular.

- row.names:

  Exportar nomes das linhas?

- col.names:

  Exportar nomes das colunas?

- ...:

  Argumentos adicionais para \[utils::write.table()\].

## Value

Invisivelmente, \`NULL\`.

## Details

Consulte as vinhetas do pacote para interpretação, limitações e fluxos
integrados. A função não deve substituir a avaliação do delineamento e
da pergunta científica.

## Examples

``` r
if (FALSE) write_clipboard_table(head(iris)) # \dontrun{}

if (FALSE) write_clipboard_table(aggregate(Sepal.Length ~ Species, iris, mean)) # \dontrun{}

if (FALSE) write_clipboard_table(head(mtcars), row.names = TRUE, col.names = TRUE) # \dontrun{}
```
