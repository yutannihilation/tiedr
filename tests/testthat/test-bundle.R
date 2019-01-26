context("test-bundle")

test_that("bundle() for simple cases works", {
  d <- data.frame(x = 1:3, a1 = 11:13, y = 1:3, a2 = 21:23)

  expected <- d[, c("x", "y"), drop = FALSE]
  expected$data <- d[, c("a1", "a2")]
  expected <- expected[, c("x", "data", "y")]

  expect_equal(bundle(d, a1, a2), expected)
  expect_equal(bundle(d, c("a1", "a2")), expected)
  expect_equal(bundle(d, -x, -y), expected)
  expect_equal(bundle(d, starts_with("a")), expected)
})

test_that("relocate_cols() works", {
  expect_equal(relocate_cols(c("x", "a1", "y", "a2"), a = c("a1", "a2")), c("x", "a", "y"))
  expect_equal(relocate_cols(c("x", "a1", "y", "a2"), !!!list(a = c("a1", "a2"))), c("x", "a", "y"))

  expect_equal(relocate_cols(c("x", "a1", "b1", "y", "b2", "a2"), a = c("a1", "a2"), b = c("b1", "b2")), c("x", "a", "b", "y"))
})
