test_that("anovaCV retorna estrutura esperada", {
  d <- data.frame(g = factor(rep(letters[1:3], each = 4)), y = 1:12)
  m <- lm(y ~ g, data = d)
  out <- anovaCV(m)
  expect_named(out, c("Anova", "CV"))
  expect_true(is.numeric(out$CV))
})

test_that("contrast_lista processa lista de emmGrid", {
  d <- data.frame(g = factor(rep(letters[1:3], each = 4)), y = 1:12)
  m <- lm(y ~ g, data = d)
  em <- emmeans::emmeans(m, ~ g)
  out <- contrast_lista(list(a = em), method = "pairwise")
  expect_length(out, 1)
  expect_s4_class(out[[1]], "emmGrid")
})

test_that("which e validado", {
  expect_error(contrast_lista(list(1), which = 2), "fora dos limites")
})
