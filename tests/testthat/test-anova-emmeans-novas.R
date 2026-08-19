test_that("anova_agri organiza a ANOVA", {
  m <- lm(weight ~ group, data = PlantGrowth)
  a <- anova_agri(m, effect_size = "none")
  expect_s3_class(a, "myfuns_anova")
  expect_true(inherits(a$anova, "anova"))
  expect_true(is.numeric(a$cv))
})

test_that("funções emmeans operam em fluxo simples", {
  m1 <- lm(Sepal.Length ~ Species, data = iris)
  m2 <- lm(Petal.Length ~ Species, data = iris)
  el <- emmeans_lista(list(a = m1, b = m2), ~ Species)
  expect_length(el, 2)
  expect_true(all(vapply(el, inherits, logical(1), what = "emmGrid")))

  ce <- comparar_emmeans(m1, ~ Species, method = "pairwise")
  expect_s3_class(ce, "myfuns_emmeans")
  expect_true(is.data.frame(ce$estimativas))
})

test_that("contraste_poly usa os escores reais", {
  d <- data.frame(dose = factor(rep(c(0, 25, 100, 200), each = 4)), y = seq_len(16))
  m <- lm(y ~ dose, data = d)
  em <- emmeans::emmeans(m, ~ dose)
  cp <- contraste_poly(em, scores = c(0, 25, 100, 200), degree = 2)
  expect_s3_class(cp, "myfuns_contraste_poly")
  expect_false(cp$igualmente_espacados)
  expect_equal(cp$grau, 2)
  expect_equal(cp$metodo, "opoly")
})
