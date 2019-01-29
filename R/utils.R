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
    if (is.character(.x)) {
      return(.x)
    }
    
    res <- names(.x)
    
    if (is.null(res)) {
      rlang::abort("The elements are not characters and doesn't have names.")
    }
    
    return(res)
  }
  
  res <- purrr::map(.x, function(x) {
    flatten_names_depth_rec(x, .depth - 1)
  })
  
  purrr::flatten_chr(res)
}
