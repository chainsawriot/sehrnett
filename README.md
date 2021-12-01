
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

The data is not included in the package. The package will download the
data (\~100M Zipped, \~400M Unzipped) from the Internet, if such data is
not available. Please make sure you agree with the [WordNet
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
#> 1 301590750  nice        1
#> 2 108957024  nice        1
#> 3 302000490  nice        2
#> 4 301844650  nice        3
#> 5 300987524  nice        4
#> 6 300644482  nice        5
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
#> 1 108957024  nice        1
#>                                                                                     definition
#> 1 a city in southeastern France on the Mediterranean; the leading resort on the French Riviera
#>   pos     lexdomain
#> 1   n noun.location
```

## A practical example

For example, you want to know the synonyms of the word “nuance” (very
important for academic writing). You can first search using the lemma
“nuance” with `search_lemma`.

``` r
res <- search_lemma("nuance")
res
#>    synsetid  lemma sensenum
#> 1 106618544 nuance        1
#>                                              definition pos          lexdomain
#> 1 a subtle difference in meaning or opinion or attitude   n noun.communication
```

There could be multiple word senses and you need to choose which word
sense you want to convey. But in this case, there is only one. You can
then search for the `synsetid` (cognitive synonym identifier) of that
word sense.

``` r
search_synsetid(res$synsetid[1])
#>    synsetid      lemma sensenum
#> 1 106618544     nicety        2
#> 2 106618544     nuance        1
#> 3 106618544 refinement        4
#> 4 106618544      shade        4
#> 5 106618544   subtlety        1
#>                                              definition pos          lexdomain
#> 1 a subtle difference in meaning or opinion or attitude   n noun.communication
#> 2 a subtle difference in meaning or opinion or attitude   n noun.communication
#> 3 a subtle difference in meaning or opinion or attitude   n noun.communication
#> 4 a subtle difference in meaning or opinion or attitude   n noun.communication
#> 5 a subtle difference in meaning or opinion or attitude   n noun.communication
```
