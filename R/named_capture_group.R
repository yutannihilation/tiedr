#' Extract Named Capture Groups
#'
#' @param x A string.
#' @param pattern A regex.
#' @export
str_extract_groups <- function(x, pattern) {
  pattern <- build_regex(pattern)
  groups <- get_named_capture_groups(pattern)
  replacements <- paste0("${", groups, "}")
  names(replacements) <- groups

  purrr::map_dfc(replacements, ~ stringi::stri_replace_first_regex(x, pattern, .))
}

get_named_capture_groups <- function(pattern) {
  stringi::stri_extract_all_regex(pattern, "(?<=\\(\\?<).*?(?=>)")[[1]]
}

build_regex <- function(pattern) {
  pattern <- stringi::stri_replace_all_regex(pattern, "\\{(.*?)\\}", "(?<$1>.*)")
  pattern <- stringi::stri_replace_first_regex(pattern, "^(?=[^\\^])", "^.*?")
  pattern <- stringi::stri_replace_first_regex(pattern, "(?<=[^\\$])$", ".*?\\$")
  pattern
}
