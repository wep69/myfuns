# Calcular médias marginais estimadas para uma lista de modelos

Aplica \[emmeans::emmeans()\] aos elementos selecionados de uma lista de
modelos. É útil quando várias variáveis resposta compartilham a mesma
estrutura experimental.

## Usage

``` r
emmeans_lista(object, specs, ..., which = seq_along(object))
```

## Arguments

- object:

  Lista de modelos.

- specs:

  Especificação repassada a \[emmeans::emmeans()\].

- ...:

  Argumentos adicionais para \[emmeans::emmeans()\].

- which:

  Índices dos elementos que serão processados.

## Value

Lista de objetos \`emmGrid\`.

## Details

Consulte as vinhetas do pacote para interpretação, limitações e fluxos
integrados. A função não deve substituir a avaliação do delineamento e
da pergunta científica.

## Examples

``` r
m1 <- stats::lm(Sepal.Length ~ Species, data = iris)
m2 <- stats::lm(Petal.Length ~ Species, data = iris)
emmeans_lista(list(sepala = m1, petala = m2), ~ Species)
#> $sepala
#>  Species    emmean     SE  df lower.CL upper.CL
#>  setosa       5.01 0.0728 147     4.86     5.15
#>  versicolor   5.94 0.0728 147     5.79     6.08
#>  virginica    6.59 0.0728 147     6.44     6.73
#> 
#> Confidence level used: 0.95 
#> 
#> $petala
#>  Species    emmean     SE  df lower.CL upper.CL
#>  setosa       1.46 0.0609 147     1.34     1.58
#>  versicolor   4.26 0.0609 147     4.14     4.38
#>  virginica    5.55 0.0609 147     5.43     5.67
#> 
#> Confidence level used: 0.95 
#> 

mods <- list(sepala = m1, petala = m2)
emmeans_lista(mods, ~ Species, which = 2)
#> $petala
#>  Species    emmean     SE  df lower.CL upper.CL
#>  setosa       1.46 0.0609 147     1.34     1.58
#>  versicolor   4.26 0.0609 147     4.14     4.38
#>  virginica    5.55 0.0609 147     5.43     5.67
#> 
#> Confidence level used: 0.95 
#> 

mp <- stats::glm(breaks ~ wool * tension, poisson, data = warpbreaks)
emmeans_lista(list(quebras = mp), ~ tension | wool, type = "response")
#> $quebras
#> wool = A:
#>  tension rate   SE  df asymp.LCL asymp.UCL
#>  L       44.6 2.22 Inf      40.4      49.1
#>  M       24.0 1.63 Inf      21.0      27.4
#>  H       24.6 1.65 Inf      21.5      28.0
#> 
#> wool = B:
#>  tension rate   SE  df asymp.LCL asymp.UCL
#>  L       28.2 1.77 Inf      25.0      31.9
#>  M       28.8 1.79 Inf      25.5      32.5
#>  H       18.8 1.44 Inf      16.1      21.8
#> 
#> Confidence level used: 0.95 
#> Intervals are back-transformed from the log scale 
#> 
```
