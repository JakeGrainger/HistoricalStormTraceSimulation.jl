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
    score = 0.0
    for i in 1:length(history)
        temporary_history.summaries[i] .*= Inf # make summary unselectable (this isnt guarenteed to work)
        for j in 1:trace_repeats
            newtrace = samplesingletrace(history.summaries[i],temporary_history,sampler,rescalemethod)
            score += tracescore(newtrace,history.traces[i])
        end
        temporary_history.summaries[i] = history.summaries[i] # reset summary
    end
    return score
end
"""
    find_best_distance(D::Type{<:Metric},x₀,history; kwargs...)

Use optim to find the best distance based on `score_method` scoring.

# Arguments:
- `D` the type of distance (e.g. WeightedEuclidean). Note this is the type, not an instance!
- `x₀` initial parameters for the distance to start optimisation.
- `history` the storm history.
- `optim_kwargs`: Key word arguments to be passed to Optim.
- `kwargs` additional key word arguments, similar to `score_method`, but not including `summarymetric`, as this is specified by the optimisation.
"""
function find_best_distance(D::Type{<:Metric},x₀,history; optim_kwargs=(), kwargs...)
    function best_distance_objective(x)
        score_method(history; summarymetric = D(x), kwargs...)
    end
    res = Optim.optimize(best_distance_objective, x₀, optim_kwargs...)
    return res
end