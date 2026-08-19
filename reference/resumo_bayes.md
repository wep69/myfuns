# Resumo posterior para modelos bayesianos

Organiza estimativas posteriores, intervalos de credibilidade e
diagnósticos de MCMC por meio de \`bayestestR::describe_posterior()\`.
ROPE só é incluída quando o pesquisador informa explicitamente seus
limites.

## Usage

``` r
resumo_bayes(model,
                           ci = 0.95,
                           ci_method = "hdi",
                           centrality = "median",
                           diagnostics = TRUE,
                           rope = NULL,
                           exponentiate = FALSE)
```

## Arguments

- model:

  Modelo bayesiano ou objeto de amostras posteriores aceito por
  \`bayestestR::describe_posterior()\`.

- ci:

  Probabilidade do intervalo de credibilidade.

- ci_method:

  Método do intervalo, como \`"hdi"\` ou \`"eti"\`.

- centrality:

  Medida de tendência central, como \`"median"\` ou \`"mean"\`.

- diagnostics:

  Incluir ESS, Rhat e MCSE quando disponíveis?

- rope:

  Limites \`c(inferior, superior)\` da região de equivalência prática.
  Se \`NULL\`, nenhuma ROPE é calculada.

- exponentiate:

  Exponenciar estimativas e limites compatíveis, útil para modelos com
  link log ou logit quando essa transformação possui sentido.

## Value

\`data.frame\` com o resumo posterior.

## Details

Consulte as vinhetas do pacote para interpretação, limitações e fluxos
integrados. A função não deve substituir a avaliação do delineamento e
da pergunta científica.

## Examples

``` r
if (requireNamespace("bayestestR", quietly = TRUE)) {
set.seed(1)
resumo_bayes(stats::rnorm(2000, 0.4, 0.2), diagnostics = FALSE)
}
#>   Parameter    Median   CI       CI_low   CI_high     pd
#> 1 Posterior 0.3929993 0.95 -0.007247484 0.8099383 0.9705

if (requireNamespace("bayestestR", quietly = TRUE)) {
set.seed(2)
resumo_bayes(stats::rnorm(2000, 0.05, 0.15), diagnostics = FALSE, rope = c(-0.1, 0.1))
}
#>   Parameter     Median   CI     CI_low   CI_high     pd ROPE_CI ROPE_low
#> 1 Posterior 0.05697265 0.95 -0.2182363 0.3647974 0.6445    0.95     -0.1
#>   ROPE_high ROPE_Percentage
#> 1       0.1       0.4889474

if (FALSE) { # \dontrun{
fit <- brms::brm(mpg ~ wt, data = mtcars, family = gaussian(), seed = 123)
resumo_bayes(fit, ci = 0.95, ci_method = "hdi")
} # }
```
