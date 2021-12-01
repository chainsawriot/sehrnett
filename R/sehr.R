nett_con <- NULL
.onLoad <- function(libname, pkgname) {
    .download()
    nett_con <<- DBI::dbConnect(RSQLite::SQLite(), system.file("sqlite-31.db", package = "sehrnett"))
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

#' @export
search_lemma <- function(lemma = "nice", pos = NULL, sensenum = NULL) {
    q <- glue::glue("SELECT s.synsetid AS synsetid, s.lemma as lemma, s.sensenum as sensenum, s.definition AS definition, s.pos AS pos, l.lexdomainname AS lexdomain FROM wordsXsensesXsynsets AS s LEFT JOIN lexdomains AS l ON l.lexdomainid = s.lexdomainid WHERE s.lemma = '{s.lemma}'{pos_clause}{sensenum_clause} ORDER BY s.pos, s.sensenum", s.lemma = lemma, pos_clause = .gen_and_clause(pos, "s.pos"), sensenum_clause = .gen_and_clause(sensenum, "s.sensenum"))
    DBI::dbGetQuery(nett_con, q)
}

#' @export
search_synsetid <- function(synsetid = "301590922") {
    q <- glue::glue("SELECT s.synsetid AS synsetid, s.lemma as lemma, s.sensenum as sensenum, s.definition AS definition, s.pos AS pos, l.lexdomainname AS lexdomain FROM wordsXsensesXsynsets AS s LEFT JOIN lexdomains AS l ON l.lexdomainid = s.lexdomainid WHERE s.synsetid = '{synsetid}'", synsetid = synsetid)
    DBI::dbGetQuery(nett_con, q)    
}

#' Search For Lemma in WordNet
#' 
## search_lemma <- function(lemma = c("very", "nice"), pos = c("n", "v", "a", "s", "r")) {
##     res <- DBI::dbSendQuery(nett_con, "SELECT s.synsetid AS synsetid, s.lemma as lemma, s.sensenum as sensenum, s.definition AS definition, s.pos AS pos, l.lexdomainname AS lexdomain FROM wordsXsensesXsynsets AS s LEFT JOIN lexdomains AS l ON l.lexdomainid = s.lexdomainid WHERE s.lemma = $slemma ORDER BY s.pos, s.sensenum")
##     DBI::dbBind(res, list(slemma = lemma))
##     output <- DBI::dbFetch(res)
##     DBI::dbClearResult(res)
##     output <- output[output$pos %in% pos,]
##     return(output)
## }
