test_that("unzipping works", {
    docs <- unzip_export(folder = file.path("demo-project"), overwrite = T, recursive = T) 
    expect_true(grepl("demo.xmi", docs))
})


