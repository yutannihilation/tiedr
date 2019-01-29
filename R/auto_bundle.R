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
