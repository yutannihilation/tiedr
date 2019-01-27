# FIXME: no more needed?
vars_split <- function(.vars, ...,
                       .include = character(), .exclude = character(),
                       .strict = TRUE) {
  selected <- tidyselect::vars_select(.vars, ...,
    .include = .include, .exclude = .exclude,
    .strict = .strict
  )

  list(
    selected = unname(selected),
    rest = setdiff(.vars, selected)
  )
}

append_cols <- function(.data, ..., offset = ncol(.data)) {
  n_col <- ncol(.data)
  offset <- min(offset, n_col)
  tibble::tibble(!!!.data[seq_len(offset)], ..., !!!.data[seq_len(n_col - offset) + offset])
}
