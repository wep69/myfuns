# Contrastes polinomiais com os valores reais do fator quantitativo

Calcula contrastes polinomiais ortogonais com \`emmeans\`. Quando os
níveis quantitativos são desigualmente espaçados, utiliza \`opoly\`, que
admite \`scores\` reais. A função informa explicitamente os escores
usados e não escolhe automaticamente o grau da regressão.

## Usage

``` r
contraste_poly(emm,
                             scores = NULL,
                             degree = NULL,
                             normalized = TRUE,
                             adjust = "none")
```

## Arguments

- emm:

  Objeto \`emmGrid\` com médias estimadas de um fator quantitativo.

- scores:

  Valores numéricos correspondentes aos níveis. Se \`NULL\`, a função
  tenta converter os níveis do primeiro fator do \`emmGrid\` para
  número.

- degree:

  Maior grau a ser retornado. \`NULL\` usa o máximo permitido.

- normalized:

  Se \`TRUE\`, usa \`opoly\`, cujos coeficientes são normalizados. Se
  \`FALSE\`, \`poly\` só é usado quando os escores são igualmente
  espaçados.

- adjust:

  Ajuste de multiplicidade. O padrão é \`"none"\`.

## Value

Lista da classe \`myfuns_contraste_poly\` com objeto de contraste,
tabela, escores, grau e informação sobre espaçamento.

## Details

Consulte as vinhetas do pacote para interpretação, limitações e fluxos
integrados. A função não deve substituir a avaliação do delineamento e
da pergunta científica.

## Examples

``` r
dados <- data.frame(dose = factor(rep(c(0, 50, 100, 150), each = 4)), y = 1:16)
m <- stats::lm(y ~ dose, data = dados)
em <- emmeans::emmeans(m, ~ dose)
contraste_poly(em, scores = c(0, 50, 100, 150))
#> Contrastes polinomiais
#> -----------------------
#> Método: opoly
#> Escores: 0=0, 50=50, 100=100, 150=150
#> Espaçamento regular: sim
#> 
#>  contrast  estimate        SE df  lower.CL  upper.CL t.ratio p.value
#>  linear    8.944272 0.6454972 12  7.537854 10.350690  13.856 <0.0001
#>  quadratic 0.000000 0.6454972 12 -1.406418  1.406418   0.000  1.0000
#>  cubic     0.000000 0.6454972 12 -1.406418  1.406418   0.000  1.0000
#> 
#> Confidence level used: 0.95 

dados2 <- data.frame(dose = factor(rep(c(0, 25, 100, 200), each = 4)), y = 1:16)
m2 <- stats::lm(y ~ dose, data = dados2)
em2 <- emmeans::emmeans(m2, ~ dose)
contraste_poly(em2, scores = c(0, 25, 100, 200))
#> Contrastes polinomiais
#> -----------------------
#> Método: opoly
#> Escores: 0=0, 25=25, 100=100, 200=200
#> Espaçamento regular: não
#> 
#>  contrast   estimate        SE df  lower.CL  upper.CL t.ratio p.value
#>  linear     8.674769 0.6454972 12  7.268351 10.081186  13.439 <0.0001
#>  quadratic -1.768962 0.6454972 12 -3.175379 -0.362544  -2.740  0.0179
#>  cubic      1.272463 0.6454972 12 -0.133955  2.678880   1.971  0.0722
#> 
#> Confidence level used: 0.95 

contraste_poly(em, scores = c(0, 50, 100, 150), degree = 2)
#> Contrastes polinomiais
#> -----------------------
#> Método: opoly
#> Escores: 0=0, 50=50, 100=100, 150=150
#> Espaçamento regular: sim
#> 
#>  contrast  estimate        SE df  lower.CL  upper.CL t.ratio p.value
#>  linear    8.944272 0.6454972 12  7.537854 10.350690  13.856 <0.0001
#>  quadratic 0.000000 0.6454972 12 -1.406418  1.406418   0.000  1.0000
#> 
#> Confidence level used: 0.95 
```
