###

test_that("Some expected behaviors of get_outdegrees", {
    x <- get_lemmas("bad")$synsetid[1]
    expect_error(get_outdegrees(x, 30)) ## 30 is using .get_sls_outdegrees
    expect_error(get_outdegrees(x, 40), NA)
})

test_that("get_hypernyms", {
    x <- get_lemmas("king", pos = "n", sensenum = "10", lemmatize = FALSE) %>% get_hypernyms()
    expect_true("chess piece" %in% x$lemma)
})

test_that("get_hyponyms", {
    x <- get_lemmas("american", pos = "n", sensenum = "3", lemmatize = FALSE) %>% get_hyponyms()
    expect_true("latin american" %in% x$lemma)
})

test_that("get_holonyms", {
    x <- get_lemmas("ship", pos = "n", sensenum = "1", lemmatize = FALSE) %>% get_holonyms()
    expect_true("cargo deck" %in% x$lemma)    
})

test_that("get_meronyms", {
    x <- get_lemmas("finger", pos = "n", sensenum = "1", lemmatize = FALSE) %>% get_meronyms()
    expect_true("hand" %in% x$lemma)
})

test_that("get_causes", {
    x <- get_lemmas("leak", pos = "v", sensenum = "1", lemmatize = FALSE) %>% get_causes()
    expect_true("break" %in% x$lemma)
})

test_that("get_antonyms", {
    x <- get_lemmas("white", pos = "a") %>% get_antonyms()
    expect_true("black" %in% x$lemma)
    x <- get_lemmas("high", pos = "a") %>% get_antonyms()
    expect_true("low" %in% x$lemma)    
})

test_that("get_derivatives", {
    x <- get_lemmas("clear", pos = "a") %>% get_derivatives()
    expect_true("clarity" %in% x$lemma)
})

test_that("get_pertainyms", {
    x <- get_lemmas("hawaiian") %>% get_pertainyms()
    expect_true("hawaii" %in% x$lemma)
})
