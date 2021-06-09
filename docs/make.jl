using FastLocalCorrelationCoefficients
using Documenter

DocMeta.setdocmeta!(FastLocalCorrelationCoefficients, :DocTestSetup, :(using FastLocalCorrelationCoefficients); recursive=true)

makedocs(;
    modules=[FastLocalCorrelationCoefficients],
    authors="Nikos Pitsianis <nikos@cs.duke.edu>, Dimitris Floros <fcdimitr@ece.auth.gr>, Alexandros-Stavros Iliopoulos <ailiop@mit.edu>, Xiaobai Sun <xiaobai@cs.duke.edu>",
    repo="https://github.com/pitsianis/FastLocalCorrelationCoefficients.jl/blob/{commit}{path}#{line}",
    sitename="FastLocalCorrelationCoefficients.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://pitsianis.github.io/FastLocalCorrelationCoefficients.jl",
        assets=String[],
    ),
    pages=[
      "Home" => "index.md",
      "Where's Waldo?" => "waldo.md",
    ],
)

deploydocs(;
    repo="github.com/pitsianis/FastLocalCorrelationCoefficients.jl",
)
