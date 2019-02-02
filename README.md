
<!-- README.md is generated from README.Rmd. Please edit that file -->

# tiedr

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![Travis build
status](https://travis-ci.com/yutannihilation/tiedr.svg?branch=master)](https://travis-ci.com/yutannihilation/tiedr)
<!-- badges: end -->

tiedr is not tidyr.

## Usages

### `bundle()` and `unbundle()`

`bundle()` bundles columns into a data.frame column, and `unbundle()`
unbundles it.

``` r
library(tiedr)

iris <- tibble::as_tibble(iris)

# bundle() takes unnamed arguments
iris %>% 
  bundle(-Species)
#> # A tibble: 150 x 2
#>    data$Sepal.Length $Sepal.Width $Petal.Length $Petal.Width Species
#>                <dbl>        <dbl>         <dbl>        <dbl> <fct>  
#>  1               5.1          3.5           1.4          0.2 setosa 
#>  2               4.9          3             1.4          0.2 setosa 
#>  3               4.7          3.2           1.3          0.2 setosa 
#>  4               4.6          3.1           1.5          0.2 setosa 
#>  5               5            3.6           1.4          0.2 setosa 
#>  6               5.4          3.9           1.7          0.4 setosa 
#>  7               4.6          3.4           1.4          0.3 setosa 
#>  8               5            3.4           1.5          0.2 setosa 
#>  9               4.4          2.9           1.4          0.2 setosa 
#> 10               4.9          3.1           1.5          0.1 setosa 
#> # ... with 140 more rows

# bundle() also takes named arguments
d <- iris %>% 
  bundle(Sepal = starts_with("Sepal"),
         Petal = starts_with("Petal"))

# bundled columns can be bundled
d %>%
  bundle(-Species)
#> # A tibble: 150 x 2
#>    data$Sepal$Sepal.L~ $$Sepal.Width $Petal$Petal.Le~ $$Petal.Width Species
#>                  <dbl>         <dbl>            <dbl>         <dbl> <fct>  
#>  1                 5.1           3.5              1.4           0.2 setosa 
#>  2                 4.9           3                1.4           0.2 setosa 
#>  3                 4.7           3.2              1.3           0.2 setosa 
#>  4                 4.6           3.1              1.5           0.2 setosa 
#>  5                 5             3.6              1.4           0.2 setosa 
#>  6                 5.4           3.9              1.7           0.4 setosa 
#>  7                 4.6           3.4              1.4           0.3 setosa 
#>  8                 5             3.4              1.5           0.2 setosa 
#>  9                 4.4           2.9              1.4           0.2 setosa 
#> 10                 4.9           3.1              1.5           0.1 setosa 
#> # ... with 140 more rows

# unbundle()
unbundle(d, Sepal, Petal)
#> # A tibble: 150 x 5
#>    Sepal.Length Sepal.Width Petal.Length Petal.Width Species
#>           <dbl>       <dbl>        <dbl>       <dbl> <fct>  
#>  1          5.1         3.5          1.4         0.2 setosa 
#>  2          4.9         3            1.4         0.2 setosa 
#>  3          4.7         3.2          1.3         0.2 setosa 
#>  4          4.6         3.1          1.5         0.2 setosa 
#>  5          5           3.6          1.4         0.2 setosa 
#>  6          5.4         3.9          1.7         0.4 setosa 
#>  7          4.6         3.4          1.4         0.3 setosa 
#>  8          5           3.4          1.5         0.2 setosa 
#>  9          4.4         2.9          1.4         0.2 setosa 
#> 10          4.9         3.1          1.5         0.1 setosa 
#> # ... with 140 more rows
```

### `auto_bundle()`

``` r
d <- tibble::tribble(
  ~A_a_x, ~A_a_y, ~A_b_x, ~B_a_x, ~B_b_x, ~B_b_y,
       1,      2,      3,      4,      5,      6,
       2,      3,      4,      5,      6,      7
)

auto_bundle(d, everything())
#> # A tibble: 2 x 2
#>   A$a$x   $$y  $b$x B$a$x  $b$x   $$y
#>   <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
#> 1     1     2     3     4     5     6
#> 2     2     3     4     5     6     7
auto_bundle(d, starts_with("A"))
#> # A tibble: 2 x 4
#>   A$a$x   $$y  $b$x B_a_x B_b_x B_b_y
#>   <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
#> 1     1     2     3     4     5     6
#> 2     2     3     4     5     6     7
```

### `gather_bundles()`

``` r
auto_bundle(d, everything()) %>%
  gather_bundles()
#> # A tibble: 4 x 3
#>   key     a$x    $y   b$x    $y
#>   <chr> <dbl> <dbl> <dbl> <dbl>
#> 1 A         1     2     3    NA
#> 2 A         2     3     4    NA
#> 3 B         4    NA     5     6
#> 4 B         5    NA     6     7

auto_bundle(d, everything()) %>%
  gather_bundles(.key = "key_outer") %>%
  gather_bundles(.key = "key_inner")
#> # A tibble: 8 x 4
#>   key_outer key_inner     x     y
#>   <chr>     <chr>     <dbl> <dbl>
#> 1 A         a             1     2
#> 2 A         a             2     3
#> 3 B         a             4    NA
#> 4 B         a             5    NA
#> 5 A         b             3    NA
#> 6 A         b             4    NA
#> 7 B         b             5     6
#> 8 B         b             6     7

auto_bundle(d, everything()) %>%
  gather_bundles(.key = "key_outer") %>%
  gather_bundles(.key = "key_inner") %>%
  gather_bundles(x:y, .key = "xy")
#> # A tibble: 16 x 4
#>    key_outer key_inner xy    value
#>    <chr>     <chr>     <chr> <dbl>
#>  1 A         a         x         1
#>  2 A         a         x         2
#>  3 B         a         x         4
#>  4 B         a         x         5
#>  5 A         b         x         3
#>  6 A         b         x         4
#>  7 B         b         x         5
#>  8 B         b         x         6
#>  9 A         a         y         2
#> 10 A         a         y         3
#> 11 B         a         y        NA
#> 12 B         a         y        NA
#> 13 A         b         y        NA
#> 14 A         b         y        NA
#> 15 B         b         y         6
#> 16 B         b         y         7
```
