@testset "sampletraces" begin
    @testset "sampletraces" begin
        npars = 3
        Δ = 0.5
        new_summaries = [[rand(npars); rand(5:20)] for i in 1:10]
        historical_trace_times = [(1:rand(5:20)).*Δ for i in 1:100]
        historical_trace_values = [rand(length(t), npars) for t in historical_trace_times]
        samplemethod = 1:40
        historical_summaries = [[[maximum(c) for c in eachcol(v)];t[end]-t[1]] for (v,t) in zip(historical_trace_values,historical_trace_times)]
        rescalemethod = (IdentityRescale(),RescaleMaxChangeMin(),RescaleMaxPreserveMin())
        # tests
        historical_traces = StormTrace.(historical_trace_values,historical_trace_times)
        history = StormHistory(historical_summaries,historical_traces)
        sample = sampletraces(new_summaries, history; samplemethod=samplemethod, rescalemethod=rescalemethod)
        @test sample isa Vector{<:StormTrace}
    end
    @testset "dataframes2storms" begin
        event_data = DataFrame(Hs = rand(3), Tp = rand(3), dir = rand(3), D = rand(3), time = [10,20,40])
        input_data = DataFrame(Tp = rand(50), Hs = rand(50), time = 0:0.2:0.2*49, dir = rand(50))
        event_start_end = DataFrame(start = [1,18,37], finish = [11,24,45])
        simulated_data = DataFrame(Hs = rand(3), Tp = rand(3), dir = rand(3), D = rand(3))
        new_summaries, history = dataframes2storms(event_data, event_start_end, input_data, simulated_data)
        @test history isa StormHistory
        @test new_summaries isa Vector{Vector{Float64}}
    end
end