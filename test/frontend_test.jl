@testset "sampletraces" begin
    # generate test data
    npars = 3
    Δ = 0.5
    new_summaries = [[rand(npars); rand(5:20)] for i in 1:10]
    historical_trace_times = [(1:rand(5:20)).*Δ for i in 1:100]
    historical_trace_values = [rand(length(t), npars) for t in historical_trace_times]
    samplemethod = 1:40
    historical_summaries = [[[maximum(c) for c in eachcol(v)];t[end]-t[1]] for (v,t) in zip(historical_trace_values,historical_trace_times)]
    rescalemethod = (IdentityRescale(),RescaleMaxChangeMin(),RescaleMaxPreserveMin())
    # tests
    sample = sampletraces(new_summaries, historical_summaries, historical_trace_values, historical_trace_times; samplemethod=samplemethod, rescalemethod=rescalemethod)
    @test sample isa Vector{StormTrace}
end