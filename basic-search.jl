pages = [i => open(f -> read(f, String), "pages/$i") for i = readdir("pages")]
re = Regex("(?:$(join(ARGS, "|"))|$(join(ARGS, "\\s+")))")
results = [i => count(re, x) for (i, x) = pages]
println.(sort(results, by = x -> x.second, rev = true))

