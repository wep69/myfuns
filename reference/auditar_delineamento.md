# Auditar a estrutura de um delineamento experimental

Examina o banco de dados antes do ajuste do modelo e identifica
problemas frequentes em experimentação: combinações ausentes,
duplicações de unidades, desbalanceamento e valores ausentes na variável
resposta.

## Usage

``` r
auditar_delineamento(data,
                                   tratamento,
                                   bloco = NULL,
                                   unidade = NULL,
                                   fatores = NULL,
                                   resposta = NULL)
```

## Arguments

- data:

  \`data.frame\` contendo o experimento.

- tratamento:

  Variável que identifica o tratamento principal. Aceita nome sem aspas
  ou string.

- bloco:

  Variável de bloco, quando houver. O padrão é \`NULL\`.

- unidade:

  Identificador da unidade experimental, quando disponível.

- fatores:

  Fatores adicionais do delineamento. Pode ser informado como
  \`c(fator1, fator2)\` ou vetor de nomes.

- resposta:

  Variável resposta a ser verificada quanto a valores ausentes.

## Value

Lista da classe \`myfuns_delineamento\` com resumo, níveis, frequências,
células ausentes, duplicações, valores ausentes, indicador de
balanceamento e mensagens de atenção.

## Details

Consulte as vinhetas do pacote para interpretação, limitações e fluxos
integrados. A função não deve substituir a avaliação do delineamento e
da pergunta científica.

## Examples

``` r
dados <- expand.grid(bloco = factor(1:4), tratamento = factor(c("A", "B", "C")))
dados$y <- c(10, 12, 14, 11, 13, 15, 9, 12, 16, 10, 14, 17)
auditar_delineamento(dados, tratamento, bloco, resposta = y)
#> Auditoria do delineamento
#> -------------------------
#>                         item valor
#>                  Observações    12
#>    Variáveis do delineamento     2
#>             Células ausentes     0
#>  Linhas em chaves duplicadas     0
#>           Respostas ausentes     0
#>                   Balanceado     1
#> 
#> Mensagens:
#> * Duplicação de unidade experimental não foi avaliada porque `unidade` não foi informada.

dados2 <- dados[-5, ]
auditar_delineamento(dados2, tratamento, bloco)
#> Auditoria do delineamento
#> -------------------------
#>                         item valor
#>                  Observações    11
#>    Variáveis do delineamento     2
#>             Células ausentes     1
#>  Linhas em chaves duplicadas     0
#>           Respostas ausentes    NA
#>                   Balanceado     0
#> 
#> Mensagens:
#> * 1 combinação(ões) do delineamento sem observação.
#> * Duplicação de unidade experimental não foi avaliada porque `unidade` não foi informada.
#> * O conjunto não apresenta o mesmo número de observações em todas as combinações previstas.

fat <- expand.grid(
bloco = factor(1:3), salinidade = factor(c("0.5", "3.0")),
plantas = factor(c("1", "2")), porta_enxerto = factor(c("A", "B"))
)
fat$y <- seq_len(nrow(fat))
auditar_delineamento(
fat, salinidade, bloco, fatores = c(plantas, porta_enxerto), resposta = y
)
#> Auditoria do delineamento
#> -------------------------
#>                         item valor
#>                  Observações    24
#>    Variáveis do delineamento     4
#>             Células ausentes     0
#>  Linhas em chaves duplicadas     0
#>           Respostas ausentes     0
#>                   Balanceado     1
#> 
#> Mensagens:
#> * Duplicação de unidade experimental não foi avaliada porque `unidade` não foi informada.
```
