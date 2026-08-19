# Delineamento, resumo descritivo e ANOVA

## Dados didáticos

``` r

dados_dbc <- expand.grid(
  bloco = factor(1:5),
  tratamento = factor(c("Controle", "A", "B", "C"))
)
dados_dbc$produtividade <- 42 +
  c(0, 5, 9, 7)[dados_dbc$tratamento] +
  rep(c(-2, 1, 0, 2, -1), each = 4) +
  rnorm(nrow(dados_dbc), 0, 2)
```

## `auditar_delineamento()`

A auditoria é realizada antes do ajuste. Ela descreve níveis,
combinações previstas, células ausentes, respostas ausentes,
balanceamento e, quando `unidade` é informada, duplicação do
identificador da unidade experimental.

### Exemplo 1: DBC completo

``` r

aud1 <- auditar_delineamento(
  dados_dbc,
  tratamento = tratamento,
  bloco = bloco,
  resposta = produtividade
)
aud1
#> Auditoria do delineamento
#> -------------------------
#>                         item valor
#>                  Observações    20
#>    Variáveis do delineamento     2
#>             Células ausentes     0
#>  Linhas em chaves duplicadas     0
#>           Respostas ausentes     0
#>                   Balanceado     1
#> 
#> Mensagens:
#> * Duplicação de unidade experimental não foi avaliada porque `unidade` não foi informada.
```

### Exemplo 2: tratamento ausente em um bloco

``` r

dados_incompletos <- dados_dbc[-7, ]
aud2 <- auditar_delineamento(
  dados_incompletos,
  tratamento = tratamento,
  bloco = bloco,
  resposta = produtividade
)
aud2$celulas_ausentes
#>    bloco tratamento n
#> 20     2          A 0
```

### Exemplo 3: fatorial com fatores adicionais

``` r

fat <- expand.grid(
  bloco = factor(1:4),
  salinidade = factor(c("0.5", "3.0")),
  plantas = factor(c("1", "2")),
  porta_enxerto = factor(c("A", "B", "C"))
)
fat$y <- rnorm(nrow(fat), 20, 3)

auditar_delineamento(
  fat,
  tratamento = salinidade,
  bloco = bloco,
  fatores = c(plantas, porta_enxerto),
  resposta = y
)
#> Auditoria do delineamento
#> -------------------------
#>                         item valor
#>                  Observações    48
#>    Variáveis do delineamento     4
#>             Células ausentes     0
#>  Linhas em chaves duplicadas     0
#>           Respostas ausentes     0
#>                   Balanceado     1
#> 
#> Mensagens:
#> * Duplicação de unidade experimental não foi avaliada porque `unidade` não foi informada.
```

## `resumo_agri()`

A função retorna `n`, total de linhas, ausências, média, desvio-padrão,
erro-padrão, intervalo de confiança, mediana, quartis, extremos e CV
descritivo.

### Exemplo 1: por tratamento

``` r

resumo_agri(dados_dbc, produtividade, tratamento)
#>   tratamento n n_total n_ausentes    media       dp erro_padrao ic_inferior
#> 1          A 5       5          0 40.74736 1.632921   0.7302646    38.71982
#> 2          B 5       5          0 46.54689 2.010447   0.8990991    44.05059
#> 3          C 5       5          0 51.42640 2.666976   1.1927078    48.11491
#> 4   Controle 5       5          0 47.13150 1.461571   0.6536343    45.31672
#>   ic_superior  mediana       q1       q3   minimo   maximo       cv
#> 1    42.77490 41.05242 40.95976 41.52971 37.96782 42.22711 4.007428
#> 2    49.04319 46.18357 45.53913 48.54837 43.90624 48.55713 4.319186
#> 3    54.73789 51.23282 50.43513 51.37949 48.39056 55.69400 5.186005
#> 4    48.94628 47.27848 46.83050 48.04118 44.84062 48.66672 3.101049
```

### Exemplo 2: por tratamento e bloco

``` r

resumo_agri(dados_dbc, produtividade, tratamento, bloco)
#>    tratamento bloco n n_total n_ausentes    media dp erro_padrao ic_inferior
#> 1           A     1 1       1          0 37.96782 NA          NA          NA
#> 2           A     2 1       1          0 41.52971 NA          NA          NA
#> 3           A     3 1       1          0 40.95976 NA          NA          NA
#> 4           A     4 1       1          0 42.22711 NA          NA          NA
#> 5           A     5 1       1          0 41.05242 NA          NA          NA
#> 6           B     1 1       1          0 46.18357 NA          NA          NA
#> 7           B     2 1       1          0 45.53913 NA          NA          NA
#> 8           B     3 1       1          0 48.55713 NA          NA          NA
#> 9           B     4 1       1          0 48.54837 NA          NA          NA
#> 10          B     5 1       1          0 43.90624 NA          NA          NA
#> 11          C     1 1       1          0 55.69400 NA          NA          NA
#> 12          C     2 1       1          0 51.23282 NA          NA          NA
#> 13          C     3 1       1          0 50.43513 NA          NA          NA
#> 14          C     4 1       1          0 48.39056 NA          NA          NA
#> 15          C     5 1       1          0 51.37949 NA          NA          NA
#> 16   Controle     1 1       1          0 48.04118 NA          NA          NA
#> 17   Controle     2 1       1          0 44.84062 NA          NA          NA
#> 18   Controle     3 1       1          0 47.27848 NA          NA          NA
#> 19   Controle     4 1       1          0 46.83050 NA          NA          NA
#> 20   Controle     5 1       1          0 48.66672 NA          NA          NA
#>    ic_superior  mediana       q1       q3   minimo   maximo cv
#> 1           NA 37.96782 37.96782 37.96782 37.96782 37.96782 NA
#> 2           NA 41.52971 41.52971 41.52971 41.52971 41.52971 NA
#> 3           NA 40.95976 40.95976 40.95976 40.95976 40.95976 NA
#> 4           NA 42.22711 42.22711 42.22711 42.22711 42.22711 NA
#> 5           NA 41.05242 41.05242 41.05242 41.05242 41.05242 NA
#> 6           NA 46.18357 46.18357 46.18357 46.18357 46.18357 NA
#> 7           NA 45.53913 45.53913 45.53913 45.53913 45.53913 NA
#> 8           NA 48.55713 48.55713 48.55713 48.55713 48.55713 NA
#> 9           NA 48.54837 48.54837 48.54837 48.54837 48.54837 NA
#> 10          NA 43.90624 43.90624 43.90624 43.90624 43.90624 NA
#> 11          NA 55.69400 55.69400 55.69400 55.69400 55.69400 NA
#> 12          NA 51.23282 51.23282 51.23282 51.23282 51.23282 NA
#> 13          NA 50.43513 50.43513 50.43513 50.43513 50.43513 NA
#> 14          NA 48.39056 48.39056 48.39056 48.39056 48.39056 NA
#> 15          NA 51.37949 51.37949 51.37949 51.37949 51.37949 NA
#> 16          NA 48.04118 48.04118 48.04118 48.04118 48.04118 NA
#> 17          NA 44.84062 44.84062 44.84062 44.84062 44.84062 NA
#> 18          NA 47.27848 47.27848 47.27848 47.27848 47.27848 NA
#> 19          NA 46.83050 46.83050 46.83050 46.83050 46.83050 NA
#> 20          NA 48.66672 48.66672 48.66672 48.66672 48.66672 NA
```

### Exemplo 3: intervalo de 90%

``` r

resumo_agri(dados_dbc, produtividade, tratamento, conf.level = 0.90)
#>   tratamento n n_total n_ausentes    media       dp erro_padrao ic_inferior
#> 1          A 5       5          0 40.74736 1.632921   0.7302646    39.19055
#> 2          B 5       5          0 46.54689 2.010447   0.8990991    44.63015
#> 3          C 5       5          0 51.42640 2.666976   1.1927078    48.88373
#> 4   Controle 5       5          0 47.13150 1.461571   0.6536343    45.73805
#>   ic_superior  mediana       q1       q3   minimo   maximo       cv
#> 1    42.30417 41.05242 40.95976 41.52971 37.96782 42.22711 4.007428
#> 2    48.46363 46.18357 45.53913 48.54837 43.90624 48.55713 4.319186
#> 3    53.96907 51.23282 50.43513 51.37949 48.39056 55.69400 5.186005
#> 4    48.52495 47.27848 46.83050 48.04118 44.84062 48.66672 3.101049
```

O CV é apresentado como descrição e não como critério universal de
qualidade. Respostas de contagem, proporções ou médias próximas de zero
requerem interpretação específica.

## `anova_agri()`

``` r

mod_dbc <- lm(produtividade ~ tratamento + bloco, data = dados_dbc)
```

### Exemplo 1: DBC

``` r

anova_agri(mod_dbc)
#> ANOVA agrícola
#> --------------
#> Analysis of Variance Table
#> 
#> Response: produtividade
#>            Df  Sum Sq Mean Sq F value    Pr(>F)    
#> tratamento  3 288.789  96.263 19.1572 7.189e-05 ***
#> bloco       4   3.530   0.883  0.1756    0.9467    
#> Residuals  12  60.299   5.025                      
#> ---
#> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
#> 
#> CV experimental: 4.82%
#> 
#> Tamanho de efeito:
#> # Effect Size for ANOVA (Type I)
#> 
#> Parameter  | Eta2 (partial) |       95% CI
#> ------------------------------------------
#> tratamento |           0.83 | [0.60, 1.00]
#> bloco      |           0.06 | [0.00, 1.00]
#> 
#> - One-sided CIs: upper bound fixed at [1.00].
```

### Exemplo 2: interação fatorial

``` r

m2 <- lm(Sepal.Length ~ Species * cut(Petal.Width, 2), data = iris)
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
#> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
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
```

### Exemplo 3: sem CV

``` r

anova_agri(
  lm(weight ~ group, data = PlantGrowth),
  cv = FALSE,
  effect_size = "eta2_partial"
)
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
#> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
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

Quando `effectsize` está instalado, os tamanhos de efeito são obtidos
diretamente por esse pacote. Na ausência dele, `myfuns` consegue
calcular eta² parcial básico para modelos `lm`, mas sem intervalo de
confiança.

## Fluxo recomendado

``` r

auditar_delineamento(dados_dbc, tratamento, bloco, resposta = produtividade)
#> Auditoria do delineamento
#> -------------------------
#>                         item valor
#>                  Observações    20
#>    Variáveis do delineamento     2
#>             Células ausentes     0
#>  Linhas em chaves duplicadas     0
#>           Respostas ausentes     0
#>                   Balanceado     1
#> 
#> Mensagens:
#> * Duplicação de unidade experimental não foi avaliada porque `unidade` não foi informada.
resumo_agri(dados_dbc, produtividade, tratamento)
#>   tratamento n n_total n_ausentes    media       dp erro_padrao ic_inferior
#> 1          A 5       5          0 40.74736 1.632921   0.7302646    38.71982
#> 2          B 5       5          0 46.54689 2.010447   0.8990991    44.05059
#> 3          C 5       5          0 51.42640 2.666976   1.1927078    48.11491
#> 4   Controle 5       5          0 47.13150 1.461571   0.6536343    45.31672
#>   ic_superior  mediana       q1       q3   minimo   maximo       cv
#> 1    42.77490 41.05242 40.95976 41.52971 37.96782 42.22711 4.007428
#> 2    49.04319 46.18357 45.53913 48.54837 43.90624 48.55713 4.319186
#> 3    54.73789 51.23282 50.43513 51.37949 48.39056 55.69400 5.186005
#> 4    48.94628 47.27848 46.83050 48.04118 44.84062 48.66672 3.101049
anova_agri(mod_dbc)
#> ANOVA agrícola
#> --------------
#> Analysis of Variance Table
#> 
#> Response: produtividade
#>            Df  Sum Sq Mean Sq F value    Pr(>F)    
#> tratamento  3 288.789  96.263 19.1572 7.189e-05 ***
#> bloco       4   3.530   0.883  0.1756    0.9467    
#> Residuals  12  60.299   5.025                      
#> ---
#> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
#> 
#> CV experimental: 4.82%
#> 
#> Tamanho de efeito:
#> # Effect Size for ANOVA (Type I)
#> 
#> Parameter  | Eta2 (partial) |       95% CI
#> ------------------------------------------
#> tratamento |           0.83 | [0.60, 1.00]
#> bloco      |           0.06 | [0.00, 1.00]
#> 
#> - One-sided CIs: upper bound fixed at [1.00].
```

A sequência reduz o risco de interpretar uma ANOVA sem ter verificado
previamente a estrutura do banco.
