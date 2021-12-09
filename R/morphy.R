## list https://wordnet.princeton.edu/documentation/morphy7wn
MORPHY_SUBS <- list()
MORPHY_SUBS$n <- list(c("s$", ""),
                      c("ses$", "s"),
                      c("ves$", "f"),
                      c("xes$", "x"),
                      c("zes$", "z"),
                      c("ches$", "ch"),
                      c("shes$", "sh"),
                      c("men$", "man"),
                      c("ies$", "y"))
MORPHY_SUBS$v <- list(c("s$", ""),
                      c("ies$", "y"),
                      c("es$", "e"),
                      c("es$", ""),
                      c("ed$", "e"),
                      c("ed$", ""),
                      c("ing$", "e"),
                      c("ing$", ""))
MORPHY_SUBS$a <- list(c("er$", ""),
                      c("est$", ""),
                      c("er$", "e"),
                      c("est$", "e"))

## a cheap replacement of stringr::str_replace
.str_replace <- function(x, y) {
    gsub(y[1], y[2], x)
}

.lemmatize <- function(x, pos = "n") {
    ## Maybe x is already in the db
    res <- get_lemmas(x = x, pos = pos, lemmatize = FALSE)
    if (nrow(res) > 0) {
        return(res)
    }
    q <- "select lemma from morphology where morph = $morph and pos = $pos"
    params <- .eg(morph = x, pos = pos)
    exceptions <- .fetch_q(q, params)
    if (nrow(exceptions) != 0) {
        return(get_lemmas(x = exceptions$lemma, pos = pos, lemmatize = FALSE))
    }
    if (pos == "n") {
        mor <- MORPHY_SUBS$n
    } else if (pos == "v") {
        mor <- MORPHY_SUBS$v
    } else if (pos == "a") {
        mor <- MORPHY_SUBS$a
    } else {
        return(get_lemmas(x, pos = pos, lemmatize = FALSE))
    }
    if (pos == "n" & grepl("ful$", x)) {
        subx <- .str_replace(x, c("ful$", ""))
        possible_lemmas <- paste0(unique(purrr::map2_chr(subx, mor, .str_replace)), "ful")
    } else {
        possible_lemmas <- unique(purrr::map2_chr(x, mor, .str_replace))
    }
    get_lemmas(x = possible_lemmas, pos = pos, lemmatize = FALSE)
}
