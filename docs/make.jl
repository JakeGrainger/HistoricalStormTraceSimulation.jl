using HistoricalStormTraceSimulation
using Documenter

DocMeta.setdocmeta!(HistoricalStormTraceSimulation, :DocTestSetup, :(using HistoricalStormTraceSimulation); recursive=true)

makedocs(;
    modules=[HistoricalStormTraceSimulation],
    authors="Jake Grainger <j.p.grainger2@outlook.com> and contributors",
    repo="https://github.com/JakeGrainger/HistoricalStormTraceSimulation.jl/blob/{commit}{path}#{line}",
    sitename="HistoricalStormTraceSimulation.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://JakeGrainger.github.io/HistoricalStormTraceSimulation.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
        "Getting Started" => "basics.md",
        "Internal types" => "types.md",
        "Trace Sampling" => "sampling.md",
        "Rescale Methods" => "rescalemethods.md",
        "Choosing Summary Metrics" => "tracescore.md",
        "Index" => "docstrings.md"
    ],
)

deploydocs(;
    repo="github.com/JakeGrainger/HistoricalStormTraceSimulation.jl.git",
    devbranch="main",
)
