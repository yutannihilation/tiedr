context("test-named_capture_group")

test_that("get_named_capture_groups() works", {
  expect_equal(get_named_capture_groups("(?<name>.*)"), c("name"))
  expect_equal(get_named_capture_groups("(?<name>.*)_(?<value>.*)"), c("name", "value"))
})

test_that("build_regex() works", {
  expect_equal(build_regex("{value}"), "^.*?(?<value>.*).*?$")
  expect_equal(build_regex("{value}_{name}"), "^.*?(?<value>.*)_(?<name>.*).*?$")
  expect_equal(build_regex("(?<value>[a-z]+)_{name}"), "^.*?(?<value>[a-z]+)_(?<name>.*).*?$")
  expect_equal(build_regex("^prefix_{value}_{name}"), "^prefix_(?<value>.*)_(?<name>.*).*?$")
  expect_equal(build_regex("{value}_{name}_suffix$"), "^.*?(?<value>.*)_(?<name>.*)_suffix$")
})

test_that("str_extract_groups() works", {
  expect_equal(
    str_extract_groups(c("a_val", "b_val"), "{name}_{value}"),
    tibble::tibble(name = c("a", "b"), value = c("val", "val"))
  )
})
