# Ajustar regressões polinomiais para fatores quantitativos

Ajusta modelos polinomiais brutos de graus especificados, preserva todos
os modelos candidatos e produz medidas comparativas, intervalos dos
coeficientes, teste de falta de ajuste quando há repetição de níveis e
predições para o modelo de maior grau solicitado. A função não seleciona
automaticamente o "melhor" modelo.

## Usage

``` r
reg_poly(data,
                       y,
                       x,
                       degree = 1:3,
                       weights = NULL,
                       compare = TRUE,
                       lack_of_fit = TRUE,
                       conf.level = 0.95)
```

## Arguments

- data:

  \`data.frame\`.

- y:

  Variável resposta numérica.

- x:

  Variável quantitativa numérica.

- degree:

  Grau ou vetor de graus, por exemplo \`1:3\`.

- weights:

  Pesos opcionais. Pode ser uma variável do banco ou vetor numérico com
  comprimento igual ao número de linhas.

- compare:

  Produzir tabela comparativa dos modelos? Padrão \`TRUE\`.

- lack_of_fit:

  Calcular teste de falta de ajuste quando possível?

- conf.level:

  Nível de confiança para coeficientes e predições.

## Value

Objeto da classe \`myfuns_reg_poly\`.

## Details

Consulte as vinhetas do pacote para interpretação, limitações e fluxos
integrados. A função não deve substituir a avaliação do delineamento e
da pergunta científica.

## Examples

``` r
set.seed(1)
d <- expand.grid(rep = factor(1:4), dose = c(0, 50, 100, 150, 200))
d$y <- 20 + 0.2 * d$dose - 0.0007 * d$dose^2 + stats::rnorm(nrow(d), 0, 2)
reg_poly(d, y, dose, degree = 1:2)
#> Regressão polinomial
#> --------------------
#> Resposta: y
#> Preditor: dose
#> Modelo principal para predição: grau 2
#> 
#> Comparação descritiva dos modelos:
#>  grau  n        R2 R2_ajustado     RMSE       AIC      AICc       BIC
#>     1 20 0.6320019   0.6115576 3.321659 110.77612 112.27612 113.76332
#>     2 20 0.8951746   0.8828422 1.772824  87.66049  90.32715  91.64342
#> 
#> Teste de falta de ajuste:
#>  grau gl_falta_ajuste SQ_falta_ajuste         F      p_valor
#>     1               3       168.30786 16.072015 5.945611e-05
#>     2               2        10.49754  1.503644 2.539933e-01

reg_poly(d, y, dose, degree = 2, compare = FALSE)
#> Regressão polinomial
#> --------------------
#> Resposta: y
#> Preditor: dose
#> Modelo principal para predição: grau 2
#> 
#> Teste de falta de ajuste:
#>  grau gl_falta_ajuste SQ_falta_ajuste        F   p_valor
#>     2               2        10.49754 1.503644 0.2539933

rp <- reg_poly(d, y, dose, degree = 1:3, compare = TRUE)
rp$comparacao
#>   grau  n        R2 R2_ajustado     RMSE       AIC      AICc       BIC
#> 1    1 20 0.6320019   0.6115576 3.321659 110.77612 112.27612 113.76332
#> 2    2 20 0.8951746   0.8828422 1.772824  87.66049  90.32715  91.64342
#> 3    3 20 0.9033634   0.8852440 1.702171  88.03372  92.31943  93.01238
```
