append_cols <- function(.data, ..., offset = ncol(.data)) {
  n_col <- ncol(.data)
  offset <- min(offset, n_col)
  tibble::tibble(!!!.data[seq_len(offset)], ..., !!!.data[seq_len(n_col - offset) + offset])
}

flatten_names_depth <- function(.x, .depth = purrr::vec_depth(.x) - 1) {
  res <- flatten_names_depth_rec(.x, .depth = .depth)
  sort(unique(res))
}

flatten_names_depth_rec <- function(.x, .depth = purrr::vec_depth(.x) - 1) {
  if (.depth < 0) {
    rlang::abort("Invalid depth")
  }

  if (.depth == 0) {
    res <- names(.x)

    if (is.null(res)) {
      rlang::abort("The elements at the depth don't have names.")
    }

    return(res)
  }

  res <- purrr::map(.x, function(x) {
    flatten_names_depth_rec(x, .depth - 1)
  })

  purrr::flatten_chr(res)
}

cross_names_depth <- function(x, depth = purrr::vec_depth(x) - 1) {
  names <- purrr::map(seq_len(depth) - 1, ~ flatten_names_depth(x, .))
  names_crossed <- purrr::cross(names)
  purrr::map(names_crossed, purrr::flatten_chr)
}

complete_bundles <- function(x) {
  n_row <- nrow(x)
  dummy_col <- rep(NA, n_row)

  # we modify the actual data, but use addresses only from bundled columns
  bundled <- dplyr::select_if(x, is.data.frame)
  # TODO: check all depths are equal
  max_depth <- purrr::vec_depth(bundled) - 1

  for (depth in seq_len(max_depth - 1)) {
    for (address in cross_names_depth(bundled, depth)) {
      x[[address]] <- x[[address]] %||% tibble::tibble(.rows = n_row)
    }
  }

  for (address in cross_names_depth(bundled, max_depth)) {
    x[[address]] <- x[[address]] %||% dummy_col
  }

  x
}

bind_rows_with_care <- function(x, y) {
  NULL
}
