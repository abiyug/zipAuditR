tmp <- tempdir()
writeLines(letters[1:10], file.path(tmp, "a.txt"))
writeLines(letters[5:15], file.path(tmp, "b.txt"))
writeLines(rep("x", 500),   file.path(tmp, "big.txt"))
writeLines(rep("x", 500),   file.path(tmp, "big-copy.txt"))

utils::zip("inst/extdata/sample1.zip", file.path(tmp, c("a.txt", "big.txt")),       flags = "-j")
utils::zip("inst/extdata/sample2.zip", file.path(tmp, c("b.txt", "big-copy.txt")), flags = "-j")
