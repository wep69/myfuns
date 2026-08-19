test_that("auditar_delineamento identifica estrutura completa e incompleta", {
  d <- expand.grid(bloco = factor(1:3), tratamento = factor(c("A", "B")))
  d$y <- seq_len(nrow(d))
  a <- auditar_delineamento(d, tratamento, bloco, resposta = y)
  expect_s3_class(a, "myfuns_delineamento")
  expect_equal(nrow(a$celulas_ausentes), 0)

  a2 <- auditar_delineamento(d[-1, ], tratamento, bloco, resposta = y)
  expect_gt(nrow(a2$celulas_ausentes), 0)
})

test_that("resumo_agri calcula estatísticas por grupo", {
  r <- resumo_agri(iris, Sepal.Length, by = Species)
  expect_true(is.data.frame(r))
  expect_equal(nrow(r), 3)
  expect_true(all(c("media", "dp", "erro_padrao", "cv") %in% names(r)))
})
