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

# --- Tests for plot_reg_equation() ---

test_that("plot_reg_equation retorna ggplot", {
  d <- data.frame(x = rep(0:4, each = 3))
  d$y <- 5 + d$x + rnorm(nrow(d), sd = 0.1)
  r <- reg_poly(d, y, x, degree = 1)
  p <- plot_reg_equation(r, equation_text = "y = 5 + 1.0 * x")
  expect_s3_class(p, "ggplot")
})

test_that("plot_reg_equation para quando equation_text esta faltando", {
  d <- data.frame(x = rep(0:4, each = 3))
  d$y <- 5 + d$x + rnorm(nrow(d), sd = 0.1)
  r <- reg_poly(d, y, x, degree = 1)
  expect_error(plot_reg_equation(r), "equation_text.*obrigat")
})

test_that("plot_reg_equation para quando equation_text nao e character(1)", {
  d <- data.frame(x = rep(0:4, each = 3))
  d$y <- 5 + d$x + rnorm(nrow(d), sd = 0.1)
  r <- reg_poly(d, y, x, degree = 1)

  # numeric
  expect_error(plot_reg_equation(r, equation_text = 123), "caractere")
  # character with length > 1
  expect_error(plot_reg_equation(r, equation_text = c("a", "b")), "caractere")
  # empty string
  expect_error(plot_reg_equation(r, equation_text = ""), "caractere")
  # NA
  expect_error(plot_reg_equation(r, equation_text = NA_character_), "caractere")
  # NULL
  expect_error(plot_reg_equation(r, equation_text = NULL), "equation_text.*obrigat")
})

test_that("plot_reg_equation inclui equation_text no subtitulo do grafico", {
  d <- data.frame(x = rep(0:4, each = 3))
  d$y <- 5 + d$x + rnorm(nrow(d), sd = 0.1)
  r <- reg_poly(d, y, x, degree = 1)
  eq <- "y = 5 + 1.0 * dose"
  p <- plot_reg_equation(r, equation_text = eq)
  built <- ggplot2::ggplot_build(p)
  # The subtitle should appear in the plot's labs
  expect_equal(built$plot$labels$subtitle, eq)
})

test_that("plot_reg_equation aceita argumentos extras de plot_reg", {
  d <- data.frame(x = rep(0:4, each = 3))
  d$y <- 5 + d$x + rnorm(nrow(d), sd = 0.1)
  r <- reg_poly(d, y, x, degree = 1)
  # Pass show_raw = FALSE and equation = TRUE (should still work)
  p <- plot_reg_equation(r, equation_text = "test eq", show_raw = FALSE)
  expect_s3_class(p, "ggplot")
})
