### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ 428feade-85ec-11eb-19fd-2b2454890067
using PlutoUI

# ╔═╡ b441124a-8b6e-11eb-3ad6-3d02efce2ddb
md"## Homework no. 3 (bigram search)"

# ╔═╡ 908af3ea-85ed-11eb-154e-6df780823edf
md"
### Input field
It's simply a binding to HTML's input field, the result will be stored in `query`.
"

# ╔═╡ 4b227720-85ec-11eb-36f4-194c1562abba
@bind query TextField()

# ╔═╡ 1ec26966-85f0-11eb-2dfe-77887578558a
md"String conversion to a list:"

# ╔═╡ af7c791e-85ec-11eb-0b7f-b99f7a97ef85
keywords = query |> split

# ╔═╡ 317ea092-85f0-11eb-3e9c-313da3c6e8bc
md"
### Our bigram
I simply get the overlaping partitions of pairs and add them to the original keyword list. I join the pairs together with a variable amount whitespace (for use with regex), so that the items would be more tolerant to variable amount of spaces, yielding better results."

# ╔═╡ 7a0ccb30-8637-11eb-0b76-0536f95326a8
bigrams = []

# ╔═╡ f5c8fbe4-85ed-11eb-3c26-a14eff94f47a
for i = eachindex(keywords)
	try
		push!(bigrams, join(keywords[i:i+1], "\\s+"))
	catch BoundsError
	end
end

# ╔═╡ 8444069c-85f1-11eb-349b-1dcffb41ca12
md"
### Homework 2 code
I've already explained this part, the difference now is that we also count the number of bigrams by creating 2 *Regex* objects (one of keywords and one of bigrams) and trasposing them over `count`. Our result is `Pair` objects with `String` type on one side, and a `Tuple` type on the other. The tuple contains the keyword and the bigram match count (we need them seperate, because bigrams will have a higher significance than keywords).
 "

# ╔═╡ e5441f48-85ec-11eb-21be-fd952b3213f0
begin
	pages = [i => open(f -> read(f, String), "pages/$i") for i = readdir("pages")]

	re = filter(x -> x != r"", @. Regex(join((keywords, bigrams), "|")))
	results = [i => count.(re, x) for (i, x) = pages]
end

# ╔═╡ 09cb5944-85f2-11eb-255d-df7bc85c6f76
md"
### Results
The ordering here might seem wrong at first sight, but this is ordered by giving bigram results `100` times more significance.
"

# ╔═╡ 4324da36-8b6e-11eb-0932-e3b9d690277e
isempty(first(results).second) ? "No results found" : begin
	res2 = sort(results, by = x -> x.second[end] * 100 + x.second[1], rev = true)
	[i => sum(x) for (i, x) = res2]
end

# ╔═╡ Cell order:
# ╟─b441124a-8b6e-11eb-3ad6-3d02efce2ddb
# ╠═428feade-85ec-11eb-19fd-2b2454890067
# ╟─908af3ea-85ed-11eb-154e-6df780823edf
# ╠═4b227720-85ec-11eb-36f4-194c1562abba
# ╟─1ec26966-85f0-11eb-2dfe-77887578558a
# ╠═af7c791e-85ec-11eb-0b7f-b99f7a97ef85
# ╟─317ea092-85f0-11eb-3e9c-313da3c6e8bc
# ╠═7a0ccb30-8637-11eb-0b76-0536f95326a8
# ╠═f5c8fbe4-85ed-11eb-3c26-a14eff94f47a
# ╟─8444069c-85f1-11eb-349b-1dcffb41ca12
# ╠═e5441f48-85ec-11eb-21be-fd952b3213f0
# ╟─09cb5944-85f2-11eb-255d-df7bc85c6f76
# ╠═4324da36-8b6e-11eb-0932-e3b9d690277e
