
## library(DBI)
nett_con <- NULL
.onLoad <- function(libname, pkgname) {
    nett_con <<- DBI::dbConnect(RSQLite::SQLite(), system.file("sqlite-31_snapshot.db", package = "sehrnett"))
}

.onUnload <- function(libname, pkgname) {
    DBI::dbDisconnect(nett_con)
}

.gen_and_clause <- function(x, what) {
    if (is.null(x)) {
        return("")
    }
    return(glue::glue(" AND {what} = '{x}'", what = what, x = x))
}

search_lemma <- function(lemma = "nice", pos = NULL, sensenum = NULL) {
    q <- glue::glue("SELECT s.synsetid AS synsetid, s.lemma as lemma, s.sensenum as sensenum, s.definition AS definition, s.pos AS pos, l.lexdomainname AS lexdomain FROM wordsXsensesXsynsets AS s LEFT JOIN lexdomains AS l ON l.lexdomainid = s.lexdomainid WHERE s.lemma = '{s.lemma}'{pos_clause}{sensenum_clause} ORDER BY s.pos, s.sensenum", s.lemma = lemma, pos_clause = .gen_and_clause(pos, "s.pos"), sensenum_clause = .gen_and_clause(sensenum, "s.sensenum"))
    DBI::dbGetQuery(nett_con, q)
}

## "dog.n.1"

## q <- "SELECT s.synsetid AS synsetid, s.definition AS definition, s.pos AS pos, l.lexdomainname AS lexdomain FROM wordsXsensesXsynsets AS s LEFT JOIN lexdomains AS l ON l.lexdomainid = s.lexdomainid WHERE s.pos = 'n' AND s.lemma = 'dog' AND s.sensenum = '1'"

## res <- dbSendQuery(con, q)
## x <- dbFetch(res)
## x$synsetid

## q <- glue::glue("SELECT s.synsetid AS synsetid, s.lemma AS lemma, s.definition AS definition, s.pos AS pos, l.lexdomainname AS lexdomain FROM wordsXsensesXsynsets AS s LEFT JOIN lexdomains AS l ON l.lexdomainid = s.lexdomainid WHERE s.synsetid = {id} ORDER BY s.pos, s.sensenum", id = x$synsetid)

## res <- dbSendQuery(con, q)
## y <- dbFetch(res)
