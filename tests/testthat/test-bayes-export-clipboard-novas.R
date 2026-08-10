test_that("resumo_bayes resume amostras quando bayestestR está instalado", {
  skip_if_not_installed("bayestestR")
  set.seed(1)
  r <- resumo_bayes(rnorm(1000, 0.3, 0.2), diagnostics = FALSE)
  expect_true(is.data.frame(r))
  expect_equal(attr(r, "escala"), "linear_do_modelo")
})

test_that("export_figuras exporta lote simples", {
  p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) + ggplot2::geom_point()
  td <- tempfile("myfuns_fig_")
  dir.create(td)
  out <- export_figuras(list(teste = p), td, formats = "svg", family = "sans")
  expect_true(file.exists(out$teste[["svg"]]))
})

test_that("clipboard moderno é explícito fora do Windows", {
  if (.Platform$OS.type != "windows") {
    expect_error(read_clipboard_table(), "Windows")
    expect_error(write_clipboard_table(head(iris)), "Windows")
  } else {
    succeed()
  }
})
