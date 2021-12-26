## All examples in README

test_that("readme: very nice", {
    x <- get_lemmas(c("very", "nice"))
    expect_true("sehrnett" %in% class(x))
    expect_equal(nrow(x), 10)
})

test_that("readme: nice", {
    x <- get_lemmas("nice")
    expect_true("sehrnett" %in% class(x))
    expect_equal(nrow(x), 6)
})

test_that("readme: nice.n", {
    x <- get_lemmas("nice", pos = "n")
    expect_true("sehrnett" %in% class(x))
    expect_equal(nrow(x), 1)
})

test_that("readme: dog", {
    x <- get_lemmas("dog")
    expect_true("sehrnett" %in% class(x))
    expect_equal(nrow(x), 8)
    expect_true(any(grepl("informal term for a man", x$definition)))
})

test_that("readme: king.n.10", {
    x <- get_lemmas("king.n.10")
    expect_true("sehrnett" %in% class(x))
    expect_equal(nrow(x), 1)
    expect_true(103623310 %in% x$synsetid)
})

test_that("lemma: ate ducking", {
    x <- get_lemmas(c("ate", "ducking"), pos = "v")
    expect_true("sehrnett" %in% class(x))
    expect_true("eat" %in% x$lemma)
    expect_true("duck" %in% x$lemma)
})

test_that("lemma: loci lemmata boxesful", {
    x <- get_lemmas(c("loci", "lemmata", "boxesful"), pos = "n")
    expect_true("sehrnett" %in% class(x))
    expect_true("locus" %in% x$lemma)
    expect_true("lemma" %in% x$lemma)
    expect_true("boxful" %in% x$lemma)
})

test_that("lemma: nicest stronger", {
    x <- get_lemmas(c("nicest", "stronger"), pos = "a")
    expect_true("sehrnett" %in% class(x))
    expect_true("nice" %in% x$lemma)
    expect_true("strong" %in% x$lemma)
})

test_that("nuance", {
    res <- get_lemmas("nuance")
    expect_true("sehrnett" %in% class(res))
    expect_equal(nrow(res), 1)
    x <- get_synsetids(res$synsetid[1])
    expect_true("sehrnett" %in% class(x))
    expect_equal(nrow(x), 5)
})

test_that("chain", {
    c("switch off") %>% get_lemmas(pos = "v") %>% get_synonyms -> x
    expect_true("sehrnett" %in% class(x))
    expect_equal(nrow(x), 4)
})

test_that("get_outdegrees", {
    expect_false("sehrnett" %in% list_linktypes())
    expect_equal(nrow(list_linktypes()), 28)
    x1 <- get_lemmas("dog", pos = "n", sensenum = 1) %>% get_outdegrees(linkid = 1)
    x2 <- get_lemmas("dog", pos = "n", sensenum = 1) %>% get_outdegrees(linkid = 2)
    x3 <- get_lemmas("nice", pos = "a", sensenum = 1) %>% get_outdegrees(linkid = 30)
    expect_true("sehrnett" %in% class(x1))
    expect_true("sehrnett" %in% class(x2))
    expect_true("sehrnett" %in% class(x3))
    expect_true("canine" %in% x1$lemma)
    expect_true("corgi" %in% x2$lemma)
    expect_true("nasty" %in% x3$lemma)
})

test_that("sugar", {
    x1 <- get_lemmas("dog", pos = "n", sensenum = 1) %>% get_hyponyms()
    x2 <- get_lemmas("nice", pos = "a", sensenum = 1) %>% get_antonyms()
    x3 <- get_lemmas("nice", pos = "a", sensenum = 1) %>% get_derivatives()
    expect_true("sehrnett" %in% class(x1))
    expect_true("sehrnett" %in% class(x2))
    expect_true("sehrnett" %in% class(x3))
    expect_true("corgi" %in% x1$lemma)
    expect_true("nasty" %in% x2$lemma)
    expect_true("niceness" %in% x3$lemma)
})
