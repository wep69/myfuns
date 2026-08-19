# Comparar modelos candidatos por múltiplos critérios

Calcula AIC, AICc, BIC, log-verossimilhança, R² quando definido e RMSE.
Antes da comparação, registra alertas sobre resposta, conjunto de
observações e, para modelos lineares mistos, uso de REML com efeitos
fixos diferentes.

## Usage

``` r
comparar_modelos(...,
                               metrics = c("AIC", "AICc", "BIC", "logLik", "R2", "RMSE"),
                               rank_by = NULL,
                               check_comparability = TRUE)
```

## Arguments

- ...:

  Modelos nomeados ou uma única lista de modelos.

- metrics:

  Métricas desejadas dentre \`AIC\`, \`AICc\`, \`BIC\`, \`logLik\`,
  \`R2\` e \`RMSE\`.

- rank_by:

  Métrica opcional usada apenas para ordenar a tabela.

- check_comparability:

  Realizar verificações de comparabilidade?

## Value

Lista da classe \`myfuns_comparacao_modelos\`.

## Details

Consulte as vinhetas do pacote para interpretação, limitações e fluxos
integrados. A função não deve substituir a avaliação do delineamento e
da pergunta científica.

## Examples

``` r
d <- data.frame(x = rep(0:4, each = 4))
d$y <- 2 + 1.5 * d$x - 0.2 * d$x^2 + stats::rnorm(nrow(d))
ml <- stats::lm(y ~ x, d)
mq <- stats::lm(y ~ x + I(x^2), d)
comparar_modelos(linear = ml, quadratico = mq)
#> Comparação de modelos
#> --------------------
#>      modelo classe  n      AIC     AICc      BIC    logLik        R2     RMSE
#>      linear     lm 20 69.84692 71.34692 72.83412 -31.92346 0.4834089 1.193911
#>  quadratico     lm 20 67.22624 69.89290 71.20917 -29.61312 0.5899753 1.063662
#> 
#> Alertas de comparabilidade:
#> * Nenhum problema básico de comparabilidade foi identificado; ainda assim, a legitimidade científica da comparação deve ser verificada.

mp <- stats::glm(breaks ~ wool * tension, poisson, data = warpbreaks)
if (requireNamespace("MASS", quietly = TRUE)) {
mnb <- MASS::glm.nb(breaks ~ wool * tension, data = warpbreaks)
comparar_modelos(poisson = mp, negbin = mnb)
}
#> Comparação de modelos
#> --------------------
#>   modelo classe  n      AIC     AICc      BIC    logLik        R2    RMSE
#>  poisson    glm 54 468.9692 470.7564 480.9031 -228.4846 0.8848576 10.3146
#>   negbin negbin 54 405.1248 407.5596 419.0477 -195.5624 0.5751318 10.3146
#> 
#> Alertas de comparabilidade:
#> * Nenhum problema básico de comparabilidade foi identificado; ainda assim, a legitimidade científica da comparação deve ser verificada.

comparar_modelos(linear = ml, quadratico = mq, metrics = c("AICc", "BIC", "RMSE"), rank_by = "AICc")
#> Comparação de modelos
#> --------------------
#>      modelo classe  n     AICc      BIC     RMSE
#>  quadratico     lm 20 69.89290 71.20917 1.063662
#>      linear     lm 20 71.34692 72.83412 1.193911
#> 
#> Alertas de comparabilidade:
#> * Nenhum problema básico de comparabilidade foi identificado; ainda assim, a legitimidade científica da comparação deve ser verificada.
```
