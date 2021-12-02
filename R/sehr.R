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
    output <- tibble::as_tibble(DBI::dbFetch(res))
    DBI::dbClearResult(res)
    class(output) <- append("sehrnett", class(output))
    return(output)
}

#' Search for Synset IDs in WordNet
#'
#' Search for Synset ID(s) in WordNet
#' @param x character, one or more Synset IDs to be searched
#' @return a data frame containing search result
#' @export
get_synsetids <- function(x = c("301590922", "108957024")) {
    if ("sehrnett" %in% class(x)) {
        synsetid <- unique(x$synsetid)
    } else {
        synsetid <- x
    }
    q <- "SELECT s.synsetid AS synsetid, s.lemma as lemma, s.sensenum as sensenum, s.definition AS definition, s.pos AS pos, l.lexdomainname AS lexdomain FROM wordsXsensesXsynsets AS s LEFT JOIN lexdomains AS l ON l.lexdomainid = s.lexdomainid WHERE s.synsetid = $ssynsetid"
    params <- list(ssynsetid = synsetid)
    .fetch_q(q, params)
}

#' @rdname get_synsetids
#' @export
get_synonyms <- function(x) {
    get_synsetids(x)
}

#' Search For Lemmas in WordNet
#'
#' Search for lemma(s) in WordNet.
#' @param x character, one or more lemmas to be searched
#' @param pos character, a vector of part-of-speech labels: "n": Noun, "v": Verb, "a": Adjective, "s": Adjective satellite, "r": Adverb
#' @return a data frame containing search result
#' @export
get_lemmas <- function(x = c("very", "nice"), pos = c("n", "v", "a", "s", "r")) {
    if (any(!pos %in% c("n", "v", "a", "s", "r"))) {
        stop("Unkown pos.")
    }
    if ("sehrnett" %in% class(x)) {
        lemma <- unique(x$lemma)
    } else {
        lemma <- x
    }
    q <- "SELECT s.synsetid AS synsetid, s.lemma as lemma, s.sensenum as sensenum, s.definition AS definition, s.pos AS pos, l.lexdomainname AS lexdomain FROM wordsXsensesXsynsets AS s LEFT JOIN lexdomains AS l ON l.lexdomainid = s.lexdomainid WHERE s.lemma = $slemma ORDER BY s.pos, s.sensenum"
    params <- list(slemma = lemma)
    output <- .fetch_q(q, params)
    output <- output[output$pos %in% pos,]
    return(output)
}
