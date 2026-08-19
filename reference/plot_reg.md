# Gráfico para regressão de fator quantitativo

Mostra observações, médias por nível, curva ajustada, intervalo de
confiança e equação do modelo principal de um objeto produzido por
\[reg_poly()\].

## Usage

``` r
plot_reg(object,
                       data = NULL,
                       x = NULL,
                       y = NULL,
                       show_raw = TRUE,
                       show_means = TRUE,
                       interval = "confidence",
                       equation = TRUE,
                       theme = theme_nogrid())
```

## Arguments

- object:

  Resultado de \[reg_poly()\].

- data:

  Banco opcional. Por padrão, usa o banco armazenado em \`object\`.

- x:

  Variável quantitativa. Por padrão, usa a registrada em \`object\`.

- y:

  Variável resposta. Por padrão, usa a registrada em \`object\`.

- show_raw:

  Mostrar observações individuais?

- show_means:

  Mostrar médias observadas por nível?

- interval:

  Mostrar intervalo de confiança?

- equation:

  Adicionar equação e R² ao gráfico?

- theme:

  Tema \`ggplot2\`.

## Value

Objeto \`ggplot\`.

## Details

Consulte as vinhetas do pacote para interpretação, limitações e fluxos
integrados. A função não deve substituir a avaliação do delineamento e
da pergunta científica.

## Examples

``` r
d <- data.frame(dose = rep(c(0, 50, 100, 150), each = 4))
d$y <- 12 + 0.2 * d$dose - 0.0008 * d$dose^2 + stats::rnorm(nrow(d))
rp <- reg_poly(d, y, dose, degree = 2)
plot_reg(rp)


plot_reg(rp, data = d, x = dose, y = y, show_raw = TRUE, show_means = TRUE)


plot_reg(rp, equation = FALSE)
```
