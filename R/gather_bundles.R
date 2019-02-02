#' Gather bundles to columns
#'
#' @export
gather_bundles <- function(data, ..., .key = "key", .value = "value") {
  dots <- rlang::quos(...)
  all_vars <- names(data)

  if (rlang::is_empty(dots)) {
    target_vars <- all_vars[purrr::map_lgl(data, is.data.frame)]
    if (rlang::is_empty(target_vars)) {
      target_vars <- all_vars
    }
  } else {
    target_vars <- tidyselect::vars_select(all_vars, !!!dots)
  }

  rest_vars <- setdiff(all_vars, target_vars)

  target <- dplyr::select(data, !!!rlang::syms(target_vars))

  out <- dplyr::select(data, !!!rlang::syms(rest_vars))
  # TODO: use vctrs::vec_slice()
  out <- out[rep(seq_len(nrow(data)), length(target)), ]

  out[[.key]] <- rep(target_vars, each = nrow(data))

  target_binded <- bind_rows_recursively(target)
  if (all(rlang::have_name(target_binded))) {
    out[names(target_binded)] <- target_binded
  } else {
    out[[.value]] <- target_binded
  }

  # TODO: sort columns
  out
}

#' @export
bind_rows_recursively <- function(x) {
  if (!all(rlang::have_name(x))) {
    rlang::abort("All elements in x must have names")
  }

  if (all(purrr::map_lgl(x, rlang::is_atomic))) {
    return(vctrs::vec_c(!!!unname(as.list(x))))
  }

  x_bundled <- purrr::map(x, dplyr::select_if, is.data.frame)
  x_rbindable <- purrr::map(x, dplyr::select_if, purrr::negate(is.data.frame))

  # TODO: vctrs::vec_rbind() cannot bind 0-column data.frame
  out <- dplyr::bind_rows(x_rbindable)

  bundled_cols <- sort(unique(purrr::flatten_chr(purrr::map(x_bundled, colnames))))
  for (col in bundled_cols) {
    l <- purrr::map(x_bundled, ~ .[[col]] %||% tibble::tibble(.rows = nrow(.)))
    out[[col]] <- bind_rows_recursively(l)
  }

  # TODO: sort columns
  out
}
