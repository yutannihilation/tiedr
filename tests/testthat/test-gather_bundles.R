context("test-gather_bundles")

tb <- tibble::tibble

test_that("bind_rows_recursively() works", {
  expect_equal(bind_rows_recursively(list(A = tb(x = 1:3), B = tb(x = 4:6))),
               tb(x = c(1:6)))
  # this cannot be gather()ed.
  d <- bind_rows_recursively(list(A = tb(x = 1:3), B = tb(x = 4:6, y = tb(foo = 1:3))))
  expect_equal(d$x, 1:6)
  expect_equal(d$y, tb(foo = c(NA, NA, NA, 1:3)))

  expect_equal(bind_rows_recursively(list(A = 1:3, B = 4:6)), 1:6)
})

test_that("gather_bundles() works for data.frames without bundles", {
  d <- tb(x = 1:2, y = 3:4, z = 5:6)
  expect_equal(gather_bundles(d),
               tb(key = rep(c("x", "y", "z"), each = 2), value = 1:6))
  expect_equal(gather_bundles(d, .key = "foo", .value = "bar"),
               tb(foo = rep(c("x", "y", "z"), each = 2), bar = 1:6))
  d_gathered <- gather_bundles(d, -z)
  expect_equal(d_gathered$key, rep(c("x", "y"), each = 2))
  expect_equal(d_gathered$z, rep(5:6, 2))
})

test_that("gather_bundles() works for data.frames with bundles", {
  d <- tb(x = tb(a = 1:3, b = 11:13), y = tb(b = 14:16))
  d_gathered <- gather_bundles(d)
  
  expect_equal(d_gathered$key, rep(c("x", "y"), each = 3))
  expect_equal(d_gathered$a, c(1:3, NA, NA, NA))
  expect_equal(d_gathered$b, c(11:16))

  d <- tb(id = 1:2,
          A = tb(x = tb(a = 1:2, b = 11:12), y = tb(b = 13:14)),
          B = tb(x = tb(a = 3:4), y = tb(c = 3:4)))
  d_gathered <- gather_bundles(d)
  
  expect_equal(d_gathered$id, rep(1:2, 2))
  expect_equal(d_gathered$key, rep(c("A", "B"), each = 2))
  expect_equal(d_gathered$x, tb(a = 1:4, b = c(11:12, NA, NA)))
  expect_equal(d_gathered$y, tb(b = c(13:14, NA, NA), c = c(NA, NA, 3:4)))
})
