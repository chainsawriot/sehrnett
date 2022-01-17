library(testthat)
library(sehrnett)

if (identical(Sys.getenv("NOT_CRAN", unset = "true"), "true")) {
    tryCatch({
        sehrnett::download_wordnet(debug = TRUE)
    }, error = function(e) {
        message("Unable to download the database for testing. Skipping.")
    })
    if (file.exists(system.file("sqlite-31.db", package = "sehrnett"))){
        test_check("sehrnett")
    }
}
