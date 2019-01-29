context("test-auto_bundle")

test_that("seperate_colnames() works", {
  expect_equal(seperate_colnames(c("a_b", "a_d")),
               rbind(c("a", "b"), c("a", "d")))
  expect_equal(seperate_colnames(c("a.foo", "a bar")),
               rbind(c("a", "foo"), c("a", "bar")))
  expect_error(seperate_colnames(c("a_b_c", "a_b")))
})
