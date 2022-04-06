import HistoricalStormTraceSimulation: StormHistory, TraceSampler, samplehistoricaltrace, rescaletrace
@testset "tracesampling" begin
    @testset "StormHistory" begin
        @test_throws DimensionMismatch StormHistory([rand(2) for i in 1:3],[rand(2,3) for i in 1:4]) # throw error if not same number of summaries as traces
        @test_throws DimensionMismatch StormHistory([rand(2) for i in 1:3],[rand(2,3) for i in 1:3])
        @test StormHistory([rand(2) for i in 1:3],[rand(4,2) for i in 1:3]) isa StormHistory
    end

    @testset "TraceSampler" begin
        @test_throws DimensionMismatch TraceSampler(Euclidean(),1:10,rand(10),rand(9))        
        @test TraceSampler(Euclidean(),1:50,100) isa TraceSampler
    end

    @testset "samplesingletrace" begin
        history = StormHistory([rand(2) for i in 1:100], [rand(10,2) for i in 1:100])
        summary = rand(2)
        sampler = TraceSampler(Euclidean(),1:50,100)
        
    end

    @testset "samplehistoricaltrace" begin
        history = StormHistory([rand(2) for i in 1:100], [rand(10,2) for i in 1:100])
        summary = rand(2)
        sampler_good = TraceSampler(Euclidean(),1:50,100)
        sampler_bad = TraceSampler(Euclidean(),101:102,100)
        @test_throws ErrorException samplehistoricaltrace(summary,history,sampler_bad)
        trace = samplehistoricaltrace(summary,history,sampler_good)
        @test trace isa Matrix{Float64}
        @test size(trace) == (10,2)
        @test any(t==trace for t in history.traces)
    end

    @testset "rescaletrace" begin
        trace = rescaletrace(rand(10,3),rand(3),(IdentityRescale(),RescaleMaxChangeMin(),RescaleMaxPreserveMin()))
        @test trace isa Matrix{Float64}
        @test size(trace) == (10,3)
    end
end