module HistoricalStormTraceSimulation

using ProgressMeter, Distances, Interpolations, DataFrames, Statistics

include("rescalemethods.jl")
include("tracesampling.jl")
include("frontend.jl")
include("tracescore.jl")
include("crossvalidation.jl")

export sampletraces, dataframes2storms
export RescaleMaxChangeMin, RescaleMean, RescaleIdentity, RescaleMaxPreserveMin

end
