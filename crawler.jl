using HTTP

content = open(f -> read(f, String), "/home/agent/Projects/Papers/search-engines.md")
links = [i.captures[1] for i = eachmatch(r"\((https?:\/\/.+)\)", content) |> collect]

for (i, x) in enumerate(links)
	r = HTTP.get(x)
	page = replace(
		r.body |> String,
		r"(?:<script>[^>]*<\/script>|<[^>]*>)"ms => ""
	)
	open(f -> write(f, page), "pages/$i.txt", "w+")
end
