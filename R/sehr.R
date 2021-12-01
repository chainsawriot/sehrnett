nett_con <- NULL
.onLoad <- function(libname, pkgname) {
    .download()
    nett_con <<- DBI::dbConnect(RSQLite::SQLite(), system.file("sqlite-31.db", package = "sehrnett"))
}

.onUnload <- function(libname, pkgname) {
    DBI::dbDisconnect(nett_con)
}

.fetch_q <- function(q, params) {
    res <- DBI::dbSendQuery(nett_con, q)
    DBI::dbBind(res, params)
    output <- DBI::dbFetch(res)
    DBI::dbClearResult(res)
    return(output)
}

#' Search for Synset ID in WordNet
#'
#' Search for Synset ID(s) in WordNet
#' @param synsetid character, one or more Synset IDs to be searched
#' @return a data frame containing search result
#' @export
search_synsetid <- function(synsetid = c("301590922", "108957024")) {
    q <- "SELECT s.synsetid AS synsetid, s.lemma as lemma, s.sensenum as sensenum, s.definition AS definition, s.pos AS pos, l.lexdomainname AS lexdomain FROM wordsXsensesXsynsets AS s LEFT JOIN lexdomains AS l ON l.lexdomainid = s.lexdomainid WHERE s.synsetid = $ssynsetid"
    params <- list(ssynsetid = synsetid)
    .fetch_q(q, params)
}

#' Search For Lemma in WordNet
#'
#' Search for lemma(s) in WordNet.
#' @param lemma character, one or more lemmas to be searched
#' @param pos character, a vector of part-of-speech labels: "n": Noun, "v": Verb, "a": Adjective, "s": Adjective satellite, "r": Adverb
#' @return a data frame containing search result
#' @export
search_lemma <- function(lemma = c("very", "nice"), pos = c("n", "v", "a", "s", "r")) {
    if (any(!pos %in% c("n", "v", "a", "s", "r"))) {
        stop("Unkown pos.")
    }
    q <- "SELECT s.synsetid AS synsetid, s.lemma as lemma, s.sensenum as sensenum, s.definition AS definition, s.pos AS pos, l.lexdomainname AS lexdomain FROM wordsXsensesXsynsets AS s LEFT JOIN lexdomains AS l ON l.lexdomainid = s.lexdomainid WHERE s.lemma = $slemma ORDER BY s.pos, s.sensenum"
    params <- list(slemma = lemma)
    output <- .fetch_q(q, params)
    output <- output[output$pos %in% pos,]
    return(output)
}
