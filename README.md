
<!-- README.md is generated from README.Rmd. Please edit that file -->

# sehrnett

<!-- badges: start -->

<!-- badges: end -->

The goal of sehrnett is to provide a nice (and fast) interface to
[Princeton’s WordNet](https://wordnet.princeton.edu/). Unlike the
original [wordnet
package](https://cran.r-project.org/web/packages/wordnet/index.html)
(Feinerer et al., 2020), you don’t need to install WordNet and / or
setup rJava.

The data is not included in the package. A function will be provided
later to download the data (\~100M Zipped, \~400M Unzipped) from the
Internet, if such data is not available. Please make sure you agree with
the [WordNet
License](https://wordnet.princeton.edu/license-and-commercial-use).

## Installation

``` r
devtools::install_github("chainsawriot/sehrnett")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(sehrnett)
```

``` r
search_lemma("nice")
#>    synsetid lemma sensenum
#> 1 301590922  nice        1
#> 2 108871659  nice        1
#> 3 302000844  nice        2
#> 4 301844822  nice        3
#> 5 300987625  nice        4
#> 6 300644573  nice        5
#>                                                                                     definition
#> 1                                    pleasant or pleasing or agreeable in nature or appearance
#> 2 a city in southeastern France on the Mediterranean; the leading resort on the French Riviera
#> 3                                      socially or conventionally correct; refined or virtuous
#> 4                                                                 done with delicacy and skill
#> 5                                                  excessively fastidious and easily disgusted
#> 6                                                           exhibiting courtesy and politeness
#>   pos     lexdomain
#> 1   a       adj.all
#> 2   n noun.location
#> 3   s       adj.all
#> 4   s       adj.all
#> 5   s       adj.all
#> 6   s       adj.all
```

``` r
search_lemma("nice", pos = "n")
#>    synsetid lemma sensenum
#> 1 108871659  nice        1
#>                                                                                     definition
#> 1 a city in southeastern France on the Mediterranean; the leading resort on the French Riviera
#>   pos     lexdomain
#> 1   n noun.location
```
