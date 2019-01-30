context("test-utils")

test_that("flatten_names_depth() works", {
  expect_equal(flatten_names_depth(c(a = "a", b = "b")), c("a", "b"))
  expect_equal(flatten_names_depth(list(A = c("a", "b"), B = c("a", "c")), 0), c("A", "B"))
  expect_equal(flatten_names_depth(list(A = list(y = c("a", "c")), B = list(x = c("b"))), 1), c("x", "y"))
  expect_equal(flatten_names_depth(list(A = list(y = c("a", "c")), B = list(x = c("b"))), 0), c("A", "B"))
  
  expect_error(flatten_names_depth(list(A = list(y = c("a", "c")), B = list(x = c("b"))), 2))
  expect_error(flatten_names_depth(list(a = 1:2, b = "x"), 1))
})

test_that("cross_tree_addresses() works", {
  expect_equal(cross_tree_addresses(list(A = 1, B = 1)), list(c("A"), c("B")))
  expect_equal(cross_tree_addresses(list(A = list(a = "a", b = "b"), B = list(c = "c"))),
               list(c("A", "a"), c("B", "a"), c("A", "b"), c("B", "b"), c("A", "c"), c("B", "c")))
  expect_equal(cross_tree_addresses(list(A = list(y = list(a = 1:3, c = 1:3)), B = list(x = list(b = 1:3)))),
               list(c("A", "x", "a"), c("B", "x", "a"),
                    c("A", "y", "a"), c("B", "y", "a"),
                    c("A", "x", "b"), c("B", "x", "b"),
                    c("A", "y", "b"), c("B", "y", "b"),
                    c("A", "x", "c"), c("B", "x", "c"),
                    c("A", "y", "c"), c("B", "y", "c")))
  # TODO: test depth
})
