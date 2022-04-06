import HistoricalStormTraceSimulation: StormHistory, TraceSampler
@testset "tracesampling" begin
    @testset "StormHistory" begin
        @test_throws DimensionMismatch StormHistory(ones(10),ones(9)) # throw error if not same number of summaries as traces
    end

    @testset "TraceSampler" begin
        @test_throws DimensionMismatch TraceSampler(Euclidean(),1:10,rand(10),rand(9))        
    end
end