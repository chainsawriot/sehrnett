#' @importFrom dplyr bind_rows

nett_con <- NULL
.onLoad <- function(libname, pkgname) {
    download_wordnet()
    nett_con <<- .create_con()
}

.onUnload <- function(libname, pkgname) {
    if (!is.null(nett_con)) {
        DBI::dbDisconnect(nett_con)
    }
}

.eg <- function(...) {
    z <- expand.grid(...)
    lapply(z, as.character)
}

.fetch_q <- function(q, params) {
    res <- DBI::dbSendQuery(nett_con, q)
    DBI::dbBind(res, params)
    output <- tibble::as_tibble(DBI::dbFetch(res))
    DBI::dbClearResult(res)
    class(output) <- append("sehrnett", class(output))
    return(unique(output))
}

#' Search for Synset IDs in WordNet
#'
#' Search for Synset ID(s) in WordNet
#' @param x character, one or more Synset IDs to be searched, or a data.frame result from another `get_` function
#' @inherit get_lemmas return
#' @export
#' @examples
#' \donttest{
#' if (interactive()) {
#'   get_synsetids("106618544")
#' }
#' }
get_synsetids <- function(x = c("301590922", "108957024")) {
    if ("sehrnett" %in% class(x)) {
        synsetid <- unique(x$synsetid)
    } else {
        synsetid <- x
    }
    q <- "SELECT s.synsetid AS synsetid, s.lemma as lemma, s.sensenum as sensenum, s.definition AS definition, s.pos AS pos, l.lexdomainname AS lexdomain FROM wordsXsensesXsynsets AS s LEFT JOIN lexdomains AS l ON l.lexdomainid = s.lexdomainid WHERE s.synsetid = $ssynsetid ORDER BY s.pos, s.sensenum"
    params <- .eg(ssynsetid = synsetid)
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
#' @param x character, one or more lemmas to be searched; it can also be a data.frame result from another `get_` functions, but it doesn't make a lot of sense. Alternatively, you can also use the so-called dot notation ("lemma.pos.sensenum") to quickly search for an exact word sense. For example, "king.n.10" is the lemma of "king", which is a noun with the 10th word sense, i.e. king, the chess piece. When using this dot notation, the `lemmatize` parameter is set to `FALSE`.
#' @param pos character, a vector of part-of-speech labels: "n": Noun, "v": Verb, "a": Adjective, "s": Adjective satellite, "r": Adverb
#' @param sensenum integer, if supplied, only those sensenum are selected.
#' @param lemmatize logical, whether to lemmatize the `x` before making query. This is ignored if 1) `pos` has more than one element, 2) `x` contains collocations or hyphenation.
#' @return a data frame containing search result
#' @export
#' @examples
#' \donttest{
#' if (interactive()) {
#' get_lemmas("king.n.10")
#' }
#' }
get_lemmas <- function(x = c("very", "nice"), pos = c("n", "v", "a", "s", "r"), sensenum, lemmatize = TRUE) {
    if (is.vector(x)) {
        if (any(grepl("\\.", x))) {
            if (length(x) != 1) {
                stop("Can only support one query at a time with the dot notation.")
            }
            splitted_x <- strsplit(x, "\\.")[[1]]
            x <- splitted_x[1]
            if (length(splitted_x) >= 2) {
                pos <- splitted_x[2]
            }
            if (length(splitted_x) == 3) {
                sensenum <- splitted_x[3]
            }
            lemmatize <- FALSE
        }
    }
    if (any(!pos %in% c("n", "v", "a", "s", "r"))) {
        stop("Unknown pos.")
    }
    if ("sehrnett" %in% class(x)) {
        lemma <- unique(x$lemma)
        lemmatize <- FALSE
    } else {
        lemma <- tolower(x)
    }
    if (length(pos) > 1) {
        lemmatize <- FALSE
    }
    if (any(grepl("[ \\-]", x))) {
        lemmatize <- FALSE
    }
    if (lemmatize) {
        return(purrr::map2_dfr(.x = x, .y = pos, .lemmatize))
    }
    q <- "SELECT s.synsetid AS synsetid, s.lemma as lemma, s.sensenum as sensenum, s.definition AS definition, s.pos AS pos, l.lexdomainname AS lexdomain FROM wordsXsensesXsynsets AS s LEFT JOIN lexdomains AS l ON l.lexdomainid = s.lexdomainid WHERE s.lemma = $slemma ORDER BY s.pos, s.sensenum"
    params <- .eg(slemma = lemma)
    output <- .fetch_q(q, params)
    output <- output[output$pos %in% pos,]
    if (!missing(sensenum)) {
        output <- output[output$sensenum %in% sensenum, ]
    }
    return(output)
}

#' Get outdegrees
#'
#' Search for outdegrees based on linkid. Various sugars are also provided with different default linkids.
#' 
#' @inheritParams get_synsetids
#' @inherit get_lemmas return
#' @param linkid a vector of numeric linkids. Use [list_linktypes()] to obtain a full list.
#' @export
#' @examples
#' \donttest{
#' if (interactive()) {
#' get_lemmas("dog", pos = "n", sensenum = 1) %>% get_outdegrees(linkid = 1)
#' get_lemmas("dog", pos = "n", sensenum = 1) %>% get_hyponyms()
#' get_lemmas("nice", pos = "a", sensenum = 1) %>% get_antonyms()
#' }
#' }
get_outdegrees <- function(x, linkid = 1) {
    if (any(purrr::map_lgl(linkid, ~. %in% c(30, 80, 81, 96)))) {
        return(.get_sls_outdegrees(x = x, linkid = linkid))
    }
    if ("sehrnett" %in% class(x)) {
        synsetid <- unique(x$synsetid)
    } else {
        synsetid <- x
    }
    q <- "SELECT s.synsetid AS synsetid, s.lemma as lemma, s.sensenum as sensenum, s.definition AS definition, s.pos AS pos, l.lexdomainname AS lexdomain FROM wordsXsensesXsynsets AS s LEFT JOIN semlinks AS s2 ON s.synsetid = s2.synset2id LEFT JOIN lexdomains AS l ON l.lexdomainid = s.lexdomainid where synset1id = $ssynsetid AND linkid = $linkid"
    params <- .eg(ssynsetid = synsetid, linkid = linkid)
    .fetch_q(q, params)
}

#' @rdname get_outdegrees
#' @export
get_hypernyms <- function(x) {
    get_outdegrees(x, linkid = c(1, 3))
}

#' @rdname get_outdegrees
#' @export
get_hyponyms <- function(x) {
    get_outdegrees(x, linkid = c(2, 4))
}

#' @rdname get_outdegrees
#' @export
get_holonyms <- function(x) {
    get_outdegrees(x, linkid = c(11, 13, 15))
}

#' @rdname get_outdegrees
#' @export
get_meronyms <- function(x) {
    get_outdegrees(x, linkid = c(12, 14, 16))
}

#' @rdname get_outdegrees
#' @export
get_causes <- function(x) {
    get_outdegrees(x, linkid = 23)
}

.get_sls_outdegrees <- function(x, linkid) {
    if (! "sehrnett" %in% class(x)) {
        stop("For this query, the input `x` must be a result from a get_* function.", call. = FALSE)
    }
    if (length(linkid) > 1) {
        stop("For this query, linkid can only have exactly 1 element.", call. = FALSE)
    }
    subx <- unique(x[, c("synsetid", "lemma")])
    q <- "SELECT l.dsynsetid as synsetid, dw.lemma AS lemma, l.dsensenum as sensenum, l.ddefinition as definition, l.dpos as pos, lex.lexdomainname as lexdomain FROM sensesXlexlinksXsenses AS l LEFT JOIN words AS sw ON l.swordid = sw.wordid LEFT JOIN words AS dw ON l.dwordid = dw.wordid LEFT JOIN lexdomains AS lex ON lex.lexdomainid = l.dlexdomainid WHERE sw.lemma = $slemma AND l.ssynsetid = $ssynsetid AND linkid = $linkid ORDER BY ssensenum"
    params <- .eg(ssynsetid = subx$synsetid, slemma = subx$lemma, linkid = linkid)
    .fetch_q(q, params)
}

#' @rdname get_outdegrees
#' @export
get_antonyms <- function(x) {
    get_outdegrees(x, linkid = 30)
}

#' @rdname get_outdegrees
#' @export
get_derivatives <- function(x) {
    get_outdegrees(x, linkid = 81)
}

#' @rdname get_outdegrees
#' @export
get_pertainyms <- function(x) {
    get_outdegrees(x, linkid = 80)
}

#' @rdname get_outdegrees
#' @export
list_linktypes <- function() {
    DBI::dbGetQuery(nett_con, "select * from linktypes order by linkid")
}
