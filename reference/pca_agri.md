# Análise de componentes principais para dados agronômicos

Padroniza um fluxo de PCA baseado em \[stats::prcomp()\], preservando o
objeto original e organizando escores, cargas, autovalores, variância
explicada, variância acumulada e contribuição das variáveis. Valores
ausentes não são removidos silenciosamente.

## Usage

``` r
pca_agri(data,
                       vars,
                       scale = TRUE,
                       center = TRUE,
                       group = NULL,
                       ncomp = NULL)
```

## Arguments

- data:

  \`data.frame\`.

- vars:

  Variáveis numéricas, como \`c(var1, var2, var3)\` ou vetor de nomes.

- scale:

  Padronizar pelas unidades de desvio-padrão?

- center:

  Centralizar as variáveis?

- group:

  Variável opcional de agrupamento para gráficos.

- ncomp:

  Número de componentes a reportar. \`NULL\` usa todos os disponíveis.

## Value

Objeto da classe \`myfuns_pca\`.

## Details

Consulte as vinhetas do pacote para interpretação, limitações e fluxos
integrados. A função não deve substituir a avaliação do delineamento e
da pergunta científica.

## Examples

``` r
pca1 <- pca_agri(iris,
vars = c(Sepal.Length, Sepal.Width, Petal.Length, Petal.Width), group = Species)
pca1
#> Análise de componentes principais
#> ---------------------------------
#> Variáveis: Sepal.Length, Sepal.Width, Petal.Length, Petal.Width
#> Centralização: sim; padronização: sim
#> 
#>  componente  autovalor   variancia variancia_percentual variancia_acumulada
#>         PC1 2.91849782 0.729624454           72.9624454           0.7296245
#>         PC2 0.91403047 0.228507618           22.8507618           0.9581321
#>         PC3 0.14675688 0.036689219            3.6689219           0.9948213
#>         PC4 0.02071484 0.005178709            0.5178709           1.0000000
#>  acumulada_percentual
#>              72.96245
#>              95.81321
#>              99.48213
#>             100.00000

pca_agri(iris,
vars = c(Sepal.Length, Sepal.Width, Petal.Length, Petal.Width), scale = FALSE)
#> Análise de componentes principais
#> ---------------------------------
#> Variáveis: Sepal.Length, Sepal.Width, Petal.Length, Petal.Width
#> Centralização: sim; padronização: não
#> 
#>  componente  autovalor   variancia variancia_percentual variancia_acumulada
#>         PC1 4.22824171 0.924618723           92.4618723           0.9246187
#>         PC2 0.24267075 0.053066483            5.3066483           0.9776852
#>         PC3 0.07820950 0.017102610            1.7102610           0.9947878
#>         PC4 0.02383509 0.005212184            0.5212184           1.0000000
#>  acumulada_percentual
#>              92.46187
#>              97.76852
#>              99.47878
#>             100.00000

pca_agri(iris,
vars = c(Sepal.Length, Sepal.Width, Petal.Length, Petal.Width), ncomp = 3)
#> Análise de componentes principais
#> ---------------------------------
#> Variáveis: Sepal.Length, Sepal.Width, Petal.Length, Petal.Width
#> Centralização: sim; padronização: sim
#> 
#>  componente autovalor  variancia variancia_percentual variancia_acumulada
#>         PC1 2.9184978 0.72962445            72.962445           0.7296245
#>         PC2 0.9140305 0.22850762            22.850762           0.9581321
#>         PC3 0.1467569 0.03668922             3.668922           0.9948213
#>  acumulada_percentual
#>              72.96245
#>              95.81321
#>              99.48213
```
