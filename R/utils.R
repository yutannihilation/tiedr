append_cols <- function(.data, ..., offset = ncol(.data)) {
  n_col <- ncol(.data)
  offset <- min(offset, n_col)
  tibble::tibble(!!!.data[seq_len(offset)], ..., !!!.data[seq_len(n_col - offset) + offset])
}

flatten_chr_depth <- function(.x, .depth = purrr::vec_depth(.x) - 1) {
  if (.depth <= 0) 
    rlang::abort("Invalid depth")
  
  if (.depth == 1) 
    return(purrr::flatten_chr(.x))
  
  res <- purrr::map(.x, function(x) {
    flatten_chr_depth(x, .depth - 1)
  })
  
  purrr::flatten_chr(res)
}
