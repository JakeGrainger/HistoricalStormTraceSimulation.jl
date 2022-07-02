module HistoricalStormTraceSimulation

using ProgressMeter, Distances, Interpolations, DataFrames, Statistics, Optim

include("rescalemethods.jl")
include("tracesampling.jl")
include("frontend.jl")
include("tracescore.jl")
include("crossvalidation.jl")

export sampletraces, dataframes2storms
export RescaleMaxChangeMin, RescaleMean, RescaleMeanCircularDeg, RescaleIdentity, RescaleMaxPreserveMin
export expected_score, conditional_expected_score, find_best_distance, MarginalTraceScore
export StormTrace, StormHistory, nvariables
export LinearInterpolation, CubicSplineInterpolation # reexported

end
