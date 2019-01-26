context("test-bundle")

test_that("bundle() for simple cases works", {
  d <- data.frame(x = 1:3, a1 = 11:13, a2 = 21:23)

  expected <- d[, c("x"), drop = FALSE]
  expected$data <- d[, c("a1", "a2")]

  expect_equal(bundle(d, a1, a2), expected)
  expect_equal(bundle(d, c("a1", "a2")), expected)
  expect_equal(bundle(d, -x), expected)
  expect_equal(bundle(d, starts_with("a")), expected)
})
