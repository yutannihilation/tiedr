#' Bundle And Unbundle columns
#'
#' @param data A data.frame.
#' @param ... Selections of columns.
#' @param .key The name of the new column. If the dots have names, this will be ignored.
#' @export
bundle <- function(data, ..., .key = "data") {
  dots <- rlang::quos(...)

  if (all(rlang::have_name(dots))) {
    return(bundle_impl(data, !!!dots))
  }

  if (all(!rlang::have_name(dots))) {
    return(bundle_impl(data, !!.key := c(!!!dots)))
  }

  rlang::abort("You cannot specify both named and unnamed dots.")
}

bundle_impl <- function(data, ...) {
  dots <- rlang::quos(...)
  all_vars <- names(data)

  bundle_vars <- purrr::map(dots, tidyselect::vars_select, .vars = all_vars)
  bundle_vars_flattened <- purrr::flatten_chr(bundle_vars)

  if (anyDuplicated(bundle_vars_flattened)) {
    rlang::abort("Some columns are selected multiple times.")
  }

  group_vars <- setdiff(all_vars, bundle_vars_flattened)
  out <- dplyr::select(data, !!!rlang::syms(group_vars))

  out[names(bundle_vars)] <- purrr::map(bundle_vars, dplyr::select, .data = data)
  
  out[relocate_cols(all_vars, !!!bundle_vars)]
}

#' @rdname bundle
#' @export
unbundle <- function(data, ...) {
  c(unbundle, rest) %<-% vars_split(names(data), ...)

  # TOOD: relocate_cols()
  dplyr::bind_cols(
    dplyr::select(data, !!!rlang::syms(rest)),
    !!!dplyr::select(data, !!!rlang::syms(unbundle))
  )
}

# TODO: more generalize aliasing
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
