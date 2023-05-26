test_that("extracting annotations works", {
  df <- xmi2df(xmi_file = file.path("demo.xmi"), key = "custom")
  expect_equal(nrow(df), 3)
})
