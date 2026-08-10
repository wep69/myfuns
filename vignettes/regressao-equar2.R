## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(collapse = TRUE, comment = "#>")
set.seed(2026)
library(myfuns)


## -----------------------------------------------------------------------------
dados <- expand.grid(
  bloco = factor(1:5),
  dose = c(0, 50, 100, 150, 200)
)
dados$y <- with(
  dados,
  25 + 0.18 * dose - 0.00060 * dose^2 +
    rep(c(-1.5, 0, 1.2, -0.8, 0.5), each = 5) +
    rnorm(nrow(dados), 0, 1.8)
)


## -----------------------------------------------------------------------------
rp1 <- reg_poly(dados, y, dose, degree = 1:2)
rp1


## -----------------------------------------------------------------------------
rp2 <- reg_poly(dados, y, dose, degree = 2, compare = FALSE)
rp2$coeficientes$grau2


## -----------------------------------------------------------------------------
rp3 <- reg_poly(dados, y, dose, degree = 1:3)
rp3$comparacao
rp3$falta_ajuste


## -----------------------------------------------------------------------------
mq <- lm(y ~ dose + I(dose^2), data = dados)
ponto_critico(mq, range = range(dados$dose))


## -----------------------------------------------------------------------------
ponto_critico(mq, range = c(0, 100))


## -----------------------------------------------------------------------------
ponto_critico(rp2)


## ----fig.width=6, fig.height=4------------------------------------------------
plot_reg(rp2)


## ----fig.width=6, fig.height=4------------------------------------------------
plot_reg(rp2, data = dados, x = dose, y = y, show_raw = TRUE, show_means = TRUE)


## ----fig.width=6, fig.height=4------------------------------------------------
plot_reg(rp2, equation = FALSE)


## -----------------------------------------------------------------------------
dados$dose_f <- factor(dados$dose)
mod_f <- lm(y ~ bloco + dose_f, data = dados)
emm <- emmeans::emmeans(mod_f, ~ dose_f)
cp <- contraste_poly(emm, scores = c(0, 50, 100, 150, 200), degree = 2)
medias <- aggregate(y ~ dose, data = dados, FUN = mean)


## -----------------------------------------------------------------------------
equar2(medias, cp)


## -----------------------------------------------------------------------------
eq2 <- equar2(medias, cp, details = TRUE)
eq2$equation
eq2$p_values


## -----------------------------------------------------------------------------
equar2(medias, cp, r2_percent = FALSE, digits = c(2, 4, 5, 3))

