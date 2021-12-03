
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

The most basic function is `get_lemmas`. It generates basic information
about the lemmas you provided.

``` r
library(sehrnett)
```

``` r
get_lemmas(c("very", "nice"))
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
get_lemmas("nice")
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
get_lemmas("nice", pos = "n")
#> # A tibble: 1 × 6
#>    synsetid lemma sensenum definition                           pos   lexdomain 
#>       <int> <chr>    <int> <chr>                                <chr> <chr>     
#> 1 108957024 nice         1 a city in southeastern France on th… n     noun.loca…
```

Please note that some definitions in WordNet are considered pejorative
or offensive, e.g. 

``` r
get_lemmas("dog")
#> # A tibble: 8 × 6
#>    synsetid lemma sensenum definition                           pos   lexdomain 
#>       <int> <chr>    <int> <chr>                                <chr> <chr>     
#> 1 102086723 dog          1 a member of the genus Canis (probab… n     noun.anim…
#> 2 110133978 dog          2 a dull unattractive unpleasant girl… n     noun.pers…
#> 3 110042764 dog          3 informal term for a man              n     noun.pers…
#> 4 109905672 dog          4 someone who is morally reprehensible n     noun.pers…
#> 5 107692347 dog          5 a smooth-textured sausage of minced… n     noun.food 
#> 6 103907626 dog          6 a hinged catch that fits into a not… n     noun.arti…
#> 7 102712903 dog          7 metal supports for logs in a firepl… n     noun.arti…
#> 8 202005890 dog          1 go after with the intent to catch    v     verb.moti…
```

## A practical example

For example, you want to know the synonyms of the word “nuance” (very
important for academic writing). You can first search using the lemma
“nuance” with `get_lemmas`.

``` r
res <- get_lemmas("nuance")
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
# get_synonyms() is a wrapper to get_synsetids
get_synsetids(res$synsetid[1])
#> # A tibble: 5 × 6
#>    synsetid lemma      sensenum definition                    pos   lexdomain   
#>       <int> <chr>         <int> <chr>                         <chr> <chr>       
#> 1 106618544 nuance            1 a subtle difference in meani… n     noun.commun…
#> 2 106618544 subtlety          1 a subtle difference in meani… n     noun.commun…
#> 3 106618544 nicety            2 a subtle difference in meani… n     noun.commun…
#> 4 106618544 refinement        4 a subtle difference in meani… n     noun.commun…
#> 5 106618544 shade             4 a subtle difference in meani… n     noun.commun…
```

## Chainablilty

All `get_` functions are chainable by using the magrittr pipe operator.

``` r
c("switch off") %>% get_lemmas(pos = "v") %>% get_synonyms
#> # A tibble: 4 × 6
#>    synsetid lemma      sensenum definition                      pos   lexdomain 
#>       <int> <chr>         <int> <chr>                           <chr> <chr>     
#> 1 201513208 switch off        1 cause to stop operating by dis… v     verb.cont…
#> 2 201513208 turn off          1 cause to stop operating by dis… v     verb.cont…
#> 3 201513208 turn out         11 cause to stop operating by dis… v     verb.cont…
#> 4 201513208 cut              27 cause to stop operating by dis… v     verb.cont…
```

## `get_outdegrees` and its sugars

WordNet is indeed a network. synsetids are connected to each other in a
directed graph. An edge (a synsetid) is linked to another with different
link (edge) types labelling with different `linkid`s. You can look at
all available `linkid`s with the function `get_linktypes`.

``` r
get_linktypes()
#>    linkid                   link recurses
#> 1       1               hypernym        1
#> 2       2                hyponym        1
#> 3       3      instance hypernym        1
#> 4       4       instance hyponym        1
#> 5      11           part holonym        1
#> 6      12           part meronym        1
#> 7      13         member holonym        1
#> 8      14         member meronym        1
#> 9      15      substance holonym        1
#> 10     16      substance meronym        1
#> 11     21                 entail        1
#> 12     23                  cause        1
#> 13     30                antonym        0
#> 14     40                similar        0
#> 15     50                   also        0
#> 16     60              attribute        0
#> 17     70             verb group        0
#> 18     71             participle        0
#> 19     80              pertainym        0
#> 20     81             derivation        0
#> 21     91        domain category        0
#> 22     92 domain member category        0
#> 23     93          domain region        0
#> 24     94   domain member region        0
#> 25     95           domain usage        0
#> 26     96    domain member usage        0
#> 27     97                 domain        0
#> 28     98                 member        0
```

You can find all outdegrees to synsetids using the `get_outdegrees`
function. Please note that it is possible to obtain most of the
outdegrees, except `linkid`s 30 (antonym), 80 (pertainym), 81
(derivation), and 96 (domain member usage).

``` r
## all hypernyms
get_lemmas("dog", pos = "n", sensenum = 1) %>% get_outdegrees(linkid = 1)
#> # A tibble: 4 × 6
#>    synsetid lemma               sensenum definition              pos   lexdomain
#>       <int> <chr>                  <int> <chr>                   <chr> <chr>    
#> 1 102085998 canid                      1 any of various fissipe… n     noun.ani…
#> 2 102085998 canine                     2 any of various fissipe… n     noun.ani…
#> 3 101320032 domestic animal            1 any of various animals… n     noun.ani…
#> 4 101320032 domesticated animal        1 any of various animals… n     noun.ani…
```

``` r
## all hyponymes
get_lemmas("dog", pos = "n", sensenum = 1) %>% get_outdegrees(linkid = 2)
#> # A tibble: 33 × 6
#>     synsetid lemma            sensenum definition                pos   lexdomain
#>        <int> <chr>               <int> <chr>                     <chr> <chr>    
#>  1 102087384 barker                  2 informal terms for dogs   n     noun.ani…
#>  2 102113458 basenji                 1 small smooth-haired bree… n     noun.ani…
#>  3 102115149 belgian griffon         1 breed of various very sm… n     noun.ani…
#>  4 102087384 bow-wow                 2 informal terms for dogs   n     noun.ani…
#>  5 102115149 brussels griffon        1 breed of various very sm… n     noun.ani…
#>  6 102112993 carriage dog            1 a large breed having a s… n     noun.ani…
#>  7 102112993 coach dog               1 a large breed having a s… n     noun.ani…
#>  8 102115478 corgi                   1 either of two Welsh bree… n     noun.ani…
#>  9 102087513 cur                     1 an inferior dog or one o… n     noun.ani…
#> 10 102112993 dalmatian               2 a large breed having a s… n     noun.ani…
#> # … with 23 more rows
```

`sehrnett` provides several syntactic sugars as `get_` functions. For
example:

``` r
## all hyponymes
get_lemmas("dog", pos = "n", sensenum = 1) %>% get_hyponyms()
#> # A tibble: 33 × 6
#>     synsetid lemma            sensenum definition                pos   lexdomain
#>        <int> <chr>               <int> <chr>                     <chr> <chr>    
#>  1 102087384 barker                  2 informal terms for dogs   n     noun.ani…
#>  2 102113458 basenji                 1 small smooth-haired bree… n     noun.ani…
#>  3 102115149 belgian griffon         1 breed of various very sm… n     noun.ani…
#>  4 102087384 bow-wow                 2 informal terms for dogs   n     noun.ani…
#>  5 102115149 brussels griffon        1 breed of various very sm… n     noun.ani…
#>  6 102112993 carriage dog            1 a large breed having a s… n     noun.ani…
#>  7 102112993 coach dog               1 a large breed having a s… n     noun.ani…
#>  8 102115478 corgi                   1 either of two Welsh bree… n     noun.ani…
#>  9 102087513 cur                     1 an inferior dog or one o… n     noun.ani…
#> 10 102112993 dalmatian               2 a large breed having a s… n     noun.ani…
#> # … with 23 more rows
```
