module HistoricalStormTraceSimulation

using ProgressMeter, Distances, Interpolations, DataFrames, Statistics, Optim

include("rescalemethods.jl")
include("tracesampling.jl")
include("frontend.jl")
include("tracescore.jl")
include("crossvalidation.jl")

export sampletraces, dataframes2storms
export RescaleMaxChangeMin, RescaleMean, RescaleIdentity, RescaleMaxPreserveMin
export score_method, find_best_distance

end
