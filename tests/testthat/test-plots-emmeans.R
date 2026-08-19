test_that("plot_emmeans retorna ggplot", {
  m <- lm(weight ~ group, data = PlantGrowth)
  ce <- comparar_emmeans(m, ~ group)
  p <- plot_emmeans(ce)
  expect_s3_class(p, "ggplot")
})
