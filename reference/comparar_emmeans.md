# Organizar médias marginais estimadas e contrastes

Gera EMMs, intervalos de confiança e contrastes em um objeto único,
mantendo o \`emmGrid\` original disponível para inferências posteriores.
Opcionalmente, pode calcular compact letter display.

## Usage

``` r
comparar_emmeans(model,
                               specs,
                               method = "pairwise",
                               adjust = "tukey",
                               type = "response",
                               cld = FALSE,
                               delta = 0,
                               ...)
```

## Arguments

- model:

  Modelo aceito por \[emmeans::emmeans()\].

- specs:

  Especificação das médias marginais.

- method:

  Família de contrastes repassada a \[emmeans::contrast()\].

- adjust:

  Método de ajuste de multiplicidade.

- type:

  Escala das estimativas, como \`"response"\` ou \`"link"\`.

- cld:

  Calcular letras de comparação? Padrão \`FALSE\`.

- delta:

  Margem de equivalência usada apenas quando \`cld = TRUE\` e suportada
  pelo método de \`emmeans\`.

- ...:

  Argumentos adicionais. Argumentos como \`ref\` são repassados aos
  contrastes; argumentos próprios de \`emmeans()\` devem ser informados
  antes da criação do objeto quando necessário.

## Value

Lista da classe \`myfuns_emmeans\`.

## Details

Consulte as vinhetas do pacote para interpretação, limitações e fluxos
integrados. A função não deve substituir a avaliação do delineamento e
da pergunta científica.

## Examples

``` r
m <- stats::lm(weight ~ group, data = PlantGrowth)
comparar_emmeans(m, ~ group, method = "pairwise", adjust = "tukey")
#> Médias marginais estimadas
#> --------------------------
#>  group emmean        SE df lower.CL upper.CL
#>  ctrl   5.032 0.1971284 27 4.627526 5.436474
#>  trt1   4.661 0.1971284 27 4.256526 5.065474
#>  trt2   5.526 0.1971284 27 5.121526 5.930474
#> 
#> Confidence level used: 0.95 
#> 
#> Contrastes:
#>  contrast    estimate        SE df   lower.CL   upper.CL t.ratio p.value
#>  ctrl - trt1    0.371 0.2787816 27 -0.3202161  1.0622161   1.331  0.3909
#>  ctrl - trt2   -0.494 0.2787816 27 -1.1852161  0.1972161  -1.772  0.1980
#>  trt1 - trt2   -0.865 0.2787816 27 -1.5562161 -0.1737839  -3.103  0.0120
#> 
#> Confidence level used: 0.95 
#> Conf-level adjustment: tukey method for comparing a family of 3 estimates 
#> P value adjustment: tukey method for comparing a family of 3 estimates 

comparar_emmeans(m, ~ group, method = "trt.vs.ctrl", adjust = "dunnettx", ref = 1)
#> Médias marginais estimadas
#> --------------------------
#>  group emmean        SE df lower.CL upper.CL
#>  ctrl   5.032 0.1971284 27 4.627526 5.436474
#>  trt1   4.661 0.1971284 27 4.256526 5.065474
#>  trt2   5.526 0.1971284 27 5.121526 5.930474
#> 
#> Confidence level used: 0.95 
#> 
#> Contrastes:
#>  contrast    estimate        SE df   lower.CL  upper.CL t.ratio p.value
#>  trt1 - ctrl   -0.371 0.2787816 27 -1.0252967 0.2832967  -1.331  0.3296
#>  trt2 - ctrl    0.494 0.2787816 27 -0.1602967 1.1482967   1.772  0.1582
#> 
#> Confidence level used: 0.95 
#> Conf-level adjustment: dunnettx method for 2 estimates 
#> P value adjustment: dunnettx method for 2 tests 

m2 <- stats::lm(breaks ~ wool * tension, data = warpbreaks)
comparar_emmeans(m2, ~ tension | wool, method = "pairwise", adjust = "tukey")
#> Médias marginais estimadas
#> --------------------------
#> wool = A:
#>  tension   emmean       SE df lower.CL upper.CL
#>  L       44.55556 3.646761 48 37.22325 51.88786
#>  M       24.00000 3.646761 48 16.66769 31.33231
#>  H       24.55556 3.646761 48 17.22325 31.88786
#> 
#> wool = B:
#>  tension   emmean       SE df lower.CL upper.CL
#>  L       28.22222 3.646761 48 20.88992 35.55453
#>  M       28.77778 3.646761 48 21.44547 36.11008
#>  H       18.77778 3.646761 48 11.44547 26.11008
#> 
#> Confidence level used: 0.95 
#> 
#> Contrastes:
#> wool = A:
#>  contrast  estimate       SE df   lower.CL upper.CL t.ratio p.value
#>  L - M    20.555556 5.157299 48   8.082691 33.02842   3.986  0.0007
#>  L - H    20.000000 5.157299 48   7.527135 32.47286   3.878  0.0009
#>  M - H    -0.555556 5.157299 48 -13.028420 11.91731  -0.108  0.9936
#> 
#> wool = B:
#>  contrast  estimate       SE df   lower.CL upper.CL t.ratio p.value
#>  L - M    -0.555556 5.157299 48 -13.028420 11.91731  -0.108  0.9936
#>  L - H     9.444444 5.157299 48  -3.028420 21.91731   1.831  0.1704
#>  M - H    10.000000 5.157299 48  -2.472865 22.47286   1.939  0.1389
#> 
#> Confidence level used: 0.95 
#> Conf-level adjustment: tukey method for comparing a family of 3 estimates 
#> P value adjustment: tukey method for comparing a family of 3 estimates 
```
