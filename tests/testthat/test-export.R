test_that("ExportTimes valida formatos", {
  p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) + ggplot2::geom_point()
  expect_error(
    ExportTimes(p, tempfile(), formats = "jpeg"),
    "apenas"
  )
})
