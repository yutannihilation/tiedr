#' Bundle And Unbundle columns
#'
#' @export
bundle <- function(data, ..., .key = "data") {
  all_vars <- names(data)
  c(bundle_vars, group_vars) %<-% vars_split(all_vars, ...)

  out <- dplyr::select(data, !!! rlang::syms(group_vars))
  out[[.key]] <- dplyr::select(data, !!! rlang::syms(bundle_vars))
  out
}
