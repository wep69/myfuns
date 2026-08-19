# Gerar equacao de regressao a partir de medias e contrastes polinomiais

Seleciona uma representacao constante, linear ou quadratica a partir dos
p-valores dos contrastes polinomiais e retorna texto compativel com
plotmath.

## Usage

``` r
equar2(
  media,
  contrast_result,
  alpha = 0.05,
  strong_alpha = 0.01,
  digits = c(2, 3, 4, 1),
  r2_percent = TRUE,
  details = FALSE
)
```

## Arguments

- media:

  Objeto coercivel a `data.frame` com x na primeira coluna e medias de y
  na segunda.

- contrast_result:

  Objeto com colunas `contrast` e `p.value`, tipicamente obtido com
  `emmeans::contrast(..., "poly")` ou por
  [`contraste_poly()`](https://wep69.github.io/myfuns/reference/contraste_poly.md).

- alpha:

  Nivel de significancia usado para selecionar o grau do modelo.

- strong_alpha:

  Nivel de significancia usado para marcar `**`.

- digits:

  Quatro valores para casas decimais do intercepto/media, termo linear,
  termo quadratico e R2.

- r2_percent:

  Mostrar R2 em porcentagem?

- details:

  Retornar lista detalhada em vez de somente a equacao?

## Details

O R2 corresponde a regressao ajustada sobre as medias fornecidas, e nao
sobre as observacoes individuais. Os asteriscos sao definidos pelos
p-valores em `contrast_result`.

Para níveis quantitativos desigualmente espaçados, recomenda-se
[`contraste_poly()`](https://wep69.github.io/myfuns/reference/contraste_poly.md),
que usa os escores numéricos reais. Quando o objeto retornado por essa
função é fornecido diretamente, `equar2()` reconhece os escores
utilizados e evita avisos indevidos.

## Value

Por padrao, string plotmath. Com `details = TRUE`, lista contendo
`equation`, `degree`, `model`, `r_squared`, `p_values` e `data`.

## Examples

``` r
dados <- data.frame(
  TRAT = rep(c(0, 50, 100, 150, 200), 4),
  REP = rep(1:4, each = 5),
  PESO = c(20, 25, 30, 29, 24,
           21, 26, 31, 30, 25,
           19, 24, 29, 28, 23,
           20, 25, 32, 29, 24)
)
dados$TRATq <- dados$TRAT
dados$TRAT <- factor(dados$TRAT)
modelo <- lm(PESO ~ TRAT, data = dados)
teste <- as.data.frame(
  emmeans::contrast(emmeans::emmeans(modelo, ~ TRAT), "poly")
)
medias <- aggregate(PESO ~ TRATq, data = dados, FUN = mean)
equar2(medias, teste)
#> [1] "hat(y) == 19.44 + 0.178^\"**\" * x - 0.0008^\"**\" * x^2 ~ \";\" ~ R^2 == \"95.2%\""
```
