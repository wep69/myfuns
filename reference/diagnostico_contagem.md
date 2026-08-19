# Diagnóstico de modelos de contagem

Centraliza verificações de dispersão, frequência de zeros, resíduos
simulados e observações discrepantes para modelos de contagem. A função
não troca a família do modelo automaticamente.

## Usage

``` r
diagnostico_contagem(model,
                                   simulations = 1000,
                                   test_dispersion = TRUE,
                                   test_zeros = TRUE,
                                   test_outliers = TRUE,
                                   seed = 123)
```

## Arguments

- model:

  Modelo de contagem ajustado.

- simulations:

  Número de simulações para \`DHARMa\`.

- test_dispersion:

  Executar teste de dispersão?

- test_zeros:

  Executar teste de excesso ou deficiência de zeros?

- test_outliers:

  Executar teste de observações discrepantes?

- seed:

  Semente para as simulações.

## Value

Lista da classe \`myfuns_diagnostico_contagem\`.

## Details

Consulte as vinhetas do pacote para interpretação, limitações e fluxos
integrados. A função não deve substituir a avaliação do delineamento e
da pergunta científica.

## Examples

``` r
mp <- stats::glm(breaks ~ wool * tension, poisson, data = warpbreaks)
diagnostico_contagem(mp, simulations = 200)
#> Model has no observed zeros in the response variable.
#> $descritivo
#>    n    media variancia zeros proporcao_zeros
#> 1 54 28.14815  174.2041     0               0
#> 
#> $familia
#> $familia$family
#> [1] "poisson"
#> 
#> $familia$link
#> [1] "log"
#> 
#> 
#> $dispersao_pearson
#>   razao_pearson gl      p_valor
#> 1      3.763881 48 2.926195e-17
#> 
#> $verificacoes
#> $verificacoes$dispersao_performance
#> # Overdispersion test
#> 
#>        dispersion ratio =   3.764
#>   Pearson's Chi-Squared = 180.666
#>                 p-value = < 0.001
#> 
#> Overdispersion detected.
#> 
#> $verificacoes$dispersao_DHARMa
#> 
#>  DHARMa nonparametric dispersion test via sd of residuals fitted vs.
#>  simulated
#> 
#> data:  simulationOutput
#> dispersion = 3.9223, p-value < 2.2e-16
#> alternative hypothesis: two.sided
#> 
#> 
#> $verificacoes$zeros_DHARMa
#> 
#>  DHARMa zero-inflation test via comparison to expected zeros with
#>  simulation under H0 = fitted model
#> 
#> data:  simulationOutput
#> ratioObsSim = NaN, p-value = 1
#> alternative hypothesis: two.sided
#> 
#> 
#> $verificacoes$outliers_DHARMa
#> 
#>  DHARMa bootstrapped outlier test
#> 
#> data:  simulados
#> outliers at both margin(s) = 7, observations = 54, p-value < 2.2e-16
#> alternative hypothesis: two.sided
#>  percent confidence interval:
#>  0.00000000 0.03703704
#> sample estimates:
#> outlier frequency (expected: 0.0137037037037037 ) 
#>                                         0.1296296 
#> 
#> 
#> 
#> $residuos_simulados
#> Object of Class DHARMa with simulated residuals based on 200 simulations with refit = FALSE . See ?DHARMa::simulateResiduals for help. 
#>  
#> Scaled residual values: 0 0.006242665 0.9128284 0 1 0.878696 0.808071 0 0.9971399 0.1417534 0.2037337 0.862446 0.03952264 0.005 0.1156171 0.9813769 0.9056927 0.9838312 0.978263 0.2337218 ...
#> $modelo
#> 
#> Call:  stats::glm(formula = breaks ~ wool * tension, family = poisson, 
#>     data = warpbreaks)
#> 
#> Coefficients:
#>    (Intercept)           woolB        tensionM        tensionH  woolB:tensionM  
#>         3.7967         -0.4566         -0.6187         -0.5958          0.6382  
#> woolB:tensionH  
#>         0.1884  
#> 
#> Degrees of Freedom: 53 Total (i.e. Null);  48 Residual
#> Null Deviance:       297.4 
#> Residual Deviance: 182.3     AIC: 469
#> 
#> $simulations
#> [1] 200
#> 
#> $seed
#> [1] 123
#> 
#> attr(,"class")
#> [1] "myfuns_diagnostico_contagem" "list"                       

if (requireNamespace("MASS", quietly = TRUE)) {
mnb <- MASS::glm.nb(breaks ~ wool * tension, data = warpbreaks)
diagnostico_contagem(mnb, simulations = 200)
}
#> Model has no observed zeros in the response variable.
#> $descritivo
#>    n    media variancia zeros proporcao_zeros
#> 1 54 28.14815  174.2041     0               0
#> 
#> $familia
#> $familia$family
#> [1] "Negative Binomial(12.0822)"
#> 
#> $familia$link
#> [1] "log"
#> 
#> 
#> $dispersao_pearson
#>   razao_pearson gl   p_valor
#> 1      1.079551 48 0.3272531
#> 
#> $verificacoes
#> $verificacoes$dispersao_performance
#> # Overdispersion test (using simulated residuals)
#> 
#>  dispersion ratio = 1.119
#>           p-value = 0.544
#> 
#> No overdispersion detected.
#> 
#> $verificacoes$dispersao_DHARMa
#> 
#>  DHARMa nonparametric dispersion test via sd of residuals fitted vs.
#>  simulated
#> 
#> data:  simulationOutput
#> dispersion = 1.1187, p-value = 0.57
#> alternative hypothesis: two.sided
#> 
#> 
#> $verificacoes$zeros_DHARMa
#> 
#>  DHARMa zero-inflation test via comparison to expected zeros with
#>  simulation under H0 = fitted model
#> 
#> data:  simulationOutput
#> ratioObsSim = NaN, p-value = 1
#> alternative hypothesis: two.sided
#> 
#> 
#> $verificacoes$outliers_DHARMa
#> 
#>  DHARMa bootstrapped outlier test
#> 
#> data:  simulados
#> outliers at both margin(s) = 0, observations = 54, p-value = 1
#> alternative hypothesis: two.sided
#>  percent confidence interval:
#>  0.00000000 0.05555556
#> sample estimates:
#> outlier frequency (expected: 0.0124074074074074 ) 
#>                                                 0 
#> 
#> 
#> 
#> $residuos_simulados
#> Object of Class DHARMa with simulated residuals based on 200 simulations with refit = FALSE . See ?DHARMa::simulateResiduals for help. 
#>  
#> Scaled residual values: 0.09458086 0.1838352 0.8175745 0.09251899 0.9424979 0.7416369 0.7326899 0.05623526 0.935 0.2112094 0.4140939 0.7450086 0.2186472 0.08482746 0.235497 0.9 0.7779527 0.9102739 0.8979136 0.3317839 ...
#> $modelo
#> 
#> Call:  MASS::glm.nb(formula = breaks ~ wool * tension, data = warpbreaks, 
#>     init.theta = 12.08216462, link = log)
#> 
#> Coefficients:
#>    (Intercept)           woolB        tensionM        tensionH  woolB:tensionM  
#>         3.7967         -0.4566         -0.6187         -0.5958          0.6382  
#> woolB:tensionH  
#>         0.1884  
#> 
#> Degrees of Freedom: 53 Total (i.e. Null);  48 Residual
#> Null Deviance:       86.76 
#> Residual Deviance: 53.51     AIC: 405.1
#> 
#> $simulations
#> [1] 200
#> 
#> $seed
#> [1] 123
#> 
#> attr(,"class")
#> [1] "myfuns_diagnostico_contagem" "list"                       

if (requireNamespace("glmmTMB", quietly = TRUE)) {
mzi <- glmmTMB::glmmTMB(breaks ~ tension, ziformula = ~1,
family = glmmTMB::nbinom2, data = warpbreaks)
diagnostico_contagem(mzi, simulations = 200)
}
#> Model has no observed zeros in the response variable.
#> $descritivo
#>    n    media variancia zeros proporcao_zeros
#> 1 54 28.14815  174.2041     0               0
#> 
#> $familia
#> $familia$family
#> [1] "nbinom2"
#> 
#> $familia$link
#> [1] "log"
#> 
#> 
#> $dispersao_pearson
#>   razao_pearson gl   p_valor
#> 1      1.131928 49 0.2441491
#> 
#> $verificacoes
#> $verificacoes$dispersao_performance
#> # Overdispersion test (using simulated residuals)
#> 
#>  dispersion ratio = 1.154
#>           p-value = 0.424
#> 
#> No overdispersion detected.
#> 
#> $verificacoes$dispersao_DHARMa
#> 
#>  DHARMa nonparametric dispersion test via sd of residuals fitted vs.
#>  simulated
#> 
#> data:  simulationOutput
#> dispersion = 1.166, p-value = 0.41
#> alternative hypothesis: two.sided
#> 
#> 
#> $verificacoes$zeros_DHARMa
#> 
#>  DHARMa zero-inflation test via comparison to expected zeros with
#>  simulation under H0 = fitted model
#> 
#> data:  simulationOutput
#> ratioObsSim = NaN, p-value = 1
#> alternative hypothesis: two.sided
#> 
#> 
#> $verificacoes$outliers_DHARMa
#> 
#>  DHARMa bootstrapped outlier test
#> 
#> data:  simulados
#> outliers at both margin(s) = 0, observations = 54, p-value = 1
#> alternative hypothesis: two.sided
#>  percent confidence interval:
#>  0.00000000 0.05555556
#> sample estimates:
#> outlier frequency (expected: 0.0124074074074074 ) 
#>                                                 0 
#> 
#> 
#> 
#> $residuos_simulados
#> Object of Class DHARMa with simulated residuals based on 200 simulations with refit = FALSE . See ?DHARMa::simulateResiduals for help. 
#>  
#> Scaled residual values: 0.2392531 0.3394593 0.9072283 0.2009539 0.985 0.9136505 0.8622852 0.2377605 0.99 0.1861703 0.3564839 0.6615937 0.179419 0.0417788 0.226123 0.7895534 0.6664713 0.8485763 0.8685677 0.4565313 ...
#> $modelo
#> Formula:          breaks ~ tension
#> Zero inflation:          ~1
#> Data: warpbreaks
#>       AIC       BIC    logLik -2*log(L)  df.resid 
#>  412.0219  421.9668 -201.0109  402.0219        49 
#> 
#> Number of obs: 54
#> 
#> Dispersion parameter for nbinom2 family (): 9.16 
#> 
#> Fixed Effects:
#> 
#> Conditional model:
#> (Intercept)     tensionM     tensionH  
#>      3.5943      -0.3213      -0.5185  
#> 
#> Zero-inflation model:
#> (Intercept)  
#>      -21.98  
#> 
#> $simulations
#> [1] 200
#> 
#> $seed
#> [1] 123
#> 
#> attr(,"class")
#> [1] "myfuns_diagnostico_contagem" "list"                       
```
