# Bayes, exportação em lote e produtividade

## `resumo_bayes()`

A função é uma camada sobre
[`bayestestR::describe_posterior()`](https://easystats.github.io/bayestestR/reference/describe_posterior.html).
Ela mantém o foco em estimativa posterior, intervalo de credibilidade e
diagnósticos. ROPE só é calculada quando seus limites são explicitamente
informados.

### Exemplo 1: amostras posteriores simples

``` r

if (requireNamespace("bayestestR", quietly = TRUE)) {
  set.seed(1)
  resumo_bayes(rnorm(3000, 0.4, 0.2), diagnostics = FALSE)
}
#>   Parameter    Median   CI       CI_low   CI_high   pd
#> 1 Posterior 0.3954941 0.95 -0.007247484 0.8055477 0.97
```

### Exemplo 2: ROPE definida pelo pesquisador

``` r

if (requireNamespace("bayestestR", quietly = TRUE)) {
  set.seed(2)
  resumo_bayes(
    rnorm(3000, 0.05, 0.15),
    diagnostics = FALSE,
    rope = c(-0.10, 0.10)
  )
}
#>   Parameter     Median   CI     CI_low   CI_high        pd ROPE_CI ROPE_low
#> 1 Posterior 0.05826118 0.95 -0.2225682 0.3616966 0.6466667    0.95     -0.1
#>   ROPE_high ROPE_Percentage
#> 1       0.1       0.4785965
```

### Exemplo 3: modelo `brms`

``` r

fit <- brms::brm(
  mpg ~ wt,
  data = mtcars,
  family = gaussian(),
  chains = 4,
  iter = 2000,
  seed = 123
)
resumo_bayes(fit, ci = 0.95, ci_method = "hdi")
```

## `export_figuras()`

``` r

p1 <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) +
  ggplot2::geom_point() + theme_nogrid()
p2 <- ggplot2::ggplot(iris, ggplot2::aes(Species, Sepal.Length)) +
  ggplot2::geom_boxplot() + theme_nogrid()
```

### Exemplo 1: PNG

``` r

export_figuras(
  list(fig_mtcars = p1, fig_iris = p2),
  dir = "figuras",
  formats = "png"
)
```

### Exemplo 2: TIFF de alta resolução

``` r

export_figuras(
  list(fig_mtcars = p1, fig_iris = p2),
  dir = "figuras_tiff",
  formats = "tiff",
  dpi = 600
)
```

### Exemplo 3: transparência e SVG

``` r

export_figuras(
  list(fig_mtcars = p1 + trans, fig_iris = p2 + trans),
  dir = "figuras_transparentes",
  formats = c("png", "svg"),
  bg = "transparent"
)
```

## `read_clipboard_table()`

A função usa a área de transferência nativa do Windows.

### Exemplo 1

``` r

dados <- read_clipboard_table()
```

### Exemplo 2

``` r

dados <- read_clipboard_table(dec = ",", na.strings = c("", "NA"))
```

### Exemplo 3

``` r

dados <- read_clipboard_table(header = FALSE)
```

[`read_excel()`](https://wep69.github.io/myfuns/reference/clipboard.md)
permanece como alias histórico para não quebrar scripts antigos.

## `write_clipboard_table()`

### Exemplo 1

``` r

write_clipboard_table(head(iris))
```

### Exemplo 2

``` r

write_clipboard_table(aggregate(Sepal.Length ~ Species, iris, mean))
```

### Exemplo 3

``` r

write_clipboard_table(head(mtcars), row.names = TRUE, col.names = TRUE)
```

[`write_excel()`](https://wep69.github.io/myfuns/reference/clipboard.md)
também permanece como alias histórico.
