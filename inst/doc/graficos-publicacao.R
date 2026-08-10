## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(collapse = TRUE, comment = "#>")
library(myfuns)


## -----------------------------------------------------------------------------
p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) +
  ggplot2::geom_point(size = 2.5) +
  ggplot2::labs(x = "Peso", y = "Consumo")


## ----fig.width=6, fig.height=4------------------------------------------------
p + theme_nogrid()


## ----fig.width=6, fig.height=4------------------------------------------------
p + theme_nogridacp()


## ----fig.width=6, fig.height=4------------------------------------------------
p + trans


## -----------------------------------------------------------------------------
theme_transparent()


## ----eval=FALSE---------------------------------------------------------------
# ExportTimes(
#   p + theme_nogrid(),
#   "figuras/Figura_1",
#   formats = c("png", "svg")
# )


## ----eval=FALSE---------------------------------------------------------------
# ExportTimes(
#   p + theme_nogrid(),
#   "figuras/Figura_1",
#   formats = "tiff",
#   compression = "lzw"
# )


## ----eval=FALSE---------------------------------------------------------------
# ExportTimes(
#   p + trans,
#   "figuras/Figura_transparente",
#   formats = c("png", "svg"),
#   bg = "transparent"
# )


## -----------------------------------------------------------------------------
p2 <- ggplot2::ggplot(iris, ggplot2::aes(Species, Sepal.Length)) +
  ggplot2::geom_boxplot() + theme_nogrid()


## ----eval=FALSE---------------------------------------------------------------
# export_figuras(list(fig1 = p, fig2 = p2), "figuras", formats = "png")


## ----eval=FALSE---------------------------------------------------------------
# export_figuras(list(fig1 = p, fig2 = p2), "figuras", formats = c("png", "tiff", "svg"))


## ----eval=FALSE---------------------------------------------------------------
# export_figuras(
#   list(fig1 = p + trans, fig2 = p2 + trans),
#   "figuras_transparentes",
#   formats = c("png", "svg"),
#   bg = "transparent"
# )

