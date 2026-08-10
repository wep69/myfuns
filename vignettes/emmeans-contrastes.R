## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(collapse = TRUE, comment = "#>")
library(myfuns)


## -----------------------------------------------------------------------------
dados <- data.frame(
  trat = factor(rep(c("A", "B", "C", "D"), each = 5)),
  bloco = factor(rep(1:5, times = 4)),
  altura = c(30,31,29,32,30, 35,34,36,35,34, 40,39,41,42,40, 38,37,39,38,40),
  massa = c(10,11,10,9,10, 12,13,12,12,11, 16,15,17,16,16, 14,15,14,13,14)
)
m_altura <- lm(altura ~ bloco + trat, data = dados)
m_massa <- lm(massa ~ bloco + trat, data = dados)
mods <- list(altura = m_altura, massa = m_massa)


## -----------------------------------------------------------------------------
lista_emm <- emmeans_lista(mods, ~ trat)
lista_emm


## -----------------------------------------------------------------------------
emmeans_lista(mods, ~ trat, which = 2)


## -----------------------------------------------------------------------------
mp <- glm(breaks ~ wool * tension, poisson, data = warpbreaks)
emmeans_lista(list(quebras = mp), ~ tension | wool, type = "response")


## -----------------------------------------------------------------------------
contrast_lista(lista_emm, method = "pairwise", adjust = "tukey")


## -----------------------------------------------------------------------------
contrast_lista(lista_emm, method = "trt.vs.ctrl", ref = 1, adjust = "dunnettx")


## -----------------------------------------------------------------------------
coef <- list("A vs demais" = c(-3, 1, 1, 1))
contrast_lista(lista_emm, method = coef, adjust = "none")


## ----eval=FALSE---------------------------------------------------------------
# cld_lista(lista_emm, adjust = "tukey")


## ----eval=FALSE---------------------------------------------------------------
# cld_lista(lista_emm, which = 1, adjust = "tukey")


## ----eval=FALSE---------------------------------------------------------------
# cld_lista(lista_emm, adjust = "tukey", delta = 1.0)


## -----------------------------------------------------------------------------
cmp1 <- comparar_emmeans(m_altura, ~ trat, method = "pairwise", adjust = "tukey")
cmp1


## -----------------------------------------------------------------------------
cmp2 <- comparar_emmeans(
  m_altura,
  ~ trat,
  method = "trt.vs.ctrl",
  adjust = "dunnettx",
  ref = 1
)
cmp2$contrastes


## -----------------------------------------------------------------------------
m_int <- lm(breaks ~ wool * tension, data = warpbreaks)
cmp3 <- comparar_emmeans(m_int, ~ tension | wool, method = "pairwise", adjust = "tukey")
cmp3$estimativas


## ----fig.width=6, fig.height=4------------------------------------------------
plot_emmeans(cmp1)


## ----fig.width=6, fig.height=4------------------------------------------------
plot_emmeans(cmp1, data = dados, x = trat, y = altura)


## ----fig.width=6, fig.height=4------------------------------------------------
plot_emmeans(cmp3, data = warpbreaks, x = tension, y = breaks)


## -----------------------------------------------------------------------------
d1 <- data.frame(dose = factor(rep(c(0, 50, 100, 150), each = 4)), y = 1:16)
m1 <- lm(y ~ dose, data = d1)
em1 <- emmeans::emmeans(m1, ~ dose)
contraste_poly(em1, scores = c(0, 50, 100, 150))


## -----------------------------------------------------------------------------
d2 <- data.frame(dose = factor(rep(c(0, 25, 100, 200), each = 4)), y = 1:16)
m2 <- lm(y ~ dose, data = d2)
em2 <- emmeans::emmeans(m2, ~ dose)
cp2 <- contraste_poly(em2, scores = c(0, 25, 100, 200))
cp2$scores
cp2$igualmente_espacados


## -----------------------------------------------------------------------------
contraste_poly(em1, scores = c(0, 50, 100, 150), degree = 2)

