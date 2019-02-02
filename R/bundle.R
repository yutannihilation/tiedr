#' Bundle And Unbundle Columns
#'
#' @name bundle
#' @param data A data.frame.
#' @param ... Selections of columns.
#' @param .key The name of the new column. If the dots have names, this will be ignored.
#' @export
bundle <- function(data, ..., .key = "data") {
  dots <- rlang::quos(...)

  # if all dots are unnamed, wrap it with a list
  if (any(!rlang::have_name(dots))) {
    if (any(rlang::have_name(dots))) {
      rlang::abort("You cannot specify both named and unnamed dots.")
    }
    dots <- rlang::quos(!!.key := c(!!!dots))
  }

  all_vars <- names(data)

  bundle_vars <- purrr::map(dots, tidyselect::vars_select, .vars = all_vars)
  bundle_vars_flattened <- purrr::flatten_chr(bundle_vars)

  if (anyDuplicated(bundle_vars_flattened)) {
    rlang::abort("Some columns are selected multiple times.")
  }

  group_vars <- setdiff(all_vars, bundle_vars_flattened)
  out <- dplyr::select(data, !!!rlang::syms(group_vars))

  out[names(bundle_vars)] <- purrr::map(bundle_vars, dplyr::select, .data = data)

  out[relocate_bundled_cols(all_vars, !!!bundle_vars)]
}

#' @rdname bundle
#' @export
unbundle <- function(data, ..., sep = "_") {
  all_vars <- names(data)
  target_vars <- tidyselect::vars_select(all_vars, ...)
  rest_vars <- setdiff(all_vars, target_vars)

  target <- dplyr::select(data, !!target_vars)

  if (!is.null(sep)) {
    # TODO: use imodify (c.f. https://github.com/tidyverse/purrr/issues/632)
    for (nm in names(target)) {
      target[[nm]] <- dplyr::rename_all(target[[nm]], function(x) paste0(nm, sep, x))
    }
  }

  out <- dplyr::select(data, !!rest_vars)
  for (d in target) {
    out[names(d)] <- d
  }

  unbundle_vars <- purrr::map(target, colnames)
  out[relocate_unbundled_cols(all_vars, !!!unbundle_vars)]
}

relocate_bundled_cols <- function(orig_vars, ...) {
  bundlings <- rlang::list2(...)
  if (any(!rlang::have_name(bundlings))) {
    rlang::abort("All ... must be named")
  }

  bundling_vars <- names(bundlings)
  bundled_vars <- purrr::flatten_chr(bundlings)
  rest_vars <- setdiff(orig_vars, bundled_vars)
  all_vars <- c(bundling_vars, rest_vars)

  # Bundling colums will be located at the most left one of the columns it bundles.
  bundled_vars_first <- purrr::map_chr(bundlings, ~ .[1])
  all_vars_w_alias <- c(bundled_vars_first, rest_vars)
  pos_in_orig <- match(all_vars_w_alias, orig_vars)

  all_orders <- order(pos_in_orig)

  all_vars[all_orders]
}

relocate_unbundled_cols <- function(orig_vars, ...) {
  bundlings <- rlang::list2(...)
  if (any(!rlang::have_name(bundlings))) {
    rlang::abort("All ... must be named")
  }

  bundling_vars <- names(bundlings)
  bundled_vars <- purrr::flatten_chr(bundlings)
  rest_vars <- setdiff(orig_vars, bundling_vars)
  all_vars <- c(bundled_vars, rest_vars)
  pos_in_bundles <- match(all_vars, bundling_vars)

  # First, matches against the current columns, with unbundled columns aliased to the bundling vars.
  # Then, sort them as the order inside the bundle.
  bundling_vars_rep <- rep(bundling_vars, purrr::map_int(bundlings, length))
  all_vars_w_alias <- c(bundling_vars_rep, rest_vars)
  pos_in_orig <- match(all_vars_w_alias, orig_vars)

  all_orders <- order(pos_in_orig, pos_in_bundles)

  all_vars[all_orders]
}
