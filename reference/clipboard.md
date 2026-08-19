# Transferir tabelas entre R e Excel pela area de transferencia

Funcoes historicas para fluxo copiar/colar com Excel no Windows. Nao
leem nem escrevem arquivos .xlsx diretamente.

## Usage

``` r
read_excel(header = TRUE, ...)

write_excel(x, row.names = FALSE, col.names = TRUE, ...)
```

## Arguments

- header:

  A primeira linha contem nomes de colunas?

- x:

  Objeto tabular a copiar.

- row.names:

  Copiar nomes das linhas?

- col.names:

  Copiar nomes das colunas?

- ...:

  Argumentos adicionais para
  [`read.table()`](https://rdrr.io/r/utils/read.table.html) ou
  [`write.table()`](https://rdrr.io/r/utils/write.table.html).

## Value

`read_excel()` retorna um `data.frame`; `write_excel()` retorna `NULL`
invisivelmente.

## Examples

``` r
if (FALSE) { # \dontrun{
dados <- read_excel(header = TRUE, dec = ",")
write_excel(dados)
} # }
```
