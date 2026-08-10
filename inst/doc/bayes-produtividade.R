## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(collapse = TRUE, comment = "#>")
library(myfuns)


## -----------------------------------------------------------------------------
if (requireNamespace("bayestestR", quietly = TRUE)) {
  set.seed(1)
  resumo_bayes(rnorm(3000, 0.4, 0.2), diagnostics = FALSE)
}


## -----------------------------------------------------------------------------
if (requireNamespace("bayestestR", quietly = TRUE)) {
  set.seed(2)
  resumo_bayes(
    rnorm(3000, 0.05, 0.15),
    diagnostics = FALSE,
    rope = c(-0.10, 0.10)
  )
}


## ----eval=FALSE---------------------------------------------------------------
# fit <- brms::brm(
#   mpg ~ wt,
#   data = mtcars,
#   family = gaussian(),
#   chains = 4,
#   iter = 2000,
#   seed = 123
# )
# resumo_bayes(fit, ci = 0.95, ci_method = "hdi")


## -----------------------------------------------------------------------------
p1 <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) +
  ggplot2::geom_point() + theme_nogrid()
p2 <- ggplot2::ggplot(iris, ggplot2::aes(Species, Sepal.Length)) +
  ggplot2::geom_boxplot() + theme_nogrid()


## ----eval=FALSE---------------------------------------------------------------
# export_figuras(
#   list(fig_mtcars = p1, fig_iris = p2),
#   dir = "figuras",
#   formats = "png"
# )


## ----eval=FALSE---------------------------------------------------------------
# export_figuras(
#   list(fig_mtcars = p1, fig_iris = p2),
#   dir = "figuras_tiff",
#   formats = "tiff",
#   dpi = 600
# )


## ----eval=FALSE---------------------------------------------------------------
# export_figuras(
#   list(fig_mtcars = p1 + trans, fig_iris = p2 + trans),
#   dir = "figuras_transparentes",
#   formats = c("png", "svg"),
#   bg = "transparent"
# )


## ----eval=FALSE---------------------------------------------------------------
# dados <- read_clipboard_table()


## ----eval=FALSE---------------------------------------------------------------
# dados <- read_clipboard_table(dec = ",", na.strings = c("", "NA"))


## ----eval=FALSE---------------------------------------------------------------
# dados <- read_clipboard_table(header = FALSE)


## ----eval=FALSE---------------------------------------------------------------
# write_clipboard_table(head(iris))


## ----eval=FALSE---------------------------------------------------------------
# write_clipboard_table(aggregate(Sepal.Length ~ Species, iris, mean))


## ----eval=FALSE---------------------------------------------------------------
# write_clipboard_table(head(mtcars), row.names = TRUE, col.names = TRUE)

