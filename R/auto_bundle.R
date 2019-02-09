#' Automatically pack columns
#'
#' @export
auto_bundle <- function(data, ..., sep = "[^[:alnum:]]+") {
  all_vars <- names(data)
  bundle_vars <- tidyselect::vars_select(all_vars, ...)
  rest_vars <- setdiff(all_vars, bundle_vars)

  col_str <- enstructure_colnames(bundle_vars, sep = sep)

  # vec_depth() counts vectors as levels
  depth <- purrr::vec_depth(col_str) - 1

  # replace the colnames at the deepest level with the actual values
  bundled <- purrr::modify_depth(col_str, depth, ~ dplyr::pull(data, !!.))

  # combine them as tibble from deeper levels
  # (we use tibble() because dplyr::bind_cols() cannot handle data.frame columns at the moment)
  bundled <- purrr::reduce(
    (depth - 1):1,
    ~ purrr::modify_depth(.x, .y, ~ tibble::tibble(!!!.)),
    .init = bundled
  )

  out <- dplyr::select(data, !!!rlang::syms(rest_vars))
  out[names(bundled)] <- bundled

  out[relocate_bundled_cols(all_vars, !!!purrr::map(col_str, unlist, recursive = TRUE, use.names = FALSE))]
}

seperate_colnames <- function(x, sep = "[^[:alnum:]]+") {
  # simplify=NA simplifies the result to a matrix and fills missing cells with NA
  g <- stringi::stri_split_regex(x, sep, simplify = NA)

  if (any(is.na(g))) {
    rlang::abort("Some columns have different length!")
  }

  g
}

enstructure_colnames <- function(x, sep = "[^[:alnum:]]+") {
  res <- list()

  g <- seperate_colnames(x)

  # fill with empty lists
  for (j in seq_len(ncol(g) - 1)) {
    for (i in seq_len(nrow(g))) {
      pos <- g[i, 1:j]
      res[[pos]] <- res[[pos]] %||% list()
    }
  }

  # assign values
  for (i in seq_len(nrow(g))) {
    pos <- g[i, ]
    res[[pos]] <- x[i]
  }

  res
}
