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
  if (.depth < 0) 
    rlang::abort("Invalid depth")
  
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

cross_tree_addresses <- function(x, depth = purrr::vec_depth(x) - 1) {
  names <- purrr::map(seq_len(depth) - 1, ~ flatten_names_depth(x, .))
  names_crossed <- purrr::cross(names)
  purrr::map(names_crossed, purrr::flatten_chr)
}

complete_tree <- function(x) {
  purrr::reduce(
    seq_len(purrr::vec_depth(x) - 1),
    function(x, depth) {
      addresses <- cross_tree_addresses(depth)
      purrr::reduce(
        addresses,
        ~ .x[[.y]] <- .x[[.y]] %||% tibble::tibble(),
        .init = x
      )
    },
    .init = x
  )
}
