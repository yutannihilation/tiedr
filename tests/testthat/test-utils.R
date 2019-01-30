context("test-utils")

test_that("flatten_names_depth() works", {
  expect_equal(flatten_names_depth(c(a = "a", b = "b")), c("a", "b"))
  expect_equal(flatten_names_depth(list(A = c("a", "b"), B = c("a", "c")), 0), c("A", "B"))
  expect_equal(flatten_names_depth(list(A = list(y = c("a", "c")), B = list(x = c("b"))), 1), c("x", "y"))
  expect_equal(flatten_names_depth(list(A = list(y = c("a", "c")), B = list(x = c("b"))), 0), c("A", "B"))

  expect_error(flatten_names_depth(list(A = list(y = c("a", "c")), B = list(x = c("b"))), 2))
  expect_error(flatten_names_depth(list(a = 1:2, b = "x"), 1))
})

test_that("cross_names_depth() works", {
  expect_equal(cross_names_depth(list(A = 1, B = 1)), list(c("A"), c("B")))
  expect_equal(
    cross_names_depth(list(A = list(a = "a", b = "b"), B = list(c = "c"))),
    list(c("A", "a"), c("B", "a"), c("A", "b"), c("B", "b"), c("A", "c"), c("B", "c"))
  )
  expect_equal(
    cross_names_depth(list(A = list(y = list(a = 1:3, c = 1:3)), B = list(x = list(b = 1:3)))),
    list(
      c("A", "x", "a"), c("B", "x", "a"),
      c("A", "y", "a"), c("B", "y", "a"),
      c("A", "x", "b"), c("B", "x", "b"),
      c("A", "y", "b"), c("B", "y", "b"),
      c("A", "x", "c"), c("B", "x", "c"),
      c("A", "y", "c"), c("B", "y", "c")
    )
  )

  # specify depth
  expect_equal(
    cross_names_depth(list(A = list(y = list(a = 1:3, c = 1:3)), B = list(x = list(b = 1:3))), depth = 2),
    list(c("A", "x"), c("B", "x"), c("A", "y"), c("B", "y"))
  )
  expect_equal(
    cross_names_depth(list(A = list(y = list(a = 1:3, c = 1:3)), B = list(x = list(b = 1:3))), depth = 1),
    list("A", "B")
  )
})

test_that("complete_bundles() works", {
  dummy <- rep(NA, 3L)
  tb <- tibble::tibble # tired of typing...

  d <- complete_bundles(tb(id = 1:3, A = tb(a = 1:3, c = 2:4), B = tb(b = 3:5)))
  expect_equal(d$id, 1:3)
  expect_equal(d$A, tb(a = 1:3, b = dummy, c = 2:4))
  expect_equal(d$B, tb(a = dummy, b = 3:5, c = dummy))

  d <- complete_bundles(tb(id = 1:3, A = tb(a = tb(x = 1:3, y = 2:4)), B = tb(a = tb(y = 0:2), b = tb(x = 3:5))))
  expect_equal(d$id, 1:3)
  expect_equal(d$A$a, tb(x = 1:3, y = 2:4))
  expect_equal(d$A$b, tb(x = dummy, y = dummy))
  expect_equal(d$B$a, tb(x = dummy, y = 0:2))
  expect_equal(d$B$b, tb(x = 3:5, y = dummy))
})
