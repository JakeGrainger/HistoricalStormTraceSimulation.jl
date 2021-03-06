import HistoricalStormTraceSimulation: StormHistory, 
    TraceSampler, samplehistoricaltrace, rescaletrace!, StormTrace, nvariables, interpolatetrace
@testset "tracesampling" begin
    @testset "StormHistory" begin
        @test_throws DimensionMismatch StormHistory([rand(4) for i in 1:3],[StormTrace(rand(10,3),1:10) for i in 1:4]) # throw error if not same number of summaries as traces
        @test_throws DimensionMismatch StormHistory([rand(3) for i in 1:3],[StormTrace(rand(10,3),1:10) for i in 1:3])
        @test StormHistory([rand(4) for i in 1:3],[StormTrace(rand(10,3),1:10) for i in 1:3]) isa StormHistory
    end

    @testset "TraceSampler" begin
        @test_throws DimensionMismatch TraceSampler(Euclidean(),1:10,rand(10),rand(9))        
        @test TraceSampler(Euclidean(),1:50,100) isa TraceSampler
    end

    @testset "samplesingletrace" begin
        history = StormHistory([rand(3) for i in 1:100], [StormTrace(rand(10,2),1:10) for i in 1:100])
        summary = rand(3)
        sampler = TraceSampler(Euclidean(),1:50,100)
        trace = samplehistoricaltrace(summary,history,sampler)
        @test trace isa StormTrace
    end

    @testset "interpolatetrace" begin
        trace = interpolatetrace(StormTrace(rand(11,2),0:10),0.5)
        @test trace.time == 0:0.5:10
        trace = interpolatetrace(StormTrace(rand(11,2),range(0,10.000000001,length=11)),0.5)
        @test trace.time == 0:0.5:10
        trace = interpolatetrace(StormTrace(rand(11,2),range(0, 9.999999999,length=11)),0.5)
        @test trace.time == 0:0.5:10
        trace = interpolatetrace(StormTrace(rand(11,2),0:10),0.5,CubicSplineInterpolation)
        @test trace.time == 0:0.5:10
    end

    @testset "samplehistoricaltrace" begin
        history = StormHistory([rand(3) for i in 1:100], [StormTrace(rand(10,2),1:10) for i in 1:100])
        summary = rand(3)
        sampler_good = TraceSampler(Euclidean(),1:50,100)
        sampler_bad = TraceSampler(Euclidean(),101:102,100)
        @test_throws ErrorException samplehistoricaltrace(summary,history,sampler_bad)
        trace = samplehistoricaltrace(summary,history,sampler_good)
        @test nvariables(trace) == 3
        @test any(trace.value == h.value for h in history.traces)
        @test any(trace.time == h.time for h in history.traces)
    end

    @testset "rescaletrace!" begin
        @test_throws MethodError rescaletrace!(rand(10,3),rand(3),(RescaleIdentity(),RescaleMaxChangeMin(),RescaleMaxPreserveMin()))
        trace = rescaletrace!(StormTrace(rand(10,3),1:10),rand(4),(RescaleIdentity(),RescaleMaxChangeMin(),RescaleMaxPreserveMin()))
        @test nvariables(trace) == 4
    end
end