# Diagnóstico, modelos mistos e dados de contagem

## Princípio geral

Diagnóstico não deve ser reduzido a um teste de normalidade ou a um
único valor de p. As funções desta vinheta organizam evidências e
preservam os objetos originais para inspeção detalhada.

## `diagnostico_modelo()`

### Exemplo 1: modelo linear

``` r

m1 <- lm(weight ~ group, data = PlantGrowth)
d1 <- diagnostico_modelo(m1, plot = FALSE)
#> Not enough model terms in the conditional part of the model to check for
#>   multicollinearity.
#> Diagnóstico do modelo
#> ---------------------
#> Classe: lm
#> Resposta: weight
#> n: 30
#> Interprete as verificações em conjunto com o delineamento, os resíduos e a finalidade científica.
d1$informacoes
#> $classe
#> [1] "lm"
#> 
#> $formula
#> [1] "weight ~ group"
#> 
#> $resposta
#> [1] "weight"
#> 
#> $n
#> [1] 30
#> 
#> $familia
#> [1] "gaussian"
#> 
#> $link
#> [1] "identity"
```

### Exemplo 2: Poisson

``` r

mp <- glm(breaks ~ wool * tension, poisson, data = warpbreaks)
d2 <- diagnostico_modelo(mp, simulations = 300, plot = FALSE)
#> Model has no observed zeros in the response variable.
#> Diagnóstico do modelo
#> ---------------------
#> Classe: glm/lm
#> Resposta: breaks
#> n: 54
#> Interprete as verificações em conjunto com o delineamento, os resíduos e a finalidade científica.
d2$verificacoes
#> $dispersao
#> # Overdispersion test
#> 
#>        dispersion ratio =   3.764
#>   Pearson's Chi-Squared = 180.666
#>                 p-value = < 0.001
#> Overdispersion detected.
#> 
#> $desempenho
#> # Indices of model performance
#> 
#> AIC   |  AICc |   BIC | Nagelkerke's R2 |   RMSE | Sigma | Score_log | Score_spherical
#> --------------------------------------------------------------------------------------
#> 469.0 | 470.8 | 480.9 |           0.885 | 10.315 |     1 |    -4.231 |           0.103
#> 
#> $uniformidade_DHARMa
#> 
#>  Asymptotic one-sample Kolmogorov-Smirnov test
#> 
#> data:  simulationOutput$scaledResiduals
#> D = 0.22203, p-value = 0.009744
#> alternative hypothesis: two-sided
#> 
#> 
#> $dispersao_DHARMa
#> 
#>  DHARMa nonparametric dispersion test via sd of residuals fitted vs.
#>  simulated
#> 
#> data:  simulationOutput
#> dispersion = 3.8847, p-value < 2.2e-16
#> alternative hypothesis: two.sided
#> 
#> 
#> $outliers_DHARMa
#> 
#>  DHARMa bootstrapped outlier test
#> 
#> data:  residuos_simulados
#> outliers at both margin(s) = 7, observations = 54, p-value < 2.2e-16
#> alternative hypothesis: two.sided
#>  percent confidence interval:
#>  0.00000000 0.03703704
#> sample estimates:
#> outlier frequency (expected: 0.00851851851851852 ) 
#>                                          0.1296296
```

### Exemplo 3: `glmmTMB`

``` r

mnb <- glmmTMB::glmmTMB(
  breaks ~ wool * tension,
  family = glmmTMB::nbinom2,
  data = warpbreaks
)
diagnostico_modelo(mnb, simulations = 1000, plot = TRUE)
```

Quando `performance` está instalado, a função agrega verificações de
heterocedasticidade, colinearidade, observações influentes, dispersão,
zeros, convergência e singularidade conforme a classe do modelo. Para
`glm`, `glmerMod` e `glmmTMB`, se `DHARMa` estiver disponível,
`simulations` controla o número de simulações usadas para produzir
resíduos escalonados e verificações complementares de uniformidade,
dispersão e observações discrepantes.

## `resumo_misto()`

### Exemplo 1: intercepto aleatório

``` r

mri <- lme4::lmer(Reaction ~ Days + (1 | Subject), data = lme4::sleepstudy)
resumo_misto(mri)
```

### Exemplo 2: intercepto e inclinação aleatórios

``` r

mrs <- lme4::lmer(Reaction ~ Days + (Days | Subject), data = lme4::sleepstudy)
resumo_misto(mrs)
```

### Exemplo 3: GLMM binomial e exponenciação

``` r

mg <- lme4::glmer(
  cbind(incidence, size - incidence) ~ period + (1 | herd),
  family = binomial,
  data = lme4::cbpp
)
resumo_misto(mg, exponentiate = TRUE)
```

A saída reúne efeitos fixos, ICs de Wald, componentes aleatórios e, com
`performance`, medidas como ICC e R² marginal/condicional, além das
verificações de convergência e singularidade.

## `diagnostico_contagem()`

### Exemplo 1: Poisson

``` r

dc1 <- diagnostico_contagem(mp, simulations = 300)
#> Model has no observed zeros in the response variable.
dc1$descritivo
#>    n    media variancia zeros proporcao_zeros
#> 1 54 28.14815  174.2041     0               0
dc1$dispersao_pearson
#>   razao_pearson gl      p_valor
#> 1      3.763881 48 2.926195e-17
```

### Exemplo 2: binomial negativa

``` r

mnb2 <- MASS::glm.nb(breaks ~ wool * tension, data = warpbreaks)
diagnostico_contagem(mnb2, simulations = 500)
```

### Exemplo 3: modelo com componente de zeros

``` r

mzi <- glmmTMB::glmmTMB(
  breaks ~ tension,
  ziformula = ~ 1,
  family = glmmTMB::nbinom2,
  data = warpbreaks
)
diagnostico_contagem(mzi, simulations = 1000)
```

Se `DHARMa` estiver instalado, são armazenados resíduos simulados e
testes de dispersão, zeros e observações discrepantes. A função nunca
muda a família do modelo automaticamente.

## `comparar_modelos()`

``` r

set.seed(10)
d <- data.frame(x = rep(0:4, each = 5))
d$y <- 4 + 1.2 * d$x - 0.15 * d$x^2 + rnorm(nrow(d))
ml <- lm(y ~ x, data = d)
mq <- lm(y ~ x + I(x^2), data = d)
```

### Exemplo 1: linear versus quadrático

``` r

comparar_modelos(linear = ml, quadratico = mq)
#> Comparação de modelos
#> --------------------
#>      modelo classe  n      AIC     AICc      BIC    logLik        R2      RMSE
#>      linear     lm 25 80.15744 81.30030 83.81407 -37.07872 0.2783577 1.0663166
#>  quadratico     lm 25 64.34426 66.34426 69.21976 -28.17213 0.6461043 0.7467287
#> 
#> Alertas de comparabilidade:
#> * Nenhum problema básico de comparabilidade foi identificado; ainda assim, a legitimidade científica da comparação deve ser verificada.
```

### Exemplo 2: Poisson versus binomial negativa

``` r

mp2 <- glm(breaks ~ wool * tension, poisson, data = warpbreaks)
mnb3 <- MASS::glm.nb(breaks ~ wool * tension, data = warpbreaks)
comparar_modelos(poisson = mp2, negbin = mnb3)
```

### Exemplo 3: métricas específicas

``` r

comparar_modelos(
  linear = ml,
  quadratico = mq,
  metrics = c("AICc", "BIC", "RMSE"),
  rank_by = "AICc"
)
#> Comparação de modelos
#> --------------------
#>      modelo classe  n     AICc      BIC      RMSE
#>  quadratico     lm 25 66.34426 69.21976 0.7467287
#>      linear     lm 25 81.30030 83.81407 1.0663166
#> 
#> Alertas de comparabilidade:
#> * Nenhum problema básico de comparabilidade foi identificado; ainda assim, a legitimidade científica da comparação deve ser verificada.
```

A ordenação por uma métrica é somente uma forma de organizar a tabela. A
escolha final deve considerar comparabilidade, delineamento,
diagnóstico, interpretação e finalidade do modelo.
