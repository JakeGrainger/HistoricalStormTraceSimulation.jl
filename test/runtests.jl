using HistoricalStormTraceSimulation
using Test, Distances, DataFrames

@testset "HistoricalStormTraceSimulation.jl" begin
    include("rescalemethods_test.jl")
    include("tracesampling_test.jl")
    include("frontend_test.jl")
    include("metric_test.jl")
end