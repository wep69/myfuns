# ANOVA organizada para experimentação agrícola

Reúne tabela de análise de variância, coeficiente de variação, tamanho
de efeito e informações básicas do modelo em um único objeto. A função
não usa significância estatística para tomar decisões automáticas sobre
tratamentos.

## Usage

``` r
anova_agri(model,
           effect_size = c("eta2_partial", "eta2",
                           "omega2_partial", "omega2",
                           "none"),
           cv = TRUE,
           conf.level = 0.95)
```

## Arguments

- model:

  Modelo ajustado, tipicamente \`lm\` ou \`aov\`.

- effect_size:

  Tamanho de efeito. Opções: \`"eta2_partial"\`, \`"eta2"\`,
  \`"omega2_partial"\`, \`"omega2"\` ou \`"none"\`.

- cv:

  Calcular coeficiente de variação experimental? Padrão \`TRUE\`.

- conf.level:

  Nível de confiança usado por \`effectsize\`, quando disponível.

## Value

Lista da classe \`myfuns_anova\`.

## Details

Consulte as vinhetas do pacote para interpretação, limitações e fluxos
integrados. A função não deve substituir a avaliação do delineamento e
da pergunta científica.

## Examples

``` r
m1 <- stats::lm(weight ~ group, data = PlantGrowth)
anova_agri(m1)
#> For one-way between subjects designs, partial eta squared is equivalent
#>   to eta squared. Returning eta squared.
#> ANOVA agrícola
#> --------------
#> Analysis of Variance Table
#> 
#> Response: weight
#>           Df  Sum Sq Mean Sq F value  Pr(>F)  
#> group      2  3.7663  1.8832  4.8461 0.01591 *
#> Residuals 27 10.4921  0.3886                  
#> ---
#> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#> 
#> CV experimental: 12.29%
#> 
#> Tamanho de efeito:
#> # Effect Size for ANOVA
#> 
#> Parameter | Eta2 |       95% CI
#> -------------------------------
#> group     | 0.26 | [0.04, 1.00]
#> 
#> - One-sided CIs: upper bound fixed at [1.00].

m2 <- stats::lm(Sepal.Length ~ Species * cut(Petal.Width, 2), data = iris)
anova_agri(m2, effect_size = "eta2")
#> ANOVA agrícola
#> --------------
#> Analysis of Variance Table
#> 
#> Response: Sepal.Length
#>                      Df Sum Sq Mean Sq F value    Pr(>F)    
#> Species               2 63.212 31.6061 130.708 < 2.2e-16 ***
#> cut(Petal.Width, 2)   1  3.652  3.6524  15.104 0.0001539 ***
#> Residuals           146 35.304  0.2418                      
#> ---
#> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#> 
#> CV experimental: 8.42%
#> 
#> Tamanho de efeito:
#> # Effect Size for ANOVA (Type I)
#> 
#> Parameter           | Eta2 |       95% CI
#> -----------------------------------------
#> Species             | 0.62 | [0.54, 1.00]
#> cut(Petal.Width, 2) | 0.04 | [0.00, 1.00]
#> 
#> - One-sided CIs: upper bound fixed at [1.00].

anova_agri(m1, cv = FALSE, effect_size = "eta2_partial")
#> For one-way between subjects designs, partial eta squared is equivalent
#>   to eta squared. Returning eta squared.
#> ANOVA agrícola
#> --------------
#> Analysis of Variance Table
#> 
#> Response: weight
#>           Df  Sum Sq Mean Sq F value  Pr(>F)  
#> group      2  3.7663  1.8832  4.8461 0.01591 *
#> Residuals 27 10.4921  0.3886                  
#> ---
#> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#> 
#> Tamanho de efeito:
#> # Effect Size for ANOVA
#> 
#> Parameter | Eta2 |       95% CI
#> -------------------------------
#> group     | 0.26 | [0.04, 1.00]
#> 
#> - One-sided CIs: upper bound fixed at [1.00].
```
