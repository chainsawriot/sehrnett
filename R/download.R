#' Download And Delete WordNet SQL Database
#'
#' To download the WordNet 3.1 data as a sqlite database. It runs only in an interactive R session. The size of the database is around 500MB. Please make sure you agree with the WordNet License.
#' @param debug a flag for debugging. You should keep it FALSE. (Try at your own risk!)
#' @return TRUE if the database is found. FALSE if there is no database and it is not running in an interactive R session.
#' @export
download_wordnet <- function(debug = FALSE) {
    if (file.exists(system.file("sqlite-31.db", package = "sehrnett"))) {
        ## No need to do anything
        return(invisible(TRUE))
    }
    if (!debug) {
        packageStartupMessage("WordNet SQL DB doesn't exist. Attempting to download it from the Internet.")
        packageStartupMessage("Make sure you agree with the WordNet License.")
        packageStartupMessage("https://wordnet.princeton.edu/license-and-commercial-use")
    }
    if (interactive() && !debug) {
        packageStartupMessage("Press ENTER to agree")
        rubbish <- readline()
    } else if (!interactive() && !debug) {
        packageStartupMessage("Run `download_wordnet()` interactively to download the WordNet database.")
        return(invisible(FALSE))
    }
    temploc <- tempfile("sqlite-31.db.zip")
        utils::download.file("https://downloads.sourceforge.net/project/wnsql/wnsql3/sqlite/3.1/sqlite-31.db.zip?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fwnsql%2Ffiles%2Fwnsql3%2Fsqlite%2F3.1%2Fsqlite-31.db.zip%2Fdownload&ts=1409711250", temploc, quiet = FALSE, mode = "wb")
    
    utils::unzip(temploc, files = c("sqlite-31.db"), exdir = system.file(package = "sehrnett"))
    unlink(temploc)
    return(invisible(TRUE))
}

#' @export
#' @rdname download_wordnet
delete_wordnet <- function() {
    if (!file.exists(system.file("sqlite-31.db", package = "sehrnett"))) {
        return(invisible(FALSE))
    }
    unlink(system.file("sqlite-31.db", package = "sehrnett"))
    return(invisible(TRUE))
}

.create_con <- function() {
    ##download_wordnet()
    if (file.exists(system.file("sqlite-31.db", package = "sehrnett"))) {
        return(DBI::dbConnect(RSQLite::SQLite(), system.file("sqlite-31.db", package = "sehrnett")))
    }
    return(NULL)
}
