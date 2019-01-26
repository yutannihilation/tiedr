context("test-utils")

test_that("vars_split() works", {
  expect_equal(
    vars_split(c("a", "b", "c"), a),
    list(selected = c("a"), rest = c("b", "c"))
  )
  expect_equal(
    vars_split(c("a", "b", "c"), "a"),
    list(selected = c("a"), rest = c("b", "c"))
  )
  expect_equal(
    vars_split(c("a", "b", "c"), -a),
    list(selected = c("b", "c"), rest = c("a"))
  )

  expect_equal(
    vars_split(c("a1", "a2", "b1"), starts_with("a")),
    list(selected = c("a1", "a2"), rest = c("b1"))
  )
})
