## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(collapse = TRUE, comment = "#>")
set.seed(2026)
library(myfuns)


## -----------------------------------------------------------------------------
dados_dbc <- expand.grid(
  bloco = factor(1:5),
  tratamento = factor(c("Controle", "A", "B", "C"))
)
dados_dbc$produtividade <- 42 +
  c(0, 5, 9, 7)[dados_dbc$tratamento] +
  rep(c(-2, 1, 0, 2, -1), each = 4) +
  rnorm(nrow(dados_dbc), 0, 2)


## -----------------------------------------------------------------------------
aud1 <- auditar_delineamento(
  dados_dbc,
  tratamento = tratamento,
  bloco = bloco,
  resposta = produtividade
)
aud1


## -----------------------------------------------------------------------------
dados_incompletos <- dados_dbc[-7, ]
aud2 <- auditar_delineamento(
  dados_incompletos,
  tratamento = tratamento,
  bloco = bloco,
  resposta = produtividade
)
aud2$celulas_ausentes


## -----------------------------------------------------------------------------
fat <- expand.grid(
  bloco = factor(1:4),
  salinidade = factor(c("0.5", "3.0")),
  plantas = factor(c("1", "2")),
  porta_enxerto = factor(c("A", "B", "C"))
)
fat$y <- rnorm(nrow(fat), 20, 3)

auditar_delineamento(
  fat,
  tratamento = salinidade,
  bloco = bloco,
  fatores = c(plantas, porta_enxerto),
  resposta = y
)


## -----------------------------------------------------------------------------
resumo_agri(dados_dbc, produtividade, tratamento)


## -----------------------------------------------------------------------------
resumo_agri(dados_dbc, produtividade, tratamento, bloco)


## -----------------------------------------------------------------------------
resumo_agri(dados_dbc, produtividade, tratamento, conf.level = 0.90)


## -----------------------------------------------------------------------------
mod_dbc <- lm(produtividade ~ tratamento + bloco, data = dados_dbc)


## -----------------------------------------------------------------------------
anova_agri(mod_dbc)


## -----------------------------------------------------------------------------
m2 <- lm(Sepal.Length ~ Species * cut(Petal.Width, 2), data = iris)
anova_agri(m2, effect_size = "eta2")


## -----------------------------------------------------------------------------
anova_agri(
  lm(weight ~ group, data = PlantGrowth),
  cv = FALSE,
  effect_size = "eta2_partial"
)


## -----------------------------------------------------------------------------
auditar_delineamento(dados_dbc, tratamento, bloco, resposta = produtividade)
resumo_agri(dados_dbc, produtividade, tratamento)
anova_agri(mod_dbc)

