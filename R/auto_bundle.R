#' Automatically Bundle Columns
#'
#' @export
auto_bundle <- function(data, ..., sep = "[^[:alnum:]]+") {
  all_vars <- names(data)
  bundle_vars <- tidyselect::vars_select(all_vars, ...)
  stringi::stri_split_regex(bundle_vars, sep)
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
