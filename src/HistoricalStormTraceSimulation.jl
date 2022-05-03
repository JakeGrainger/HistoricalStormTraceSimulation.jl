module HistoricalStormTraceSimulation

using ProgressMeter, Distances, Interpolations, DataFrames, Statistics

include("rescalemethods.jl")
include("tracesampling.jl")
include("frontend.jl")

export sampletraces, dataframes2storms

end
