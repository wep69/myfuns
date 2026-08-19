# Diagnóstico orientado pela classe do modelo

Reúne verificações coerentes com modelos lineares, GLM, modelos mistos
de \`lme4\` e modelos \`glmmTMB\`. Quando o pacote \`performance\` está
disponível, utiliza suas verificações especializadas. Nenhum teste
isolado é usado para aceitar, rejeitar ou substituir automaticamente o
modelo.

## Usage

``` r
diagnostico_modelo(model,
                                 simulations = 1000,
                                 seed = 123,
                                 plot = TRUE,
                                 verbose = TRUE)
```

## Arguments

- model:

  Modelo ajustado.

- simulations:

  Número de simulações para diagnósticos que as utilizem.

- seed:

  Semente de reprodutibilidade.

- plot:

  Produzir objeto de diagnóstico visual com
  \`performance::check_model()\`?

- verbose:

  Imprimir síntese em português?

## Value

Lista da classe \`myfuns_diagnostico\`.

## Details

Consulte as vinhetas do pacote para interpretação, limitações e fluxos
integrados. A função não deve substituir a avaliação do delineamento e
da pergunta científica.

## Examples

``` r
m1 <- stats::lm(weight ~ group, data = PlantGrowth)
diagnostico_modelo(m1, plot = FALSE)
#> Not enough model terms in the conditional part of the model to check for
#>   multicollinearity.
#> Diagnóstico do modelo
#> ---------------------
#> Classe: lm
#> Resposta: weight
#> n: 30
#> Interprete as verificações em conjunto com o delineamento, os resíduos e a finalidade científica.
#> $informacoes
#> $informacoes$classe
#> [1] "lm"
#> 
#> $informacoes$formula
#> [1] "weight ~ group"
#> 
#> $informacoes$resposta
#> [1] "weight"
#> 
#> $informacoes$n
#> [1] 30
#> 
#> $informacoes$familia
#> [1] "gaussian"
#> 
#> $informacoes$link
#> [1] "identity"
#> 
#> 
#> $verificacoes
#> $verificacoes$residuos
#>    n        media       dp minimo maximo
#> 1 30 2.370247e-17 0.601495 -1.071  1.369
#> 
#> $verificacoes$shapiro
#> 
#>  Shapiro-Wilk normality test
#> 
#> data:  r
#> W = 0.96607, p-value = 0.4379
#> 
#> 
#> $verificacoes$heterocedasticidade
#> OK: Error variance appears to be homoscedastic (p = 0.083).
#> 
#> $verificacoes$influencia
#> OK: No outliers detected.
#> - Based on the following method and threshold: cook (0.5).
#> - For variable: (Whole model)
#> 
#> 
#> $verificacoes$desempenho
#> # Indices of model performance
#> 
#> AIC  | AICc |  BIC |    R2 | R2 (adj.) |  RMSE | Sigma
#> ------------------------------------------------------
#> 61.6 | 63.2 | 67.2 | 0.264 |     0.210 | 0.591 | 0.623
#> 
#> 
#> $residuos_simulados
#> NULL
#> 
#> $grafico
#> NULL
#> 
#> $simulations
#> [1] 1000
#> 
#> $seed
#> [1] 123
#> 
#> attr(,"class")
#> [1] "myfuns_diagnostico" "list"              

mp <- stats::glm(breaks ~ wool * tension, poisson, data = warpbreaks)
diagnostico_modelo(mp, simulations = 200, plot = FALSE)
#> Model has no observed zeros in the response variable.
#> Diagnóstico do modelo
#> ---------------------
#> Classe: glm/lm
#> Resposta: breaks
#> n: 54
#> Interprete as verificações em conjunto com o delineamento, os resíduos e a finalidade científica.
#> $informacoes
#> $informacoes$classe
#> [1] "glm" "lm" 
#> 
#> $informacoes$formula
#> [1] "breaks ~ wool * tension"
#> 
#> $informacoes$resposta
#> [1] "breaks"
#> 
#> $informacoes$n
#> [1] 54
#> 
#> $informacoes$familia
#> [1] "poisson"
#> 
#> $informacoes$link
#> [1] "log"
#> 
#> 
#> $verificacoes
#> $verificacoes$dispersao
#> # Overdispersion test
#> 
#>        dispersion ratio =   3.764
#>   Pearson's Chi-Squared = 180.666
#>                 p-value = < 0.001
#> 
#> Overdispersion detected.
#> 
#> $verificacoes$desempenho
#> # Indices of model performance
#> 
#> AIC   |  AICc |   BIC | Nagelkerke's R2 |   RMSE | Sigma | Score_log | Score_spherical
#> --------------------------------------------------------------------------------------
#> 469.0 | 470.8 | 480.9 |           0.885 | 10.315 |     1 |    -4.231 |           0.103
#> 
#> $verificacoes$uniformidade_DHARMa
#> 
#>  Asymptotic one-sample Kolmogorov-Smirnov test
#> 
#> data:  simulationOutput$scaledResiduals
#> D = 0.1992, p-value = 0.02754
#> alternative hypothesis: two-sided
#> 
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
#> $verificacoes$outliers_DHARMa
#> 
#>  DHARMa bootstrapped outlier test
#> 
#> data:  residuos_simulados
#> outliers at both margin(s) = 7, observations = 54, p-value < 2.2e-16
#> alternative hypothesis: two.sided
#>  percent confidence interval:
#>  0.00000000 0.05555556
#> sample estimates:
#> outlier frequency (expected: 0.0127777777777778 ) 
#>                                         0.1296296 
#> 
#> 
#> 
#> $residuos_simulados
#> Object of Class DHARMa with simulated residuals based on 200 simulations with refit = FALSE . See ?DHARMa::simulateResiduals for help. 
#>  
#> Scaled residual values: 0 0.006242665 0.9128284 0 1 0.878696 0.808071 0 0.9971399 0.1417534 0.2037337 0.862446 0.03952264 0.005 0.1156171 0.9813769 0.9056927 0.9838312 0.978263 0.2337218 ...
#> $grafico
#> NULL
#> 
#> $simulations
#> [1] 200
#> 
#> $seed
#> [1] 123
#> 
#> attr(,"class")
#> [1] "myfuns_diagnostico" "list"              

if (requireNamespace("glmmTMB", quietly = TRUE)) {
mnb <- glmmTMB::glmmTMB(breaks ~ wool * tension, family = glmmTMB::nbinom2, data = warpbreaks)
diagnostico_modelo(mnb, simulations = 200, plot = FALSE)
}
#> Model has no observed zeros in the response variable.
#> Diagnóstico do modelo
#> ---------------------
#> Classe: glmmTMB
#> Resposta: breaks
#> n: 54
#> Interprete as verificações em conjunto com o delineamento, os resíduos e a finalidade científica.
#> $informacoes
#> $informacoes$classe
#> [1] "glmmTMB"
#> 
#> $informacoes$formula
#> [1] "breaks ~ wool * tension"
#> 
#> $informacoes$resposta
#> [1] "breaks"
#> 
#> $informacoes$n
#> [1] 54
#> 
#> $informacoes$familia
#> [1] "nbinom2"
#> 
#> $informacoes$link
#> [1] "log"
#> 
#> 
#> $verificacoes
#> $verificacoes$dispersao
#> # Overdispersion test (using simulated residuals)
#> 
#>  dispersion ratio = 1.105
#>           p-value =  0.56
#> 
#> No overdispersion detected.
#> 
#> $verificacoes$convergencia
#> [1] TRUE
#> 
#> $verificacoes$singularidade
#> [1] FALSE
#> 
#> $verificacoes$desempenho
#> $erro
#> [1] "`r2()` does not support models of class `glmmTMB` without random effects\n  and from nbinom2-family with log-link-function."
#> 
#> attr(,"class")
#> [1] "myfuns_erro"
#> 
#> $verificacoes$uniformidade_DHARMa
#> 
#>  Exact one-sample Kolmogorov-Smirnov test
#> 
#> data:  simulationOutput$scaledResiduals
#> D = 0.065304, p-value = 0.9638
#> alternative hypothesis: two-sided
#> 
#> 
#> $verificacoes$dispersao_DHARMa
#> 
#>  DHARMa nonparametric dispersion test via sd of residuals fitted vs.
#>  simulated
#> 
#> data:  simulationOutput
#> dispersion = 1.093, p-value = 0.59
#> alternative hypothesis: two.sided
#> 
#> 
#> $verificacoes$outliers_DHARMa
#> 
#>  DHARMa bootstrapped outlier test
#> 
#> data:  residuos_simulados
#> outliers at both margin(s) = 0, observations = 54, p-value = 0.98
#> alternative hypothesis: two.sided
#>  percent confidence interval:
#>  0.00000000 0.03703704
#> sample estimates:
#> outlier frequency (expected: 0.0135185185185185 ) 
#>                                                 0 
#> 
#> 
#> 
#> $residuos_simulados
#> Object of Class DHARMa with simulated residuals based on 200 simulations with refit = FALSE . See ?DHARMa::simulateResiduals for help. 
#>  
#> Scaled residual values: 0.0846874 0.2040449 0.7857264 0.1097771 0.9623203 0.7526604 0.6864443 0.07958086 0.9460958 0.3007455 0.3562911 0.6862449 0.2304266 0.03134493 0.2605292 0.8826612 0.7390939 0.9083362 0.8743236 0.4297239 ...
#> $grafico
#> NULL
#> 
#> $simulations
#> [1] 200
#> 
#> $seed
#> [1] 123
#> 
#> attr(,"class")
#> [1] "myfuns_diagnostico" "list"              
```
