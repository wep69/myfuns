## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(collapse = TRUE, comment = "#>")
library(myfuns)


## -----------------------------------------------------------------------------
set.seed(2026)
dados <- expand.grid(
  bloco = factor(1:5),
  dose = c(0, 50, 100, 150, 200)
)
dados$produtividade <- with(
  dados,
  40 + 0.20 * dose - 0.00065 * dose^2 +
    rep(c(-2, 1, 0, 2, -1), each = 5) +
    rnorm(nrow(dados), 0, 2)
)


## -----------------------------------------------------------------------------
auditar_delineamento(
  dados,
  tratamento = dose,
  bloco = bloco,
  resposta = produtividade
)


## -----------------------------------------------------------------------------
resumo_agri(dados, produtividade, dose)


## -----------------------------------------------------------------------------
rp <- reg_poly(dados, produtividade, dose, degree = 1:2)
rp


## -----------------------------------------------------------------------------
ponto_critico(rp)


## ----fig.width=6, fig.height=4------------------------------------------------
plot_reg(rp)


## -----------------------------------------------------------------------------
dq <- transform(dados, dose_f = factor(dose))
m <- lm(produtividade ~ bloco + dose_f, data = dq)

anova_agri(m)
cmp <- comparar_emmeans(m, ~ dose_f, method = "pairwise", adjust = "tukey")
plot_emmeans(cmp, data = dq, x = dose_f, y = produtividade)


## -----------------------------------------------------------------------------
emm <- emmeans::emmeans(m, ~ dose_f)
cp <- contraste_poly(emm, scores = c(0, 50, 100, 150, 200), degree = 2)
cp

