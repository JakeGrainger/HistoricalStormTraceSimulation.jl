using HistoricalStormTraceSimulation
using Test

@testset "HistoricalStormTraceSimulation.jl" begin
    include("rescalemethods_test.jl")
    include("tracesampling_test.jl")
end
