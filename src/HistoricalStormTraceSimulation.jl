module HistoricalStormTraceSimulation

using ProgressMeter, Distances, Interpolations

include("rescalemethods.jl")
include("tracesampling.jl")
include("frontend.jl")

export sampletraces, dataframes2storms

end
