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
