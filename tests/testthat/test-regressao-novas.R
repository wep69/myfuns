test_that("reg_poly ajusta graus solicitados sem seleção automática", {
  set.seed(1)
  d <- expand.grid(rep = factor(1:4), dose = c(0, 50, 100, 150, 200))
  d$y <- 20 + 0.2 * d$dose - 0.0007 * d$dose^2 + rnorm(nrow(d), 0, 2)
  r <- reg_poly(d, y, dose, degree = 1:2)
  expect_s3_class(r, "myfuns_reg_poly")
  expect_equal(names(r$modelos), c("grau1", "grau2"))
  expect_true(is.data.frame(r$comparacao))
})

test_that("ponto_critico encontra vértice de quadrática", {
  d <- data.frame(x = rep(c(0, 1, 2, 3, 4), each = 3))
  d$y <- 10 + 4 * d$x - d$x^2
  r <- reg_poly(d, y, x, degree = 2)
  pc <- ponto_critico(r)
  expect_equal(pc$x_critico, 2, tolerance = 1e-7)
  expect_equal(pc$classificacao, "máximo")
})

test_that("plot_reg retorna ggplot", {
  d <- data.frame(x = rep(0:4, each = 3))
  d$y <- 5 + d$x + rnorm(nrow(d), sd = 0.1)
  r <- reg_poly(d, y, x, degree = 1)
  expect_s3_class(plot_reg(r), "ggplot")
})
