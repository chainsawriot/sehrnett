test_that("lemmatize", {
    x1 <- get_lemmas("cars", pos = "n")
    x2 <- get_lemmas("cars", pos = "n", lemmatize = TRUE)
    expect_true(all.equal(x1, x2))
    expect_true("car" %in% x1$lemma)
    ## No lemmatize b/c default pos
    x1 <- get_lemmas("cars")
    expect_equal(nrow(x1), 0)
    x1 <- get_lemmas("cars", pos = "n", lemmatize = FALSE)
    expect_equal(nrow(x1), 0)
    x1 <- get_lemmas(c("cars", "dogs"), pos = "n")
    expect_true("car" %in% x1$lemma)
    expect_true("dog" %in% x1$lemma)
    ## adverb will just return the same thing
    x3 <- get_lemmas("greatly", "r", lemmatize = TRUE)
    expect_true("greatly" %in% x3$lemma)
})

test_that("Test cases from node wordnet magic", {
    ## "better" won't resolve to "good"
    expect_false("good" %in% get_lemmas("better", "a")$lemma)
    expect_true("deny" %in% get_lemmas("denied","v")$lemma)
    expect_true("church" %in% get_lemmas("churches","n")$lemma)
    expect_true("structure" %in% get_lemmas("structures","n")$lemma)
    expect_true("walk" %in% get_lemmas("walking", "v")$lemma)
    expect_true("teach" %in% get_lemmas("taught", "v")$lemma)
    expect_equal(character(0), get_lemmas("fruitful", "n")$lemma)
    expect_true("locus" %in% get_lemmas("loci", "n")$lemma)
    expect_true("time" %in% get_lemmas("timed", "v")$lemma)
    expect_true("kiss" %in% get_lemmas("kissed", "v")$lemma)
    expect_true("minion" %in% get_lemmas("minions", "n")$lemma)
})

## more test cases
test_that("More test cases", {
    expect_true("kiss" %in% get_lemmas("kisses", "v")$lemma)
    expect_true("kiss" %in% get_lemmas("kisses", "n")$lemma)
    expect_true("boxful" %in% get_lemmas("boxesful", "n")$lemma)
    expect_true("boxful" %in% get_lemmas("boxfuls", "n")$lemma)
    expect_true("strong" %in% get_lemmas("stronger", "a")$lemma)
    expect_true("strong" %in% get_lemmas("strongest", "a")$lemma)
    expect_true("eat" %in% get_lemmas("eaten", "v")$lemma)    
})
