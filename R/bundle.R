#' Bundle And Unbundle columns
#'
#' @export
bundle <- function(data, ..., .key = "data") {
  all_vars <- names(data)
  c(bundle_vars, group_vars) %<-% vars_split(all_vars, ...)

  out <- dplyr::select(data, !!! rlang::syms(group_vars))
  out[[.key]] <- dplyr::select(data, !!! rlang::syms(bundle_vars))
  
  out[relocate_cols(all_vars, !! .key := bundle_vars)]
}

relocate_cols <- function(orig_vars, ...) {
  bundled <- rlang::list2(...)
  if (any(!rlang::have_name(bundled))) {
    rlang::abort("All ... must be named")
  }

  rest <- setdiff(orig_vars, purrr::flatten_chr(bundled))

  # insert to the position of the left-most column
  bundled_orders <- purrr::map_int(bundled, ~ min(match(., orig_vars)))
  rest_orders <- match(rest, orig_vars)
  names(rest_orders) <- rest

  if (any(is.na(bundled_orders)) || any(is.na(bundled_orders))) {
    rlang::abort("Some variable are not found in orig_vars")
  }

  names(sort(c(bundled_orders, rest_orders)))
}
