library(testthat)
library(sehrnett)

if (identical(Sys.getenv("NOT_CRAN", unset = "true"), "true")) {
    sehrnett::download_wordnet(debug = TRUE)
    test_check("sehrnett")
}

## recycle the test cases of node-wordnet-magic
## https://github.com/Planeshifter/node-wordnet-magic/tree/master/examples

