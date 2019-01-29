context("test-auto_bundle")

test_that("seperate_colnames() works", {
  expect_equal(
    seperate_colnames(c("a_b", "a_d")),
    rbind(c("a", "b"), c("a", "d"))
  )
  expect_equal(
    seperate_colnames(c("a.foo", "a bar")),
    rbind(c("a", "foo"), c("a", "bar"))
  )
  expect_error(seperate_colnames(c("a_b_c", "a_b")))
})

test_that("enstructure_colnames() works", {
  expect_equal(
    enstructure_colnames(c("a_b", "a_d")),
    list(a = list(b = "a_b", d = "a_d"))
  )
  expect_equal(
    enstructure_colnames(c("a_b", "a_d", "b_b")),
    list(a = list(b = "a_b", d = "a_d"), b = list(b = "b_b"))
  )
  expect_equal(
    enstructure_colnames(c("A_a_x", "A_a_y", "A_b_x", "B_b_x")),
    list(
      A = list(
        a = list(
          x = "A_a_x",
          y = "A_a_y"
        ),
        b = list(
          x = "A_b_x"
        )
      ),
      B = list(
        b = list(
          x = "B_b_x"
        )
      )
    )
  )
})
