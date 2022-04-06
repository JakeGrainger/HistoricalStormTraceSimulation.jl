import HistoricalStormTraceSimulation: StormHistory, TraceSampler, samplehistoricaltrace, rescaletrace
@testset "tracesampling" begin
    @testset "StormHistory" begin
        @test_throws DimensionMismatch StormHistory(ones(10),ones(9)) # throw error if not same number of summaries as traces
    end

    @testset "TraceSampler" begin
        @test_throws DimensionMismatch TraceSampler(Euclidean(),1:10,rand(10),rand(9))        
        @test TraceSampler(Euclidean(),1:50,100) isa TraceSampler
    end

    @testset "samplesingletrace" begin
        history = StormHistory([rand(2) for i in 1:100], [rand(2,3) for i in 1:100])
        summary = rand(2)
        sampler = TraceSampler(Euclidean(),1:50,100)
        
    end

    @testset "samplehistoricaltrace" begin
        history = StormHistory([rand(2) for i in 1:100], [rand(2,3) for i in 1:100])
        summary = rand(2)
        sampler_good = TraceSampler(Euclidean(),1:50,100)
        sampler_bad = TraceSampler(Euclidean(),101:102,100)
        @test_throws ErrorException samplehistoricaltrace(summary,history,sampler_bad)
        trace = samplehistoricaltrace(summary,history,sampler_good)
        @test trace isa Matrix{Float64}
        @test size(trace) == (2,3)
        @test any(t==trace for t in history.traces)
    end

    @testset "rescaletrace" begin
        trace = rescaletrace(rand(3,10),rand(3),(IdentityRescale(),RescaleMaxChangeMin(),RescaleMaxPreserveMin()))
        @test trace isa Matrix{Float64}
        @test size(trace) == (3,10)
    end
end