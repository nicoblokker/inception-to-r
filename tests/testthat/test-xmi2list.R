test_that("extracting annotations to list works", {
          df <- xmi2list(xmi_file = file.path("demo.xmi"), key = "custom")
          expect_equal(nrow(df), 1)
})
