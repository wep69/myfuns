# Resumir modelos mistos

Organiza efeitos fixos, intervalos de confiança de Wald, componentes de
variância, ICC, R² marginal e condicional, singularidade e convergência
para modelos \`merMod\` e \`glmmTMB\` quando as informações estão
disponíveis.

## Usage

``` r
resumo_misto(model, conf.level = 0.95, exponentiate = FALSE)
```

## Arguments

- model:

  Modelo misto.

- conf.level:

  Nível de confiança dos efeitos fixos.

- exponentiate:

  Exponenciar estimativas e intervalos dos efeitos fixos?

## Value

Lista da classe \`myfuns_resumo_misto\`.

## Details

Consulte as vinhetas do pacote para interpretação, limitações e fluxos
integrados. A função não deve substituir a avaliação do delineamento e
da pergunta científica.

## Examples

``` r
if (requireNamespace("lme4", quietly = TRUE)) {
m1 <- lme4::lmer(Reaction ~ Days + (1 | Subject), data = lme4::sleepstudy)
resumo_misto(m1)
}
#> Resumo do modelo misto
#> ----------------------
#>        termo estimativa erro_padrao estatistica ic_inferior ic_superior
#>  (Intercept)  251.40510   9.7467163    25.79383  232.301892   270.50832
#>         Days   10.46729   0.8042214    13.01543    8.891041    12.04353
#> 
#> Componentes de variância:
#>       grp        var1 var2      vcov    sdcor
#>   Subject (Intercept) <NA> 1378.1785 37.12383
#>  Residual        <NA> <NA>  960.4566 30.99123
#> 
#> Desempenho do modelo:
#> # Indices of model performance
#> 
#> AIC    |   AICc |    BIC | R2 (cond.) | R2 (marg.) |   ICC |   RMSE |  Sigma
#> ----------------------------------------------------------------------------
#> 1794.5 | 1794.7 | 1807.2 |      0.704 |      0.280 | 0.589 | 29.411 | 30.991

if (requireNamespace("lme4", quietly = TRUE)) {
m2 <- lme4::lmer(Reaction ~ Days + (Days | Subject), data = lme4::sleepstudy)
resumo_misto(m2)
}
#> Resumo do modelo misto
#> ----------------------
#>        termo estimativa erro_padrao estatistica ic_inferior ic_superior
#>  (Intercept)  251.40510    6.824597   36.838090  238.029141   264.78107
#>         Days   10.46729    1.545790    6.771481    7.437594    13.49698
#> 
#> Componentes de variância:
#>       grp        var1 var2       vcov       sdcor
#>   Subject (Intercept) <NA> 612.100158 24.74065799
#>   Subject        Days <NA>  35.071714  5.92213766
#>   Subject (Intercept) Days   9.604409  0.06555124
#>  Residual        <NA> <NA> 654.940008 25.59179572
#> 
#> Desempenho do modelo:
#> # Indices of model performance
#> 
#> AIC    |   AICc |    BIC | R2 (cond.) | R2 (marg.) |   ICC |   RMSE |  Sigma
#> ----------------------------------------------------------------------------
#> 1755.6 | 1756.1 | 1774.8 |      0.799 |      0.279 | 0.722 | 23.438 | 25.592

if (requireNamespace("lme4", quietly = TRUE)) {
m3 <- lme4::glmer(cbind(incidence, size - incidence) ~ period + (1 | herd),
family = binomial, data = lme4::cbpp)
resumo_misto(m3, exponentiate = TRUE)
}
#> Can't calculate log-loss.
#> Can't calculate proper scoring rules for models without integer response
#>   values.
#> Resumo do modelo misto
#> ----------------------
#>        termo estimativa erro_padrao estatistica      p_valor ic_inferior
#>  (Intercept)  0.2470059   0.2312140   -6.047830 1.468096e-09   0.1569993
#>      period2  0.3708621   0.3031505   -3.272054 1.067691e-03   0.2047247
#>      period3  0.3236100   0.3228300   -3.494769 4.744727e-04   0.1718813
#>      period4  0.2060275   0.4220489   -3.743039 1.818082e-04   0.0900900
#>  ic_superior
#>    0.3886128
#>    0.6718227
#>    0.6092778
#>    0.4711660
#> 
#> Componentes de variância:
#>   grp        var1 var2      vcov     sdcor
#>  herd (Intercept) <NA> 0.4122538 0.6420699
#> 
#> Desempenho do modelo:
#> # Indices of model performance
#> 
#> AIC   |  AICc |   BIC | R2 (cond.) | R2 (marg.) |   ICC |  RMSE | Sigma | Log_loss
#> ----------------------------------------------------------------------------------
#> 194.1 | 195.3 | 204.2 |      0.776 |      0.354 | 0.653 | 0.099 |     1 |         
```
