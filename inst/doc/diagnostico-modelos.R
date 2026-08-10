## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(collapse = TRUE, comment = "#>")
library(myfuns)


## -----------------------------------------------------------------------------
m1 <- lm(weight ~ group, data = PlantGrowth)
d1 <- diagnostico_modelo(m1, plot = FALSE)
d1$informacoes


## -----------------------------------------------------------------------------
mp <- glm(breaks ~ wool * tension, poisson, data = warpbreaks)
d2 <- diagnostico_modelo(mp, simulations = 300, plot = FALSE)
d2$verificacoes


## ----eval=FALSE---------------------------------------------------------------
# mnb <- glmmTMB::glmmTMB(
#   breaks ~ wool * tension,
#   family = glmmTMB::nbinom2,
#   data = warpbreaks
# )
# diagnostico_modelo(mnb, simulations = 1000, plot = TRUE)


## ----eval=FALSE---------------------------------------------------------------
# mri <- lme4::lmer(Reaction ~ Days + (1 | Subject), data = lme4::sleepstudy)
# resumo_misto(mri)


## ----eval=FALSE---------------------------------------------------------------
# mrs <- lme4::lmer(Reaction ~ Days + (Days | Subject), data = lme4::sleepstudy)
# resumo_misto(mrs)


## ----eval=FALSE---------------------------------------------------------------
# mg <- lme4::glmer(
#   cbind(incidence, size - incidence) ~ period + (1 | herd),
#   family = binomial,
#   data = lme4::cbpp
# )
# resumo_misto(mg, exponentiate = TRUE)


## -----------------------------------------------------------------------------
dc1 <- diagnostico_contagem(mp, simulations = 300)
dc1$descritivo
dc1$dispersao_pearson


## ----eval=FALSE---------------------------------------------------------------
# mnb2 <- MASS::glm.nb(breaks ~ wool * tension, data = warpbreaks)
# diagnostico_contagem(mnb2, simulations = 500)


## ----eval=FALSE---------------------------------------------------------------
# mzi <- glmmTMB::glmmTMB(
#   breaks ~ tension,
#   ziformula = ~ 1,
#   family = glmmTMB::nbinom2,
#   data = warpbreaks
# )
# diagnostico_contagem(mzi, simulations = 1000)


## -----------------------------------------------------------------------------
set.seed(10)
d <- data.frame(x = rep(0:4, each = 5))
d$y <- 4 + 1.2 * d$x - 0.15 * d$x^2 + rnorm(nrow(d))
ml <- lm(y ~ x, data = d)
mq <- lm(y ~ x + I(x^2), data = d)


## -----------------------------------------------------------------------------
comparar_modelos(linear = ml, quadratico = mq)


## ----eval=FALSE---------------------------------------------------------------
# mp2 <- glm(breaks ~ wool * tension, poisson, data = warpbreaks)
# mnb3 <- MASS::glm.nb(breaks ~ wool * tension, data = warpbreaks)
# comparar_modelos(poisson = mp2, negbin = mnb3)


## -----------------------------------------------------------------------------
comparar_modelos(
  linear = ml,
  quadratico = mq,
  metrics = c("AICc", "BIC", "RMSE"),
  rank_by = "AICc"
)

