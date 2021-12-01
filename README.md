
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
search_lemma(c("very", "nice"))
#> # A tibble: 10 × 6
#>     synsetid lemma sensenum definition                          pos   lexdomain 
#>        <int> <chr>    <int> <chr>                               <chr> <chr>     
#>  1 400032295 very         1 used as intensifiers; real' is som… r     adv.all   
#>  2 400513282 very         2 precisely so                        r     adv.all   
#>  3 301845232 very         1 precisely as stated                 s     adj.all   
#>  4 302076350 very         2 being the exact same one; not any … s     adj.all   
#>  5 301590750 nice         1 pleasant or pleasing or agreeable … a     adj.all   
#>  6 108957024 nice         1 a city in southeastern France on t… n     noun.loca…
#>  7 302000490 nice         2 socially or conventionally correct… s     adj.all   
#>  8 301844650 nice         3 done with delicacy and skill        s     adj.all   
#>  9 300987524 nice         4 excessively fastidious and easily … s     adj.all   
#> 10 300644482 nice         5 exhibiting courtesy and politeness  s     adj.all
```

``` r
search_lemma("nice")
#> # A tibble: 6 × 6
#>    synsetid lemma sensenum definition                           pos   lexdomain 
#>       <int> <chr>    <int> <chr>                                <chr> <chr>     
#> 1 301590750 nice         1 pleasant or pleasing or agreeable i… a     adj.all   
#> 2 108957024 nice         1 a city in southeastern France on th… n     noun.loca…
#> 3 302000490 nice         2 socially or conventionally correct;… s     adj.all   
#> 4 301844650 nice         3 done with delicacy and skill         s     adj.all   
#> 5 300987524 nice         4 excessively fastidious and easily d… s     adj.all   
#> 6 300644482 nice         5 exhibiting courtesy and politeness   s     adj.all
```

``` r
search_lemma("nice", pos = "n")
#> # A tibble: 1 × 6
#>    synsetid lemma sensenum definition                           pos   lexdomain 
#>       <int> <chr>    <int> <chr>                                <chr> <chr>     
#> 1 108957024 nice         1 a city in southeastern France on th… n     noun.loca…
```

## A practical example

For example, you want to know the synonyms of the word “nuance” (very
important for academic writing). You can first search using the lemma
“nuance” with `search_lemma`.

``` r
res <- search_lemma("nuance")
res
#> # A tibble: 1 × 6
#>    synsetid lemma  sensenum definition                       pos   lexdomain    
#>       <int> <chr>     <int> <chr>                            <chr> <chr>        
#> 1 106618544 nuance        1 a subtle difference in meaning … n     noun.communi…
```

There could be multiple word senses and you need to choose which word
sense you want to convey. But in this case, there is only one. You can
then search for the `synsetid` (cognitive synonym identifier) of that
word sense.

``` r
# search_synonym() is a wrapper to search_synsetid
search_synsetid(res$synsetid[1])
#> # A tibble: 5 × 6
#>    synsetid lemma      sensenum definition                    pos   lexdomain   
#>       <int> <chr>         <int> <chr>                         <chr> <chr>       
#> 1 106618544 nicety            2 a subtle difference in meani… n     noun.commun…
#> 2 106618544 nuance            1 a subtle difference in meani… n     noun.commun…
#> 3 106618544 refinement        4 a subtle difference in meani… n     noun.commun…
#> 4 106618544 shade             4 a subtle difference in meani… n     noun.commun…
#> 5 106618544 subtlety          1 a subtle difference in meani… n     noun.commun…
```

## Chainablilty

All `search_` functions are chainable by using the magrittr pipe
operator.

``` r
c("switch off") %>% search_lemma(pos = "v") %>% search_synonym
#> # A tibble: 4 × 6
#>    synsetid lemma      sensenum definition                      pos   lexdomain 
#>       <int> <chr>         <int> <chr>                           <chr> <chr>     
#> 1 201513208 cut              27 cause to stop operating by dis… v     verb.cont…
#> 2 201513208 switch off        1 cause to stop operating by dis… v     verb.cont…
#> 3 201513208 turn off          1 cause to stop operating by dis… v     verb.cont…
#> 4 201513208 turn out         11 cause to stop operating by dis… v     verb.cont…
```
