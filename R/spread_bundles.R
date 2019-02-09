#' Spread packed columns
#'
#' @export
spread_bundles <- function(data, key, ..., simplify = TRUE) {
  dots <- rlang::quos(...)
  key_var <- rlang::enquo(key)
  all_vars <- names(data)

  # TODO: think more carefully...
  if (rlang::is_empty(dots)) {
    target_vars <- all_vars[purrr::map_lgl(data, is.data.frame)]
    if (rlang::is_empty(target_vars)) {
      target_vars <- setdiff(all_vars, rlang::as_name(key_var))
    }
  } else {
    target_vars <- tidyselect::vars_select(all_vars, !!!dots)
  }

  group_vars <- setdiff(names(data), c(target_vars, rlang::as_name(key_var)))
  data <- tidyr::complete(data, !!key_var, !!!rlang::syms(group_vars))

  groups <- tidyr::expand(data, !!!rlang::syms(group_vars))
  if (length(target_vars) == 1 && simplify) {
    bundles <- split(dplyr::pull(data, !!target_vars), dplyr::pull(data, !!key_var))
  } else {
    bundles <- split(dplyr::select(data, !!target_vars), dplyr::pull(data, !!key_var))
  }
  tibble::tibble(!!!groups, !!!bundles)

  # TOOD: sort columns
}
