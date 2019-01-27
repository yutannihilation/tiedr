
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
