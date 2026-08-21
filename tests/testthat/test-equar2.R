test_that("equar2 seleciona media, linear e quadratica", {
  medias <- data.frame(x = 0:4, y = c(1, 2, 3, 4, 5))

  ns <- data.frame(
    contrast = c("linear", "quadratic"),
    p.value = c(0.20, 0.30)
  )
  expect_match(equar2(medias, ns), "bar\\(y\\)")

  lin <- data.frame(
    contrast = c("linear", "quadratic"),
    p.value = c(0.001, 0.30)
  )
  det_lin <- equar2(medias, lin, details = TRUE)
  expect_identical(det_lin$degree, "linear")
  expect_s3_class(det_lin$model, "lm")

  quad <- data.frame(
    contrast = c("linear", "quadratic"),
    p.value = c(0.20, 0.001)
  )
  det_quad <- equar2(medias, quad, details = TRUE)
  expect_identical(det_quad$degree, "quadratic")
  expect_length(coef(det_quad$model), 3)
})

test_that("equar2 valida contrastes ambiguos", {
  medias <- data.frame(x = 0:3, y = 1:4)
  amb <- data.frame(
    contrast = c("linear", "linear", "quadratic"),
    p.value = c(0.01, 0.02, 0.5)
  )
  expect_error(equar2(medias, amb), "mais de um contraste")
})

test_that("equar2 avisa sobre espacamento desigual", {
  medias <- data.frame(x = c(0, 10, 50, 100), y = c(1, 2, 3, 4))
  cr <- data.frame(contrast = c("linear", "quadratic"), p.value = c(0.01, 0.2))
  expect_warning(equar2(medias, cr), "não são igualmente espaçados")
})


test_that("equar2 reconhece contraste_poly com espaçamento desigual", {
  d <- data.frame(dose = factor(rep(c(0, 25, 100, 200), each = 4)), y = seq_len(16))
  m <- lm(y ~ dose, data = d)
  em <- emmeans::emmeans(m, ~ dose)
  cp <- contraste_poly(em, scores = c(0, 25, 100, 200), degree = 2)
  medias <- aggregate(y ~ dose, data = d, FUN = mean)
  medias$dose <- as.numeric(as.character(medias$dose))
  expect_no_warning(equar2(medias, cp))
})

test_that("plot_reg_equation converte plotmath de equar2 para texto simples", {
  medias <- data.frame(x = 0:4, y = c(10, 20, 25, 28, 30))
  lin <- data.frame(contrast = c("linear", "quadratic"), p.value = c(0.001, 0.30))
  eq <- equar2(medias, lin)

  d <- data.frame(x = rep(0:4, each = 3))
  d$y <- 10 + 4 * d$x + rnorm(nrow(d), sd = 0.5)
  r <- reg_poly(d, y, x, degree = 1)

  p <- plot_reg_equation(r, equation_text = eq)
  sub <- ggplot2::ggplot_build(p)$plot$labels$subtitle
  # plotmath foi removido: hat() nao deve aparecer
  expect_false(grepl("hat\\(", sub))
  # os valores numericos devem permanecer
  expect_true(grepl("\\d+\\.\\d+", sub))
})
