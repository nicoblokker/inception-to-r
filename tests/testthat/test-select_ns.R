test_that("displaying namespaces works", {
          expect_equal(length(select_ns(file.path("demo.xmi"))), 21)
})
