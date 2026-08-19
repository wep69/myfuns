test_that("temas retornam objetos theme", {
  expect_s3_class(theme_nogrid(), "theme")
  expect_s3_class(theme_nogridacp(), "theme")
  expect_s3_class(theme_transparent(), "theme")
  expect_s3_class(trans, "theme")
})
