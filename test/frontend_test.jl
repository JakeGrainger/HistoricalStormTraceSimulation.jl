@testset "sampletraces" begin
    @testset "sampletraces" begin
        npars = 3
        Δ = 0.5
        new_summaries = [[rand(npars); rand(5:20)] for i in 1:10]
        historical_trace_times = [(1:rand(5:20)).*Δ for i in 1:100]
        historical_trace_values = [rand(length(t), npars) for t in historical_trace_times]
        samplemethod = 1:40
        historical_summaries = [[[maximum(c) for c in eachcol(v)];t[end]-t[1]] for (v,t) in zip(historical_trace_values,historical_trace_times)]
        rescalemethod = (RescaleIdentity(),RescaleMaxChangeMin(),RescaleMaxPreserveMin())
        # tests
        historical_traces = StormTrace.(historical_trace_values,historical_trace_times)
        history = StormHistory(historical_summaries,historical_traces)
        sample = sampletraces(new_summaries, history; samplemethod=samplemethod, rescalemethod=rescalemethod)
        @test sample isa Vector{<:StormTrace}
    end
    @testset "dataframes2storms" begin
        @testset "no missing" begin
            event_data = DataFrame(Hs = fill(1.0,3), Tp = fill(2.0,3), dir = fill(3.0,3), D = fill(4.0,3), time = [10,20,40])
            input_data = DataFrame(Tp = fill(2.0,50), Hs = fill(1.0,50), time = 0:0.2:0.2*49, dir = fill(3.0,50))
            event_start_end = DataFrame(start = [1,18,37], finish = [11,24,45])
            simulated_data = DataFrame(Hs = fill(1.0,3), dir = fill(3.0,3), Tp = fill(2.0,3), D = fill(4.0,3))
            new_summaries, history, summary_names = dataframes2storms(event_data, event_start_end, input_data, simulated_data)
            @test history isa StormHistory
            @test new_summaries isa Vector{Vector{Float64}}
            @test all(s == [1.0,2.0,3.0,4.0] for s in new_summaries)
            @test all(s == [1.0,2.0,3.0,4.0] for s in history.summaries)
            @test all(t.value[1,:] == [1.0,2.0,3.0] for t in history.traces)
        end
        @testset "missing" begin
            event_data = DataFrame(Hs = fill(1.0,3), Tp = fill(2.0,3), dir = fill(3.0,3), D = fill(4.0,3), time = [10,20,40])
            input_data = DataFrame(Tp = fill(2.0,50), Hs = fill(1.0,50), time = 0:0.2:0.2*49, dir = [fill(3.0,25);fill(missing,25)])
            event_start_end = DataFrame(start = [1,18,37], finish = [11,24,45])
            simulated_data = DataFrame(Hs = fill(1.0,3), dir = fill(3.0,3), Tp = fill(2.0,3), D = fill(4.0,3))
            new_summaries, history, summary_names = dataframes2storms(event_data, event_start_end, input_data, simulated_data)
            @test length(history.summaries) == 2
            @test length(history.traces) == 2
        end
        @testset "short" begin
            event_data = DataFrame(Hs = fill(1.0,3), Tp = fill(2.0,3), dir = fill(3.0,3), D = fill(4.0,3), time = [10,20,40])
            input_data = DataFrame(Tp = fill(2.0,50), Hs = fill(1.0,50), time = 0:0.2:0.2*49, dir = fill(3.0,50))
            event_start_end = DataFrame(start = [1,18,37], finish = [11,24,39])
            simulated_data = DataFrame(Hs = fill(1.0,3), dir = fill(3.0,3), Tp = fill(2.0,3), D = fill(4.0,3))
            new_summaries, history, summary_names = dataframes2storms(event_data, event_start_end, input_data, simulated_data)
            @test length(history.summaries) == 2 # one should be too short
            @test length(history.traces) == 2
        end
    end
end