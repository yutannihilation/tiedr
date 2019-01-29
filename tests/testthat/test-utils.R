context("test-utils")

test_that("flatten_names_depth() works", {
  expect_equal(flatten_names_depth(c(a = "a", b = "b")), c("a", "b"))
  expect_equal(flatten_names_depth(list(A = c("a", "b"), B = c("a", "c")), 0), c("A", "B"))
  expect_equal(flatten_names_depth(list(A = list(y = c("a", "c")), B = list(x = c("b"))), 1), c("x", "y"))
  expect_equal(flatten_names_depth(list(A = list(y = c("a", "c")), B = list(x = c("b"))), 0), c("A", "B"))
  
  expect_error(flatten_names_depth(list(A = list(y = c("a", "c")), B = list(x = c("b"))), 2))
  expect_error(flatten_names_depth(list(a = 1:2, b = "x"), 1))
})
