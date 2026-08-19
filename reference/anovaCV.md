# Tabela de ANOVA e coeficiente de variação

Retorna a tabela de análise de variância e o coeficiente de variação
experimental em porcentagem.

## Usage

``` r
anovaCV(x, digits = 1)
```

## Arguments

- x:

  Modelo ajustado aceito por
  [`anova()`](https://rdrr.io/r/stats/anova.html), tipicamente `lm`,
  `aov` ou modelo misto para o qual
  [`sigma()`](https://rdrr.io/r/stats/sigma.html) esteja definido.

- digits:

  Número de casas decimais usadas no CV.

## Details

O CV é calculado como 100 vezes o desvio-padrão residual, obtido por
`sigma(modelo)`, dividido pelo valor absoluto da média da resposta. O
valor deve ser interpretado no contexto da variável, da escala e do
delineamento experimental.

## Value

Lista com os componentes `Anova` e `CV`.

## Examples

``` r
dados <- data.frame(
  tratamento = factor(rep(c("A", "B", "C"), each = 4)),
  y = c(10, 11, 9, 10, 13, 12, 14, 13, 16, 15, 17, 16)
)
mod <- lm(y ~ tratamento, data = dados)
anovaCV(mod)
#> $Anova
#> Analysis of Variance Table
#> 
#> Response: y
#>            Df Sum Sq Mean Sq F value    Pr(>F)    
#> tratamento  2     72  36.000      54 9.711e-06 ***
#> Residuals   9      6   0.667                      
#> ---
#> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#> 
#> $CV
#> [1] 6.3
#> 
```
