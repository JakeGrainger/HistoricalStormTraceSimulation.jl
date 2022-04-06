module HistoricalStormTraceSimulation

using ProgressMeter, Distances

include("rescalemethods.jl")
include("tracesampling.jl")
include("frontend.jl")

export sampletraces

end
