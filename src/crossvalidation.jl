"""
    score_method(history::StormHistory; samplemethod=1:50, rescalemethod, summarymetric::Metric=Euclidean(), tracescore::TraceScore, trace_repeats::Int=1)

Scores the proposed sampling method by leaving out each trace in turn and predicting it, then comparing to the true trace.

# Arguments:
- `history`, `samplemethod`, `rescalemethod`, `summarymetric`: same as `sampletraces`
- `tracescore`: Score for comparing traces.
- `trace_repeats`: Number of traces to generate for each historical summary (accounts for the stochasticity of the sampling method).
"""
function score_method(history::StormHistory; samplemethod=1:50, rescalemethod, summarymetric::Metric=Euclidean(), tracescore::TraceScore, trace_repeats::Int=1)
    sampler = TraceSampler(summarymetric,samplemethod,length(history))
    temporary_history = deepcopy(history)
    score = Matrix{Float64}(undef, length(history), trace_repeats)
    for i in 1:length(history)
        temporary_history.summaries[i] .*= Inf # make summary unselectable (this isnt guarenteed to work)
        for j in 1:trace_repeats
            newtrace = samplesingletrace(history.summaries[i],temporary_history,sampler,rescalemethod)
            score[i,j] = tracescore(newtrace,history.traces[i])
        end
        temporary_history.summaries[i] = history.summaries[i] # reset summary
    end
    return score
end