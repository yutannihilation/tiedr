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

test_that("auto_bundle() works", {
  # TODO: dplyr:::all.equal.tbl_df() won't work with data.frame columns...

  d <- auto_bundle(tibble::tibble(id = 1:3, a_g1 = 3:5, a_g2 = 6:8), a_g1, a_g2)
  expect_equal(colnames(d), c("id", "a"))
  expect_equal(d$id, 1:3)
  expect_equal(d$a, tibble::tibble(g1 = 3:5, g2 = 6:8))

  d <- auto_bundle(tibble::tibble(id = 1:3, a_g1 = 3:5, a_g2 = 6:8, b_g1 = 2:4, b_g2 = 4:6), a_g1, a_g2)
  expect_equal(colnames(d), c("id", "a", "b_g1", "b_g2"))
  expect_equal(d$id, 1:3)
  expect_equal(d$a, tibble::tibble(g1 = 3:5, g2 = 6:8))
  expect_equal(d$b_g1, 2:4)
  expect_equal(d$b_g2, 4:6)

  d <- auto_bundle(tibble::tibble(id = 1:3, a_g1 = 3:5, a_g2 = 6:8, b_g1 = 2:4, b_g2 = 4:6), a_g1:b_g2)
  expect_equal(colnames(d), c("id", "a", "b"))
  expect_equal(d$id, 1:3)
  expect_equal(d$a, tibble::tibble(g1 = 3:5, g2 = 6:8))
  expect_equal(d$b, tibble::tibble(g1 = 2:4, g2 = 4:6))

  d <- auto_bundle(tibble::tibble(id = 1:3, A_a_x = 3:5, A_b_x = 6:8, B_a_x = 2:4, B_a_y = 4:6), -id)
  expect_equal(colnames(d), c("id", "A", "B"))
  expect_equal(d$id, 1:3)
  expect_equal(d$A$a, tibble::tibble(x = 3:5))
  expect_equal(d$A$b, tibble::tibble(x = 6:8))
  expect_equal(d$B$a, tibble::tibble(x = 2:4, y = 4:6))
})
