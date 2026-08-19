test_that("pca_agri organiza resultados de prcomp", {
  p <- pca_agri(iris, vars = c(Sepal.Length, Sepal.Width, Petal.Length, Petal.Width), group = Species)
  expect_s3_class(p, "myfuns_pca")
  expect_equal(nrow(p$variancia), 4)
  expect_equal(round(sum(p$variancia$variancia), 10), 1)
})

test_that("pca_agri não remove ausências silenciosamente", {
  d <- iris
  d$Sepal.Length[1] <- NA
  expect_error(pca_agri(d, vars = c(Sepal.Length, Sepal.Width)), "valores ausentes")
})

test_that("plot_pca_agri retorna ggplot", {
  p <- pca_agri(iris, vars = c(Sepal.Length, Sepal.Width, Petal.Length, Petal.Width), group = Species)
  expect_s3_class(plot_pca_agri(p, type = "biplot"), "ggplot")
  expect_s3_class(plot_pca_agri(p, type = "scores"), "ggplot")
})
