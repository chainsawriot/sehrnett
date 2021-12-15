.download <- function() {
    if (file.exists(system.file("sqlite-31.db", package = "sehrnett"))) {
        ## No need to do anything
        return(invisible(TRUE))
    }
    message("DB doesn't exist. Attempting to download it from the Internet.")
    message("Make sure you agree with the WordNet License.")
    temploc <- tempfile("sqlite-31.db.zip")
    utils::download.file("http://downloads.sourceforge.net/project/wnsql/wnsql3/sqlite/3.1/sqlite-31.db.zip?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fwnsql%2Ffiles%2Fwnsql3%2Fsqlite%2F3.1%2Fsqlite-31.db.zip%2Fdownload&ts=1409711250&use_mirror=iweb", temploc, quiet = FALSE, mode = "wb")
    utils::unzip(temploc, files = c("sqlite-31.db"), exdir = system.file(package = "sehrnett"))
    unlink(temploc)
    invisible(TRUE)
}

.delete <- function() {
    if (!file.exists(system.file("sqlite-31.db", package = "sehrnett"))) {
        return(invisible(FALSE))
    }
    unlink(system.file("sqlite-31.db", package = "sehrnett"))
    return(invisible(TRUE))
}

.create_con <- function() {
    .download()
    return(DBI::dbConnect(RSQLite::SQLite(), system.file("sqlite-31.db", package = "sehrnett")))
}
