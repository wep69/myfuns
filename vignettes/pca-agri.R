## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(collapse = TRUE, comment = "#>")
library(myfuns)


## -----------------------------------------------------------------------------
pca1 <- pca_agri(
  iris,
  vars = c(Sepal.Length, Sepal.Width, Petal.Length, Petal.Width),
  group = Species
)
pca1


## -----------------------------------------------------------------------------
pca2 <- pca_agri(
  iris,
  vars = c(Sepal.Length, Sepal.Width, Petal.Length, Petal.Width),
  scale = FALSE
)
pca2$variancia


## -----------------------------------------------------------------------------
pca3 <- pca_agri(
  iris,
  vars = c(Sepal.Length, Sepal.Width, Petal.Length, Petal.Width),
  ncomp = 3
)
pca3$contribuicao


## -----------------------------------------------------------------------------
head(pca1$escores)
pca1$cargas
pca1$variancia
pca1$contribuicao


## ----fig.width=6, fig.height=5------------------------------------------------
plot_pca_agri(pca1, type = "biplot")


## ----fig.width=6, fig.height=5------------------------------------------------
plot_pca_agri(pca1, type = "scores", ellipse = TRUE)


## ----fig.width=6, fig.height=5------------------------------------------------
plot_pca_agri(pca3, axes = c(1, 3), type = "loadings", labels = TRUE)

