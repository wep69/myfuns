test_that("diagnostico_modelo funciona com lm", {
  m <- lm(mpg ~ wt + hp, data = mtcars)
  d <- diagnostico_modelo(m, plot = FALSE, verbose = FALSE)
  expect_true(is.list(d))
  expect_true(all(c("informacoes", "verificacoes", "residuos_simulados", "grafico") %in% names(d)))
})

test_that("comparar_modelos retorna métricas e alertas", {
  m1 <- lm(mpg ~ wt, data = mtcars)
  m2 <- lm(mpg ~ wt + hp, data = mtcars)
  c <- comparar_modelos(m1 = m1, m2 = m2, rank_by = "AICc")
  expect_s3_class(c, "myfuns_comparacao_modelos")
  expect_equal(nrow(c$tabela), 2)
  expect_true(all(c("AIC", "AICc", "BIC", "R2", "RMSE") %in% names(c$tabela)))
})

test_that("diagnostico_contagem produz descrição básica", {
  m <- glm(breaks ~ wool * tension, poisson, data = warpbreaks)
  d <- diagnostico_contagem(m, simulations = 100)
  expect_true(is.data.frame(d$descritivo))
  expect_true("proporcao_zeros" %in% names(d$descritivo))
})

test_that("resumo_misto funciona quando lme4 está instalado", {
  skip_if_not_installed("lme4")
  m <- lme4::lmer(Reaction ~ Days + (1 | Subject), data = lme4::sleepstudy)
  r <- resumo_misto(m)
  expect_s3_class(r, "myfuns_resumo_misto")
  expect_true(is.data.frame(r$efeitos_fixos))
})

test_that("diagnostico_modelo returns grafico=NULL when plot=FALSE", {
  m1 <- stats::lm(weight ~ group, data = PlantGrowth)
  resultado <- diagnostico_modelo(m1, plot = FALSE, verbose = FALSE)
  expect_null(resultado$grafico)
})

test_that("diagnostico_modelo returns non-NULL grafico when plot=TRUE", {
  skip_if_not_installed("performance")
  m1 <- stats::lm(weight ~ group, data = PlantGrowth)
  resultado <- diagnostico_modelo(m1, plot = TRUE, verbose = FALSE)
  expect_false(is.null(resultado$grafico))
})
