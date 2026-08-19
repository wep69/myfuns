# Calcular pontos críticos de uma regressão polinomial

Obtém raízes da primeira derivada de modelos polinomiais brutos
produzidos por \`lm()\` ou \[reg_poly()\]. Para regressões quadráticas,
também calcula um intervalo aproximado para a posição do ponto pelo
método delta.

## Usage

``` r
ponto_critico(model, range = NULL, conf.level = 0.95, classify = TRUE)
```

## Arguments

- model:

  Objeto \`lm\` ou \`myfuns_reg_poly\`.

- range:

  Intervalo experimental \`c(min, max)\`. Se \`NULL\`, é inferido do
  banco usado no ajuste.

- conf.level:

  Nível de confiança do intervalo aproximado para o ponto quadrático.

- classify:

  Classificar o ponto como máximo, mínimo ou indeterminado?

## Value

\`data.frame\` com posição, resposta prevista, classificação, posição
relativa ao domínio e, quando disponível, intervalo de confiança.

## Details

Consulte as vinhetas do pacote para interpretação, limitações e fluxos
integrados. A função não deve substituir a avaliação do delineamento e
da pergunta científica.

## Examples

``` r
d <- data.frame(dose = rep(c(0, 50, 100, 150, 200), each = 3))
d$y <- 20 + 0.25 * d$dose - 0.0008 * d$dose^2 + rep(c(-1, 0, 1), 5)
mq <- stats::lm(y ~ dose + I(dose^2), data = d)
ponto_critico(mq, range = range(d$dose))
#>   x_critico y_predito classificacao dentro_intervalo ic_inferior ic_superior
#> 1    156.25  39.53125        máximo             TRUE    147.4771    165.0229

ponto_critico(mq, range = c(0, 100))
#> Warning: Há ponto crítico fora do domínio informado; sua interpretação implica extrapolação.
#>   x_critico y_predito classificacao dentro_intervalo ic_inferior ic_superior
#> 1    156.25  39.53125        máximo            FALSE    147.4771    165.0229

rp <- reg_poly(d, y, dose, degree = 2)
ponto_critico(rp)
#>   x_critico y_predito classificacao dentro_intervalo ic_inferior ic_superior
#> 1    156.25  39.53125        máximo             TRUE    147.4771    165.0229
```
