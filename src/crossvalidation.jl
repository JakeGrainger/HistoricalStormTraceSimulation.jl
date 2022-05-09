"""
    score_method(history::StormHistory; samplemethod=1:50, rescalemethod, summarymetric::Metric=Euclidean(), interpolation_method=LinearInterpolation, tracescore::TraceScore)

Scores the proposed sampling method by leaving out each trace in turn and predicting it, then comparing to the true trace.

# Arguments:
- `history`, `samplemethod`, `rescalemethod`, `summarymetric`, `interpolation_method`: same as `sampletraces`
- `tracescore`: Score for comparing traces.
"""
function expected_score(history::StormHistory; samplemethod=1:50, rescalemethod, summarymetric::Metric=Euclidean(), interpolation_method=LinearInterpolation, tracescore::TraceScore)
    sampler = TraceSampler(summarymetric,samplemethod,length(history))
    score = 0.0
    for i in 1:length(history)
        score += conditional_expected_score(history.summaries[i],history.traces[i],history,sampler,rescalemethod,interpolation_method,tracescore)
    end
    return score/length(history)
end
function conditional_expected_score(summary,trace,history::StormHistory; sampler::TraceSampler,rescalemethod,interpolation_method,tracescore)
    score = 0.0
    computedistances!(summary,history,sampler)
    for i in 1:length(history)
        newtrace = simulatesinglefixedtrace(i,summary,history,rescalemethod,interpolation_method)
        score += pdf(samplemethod,history.summary[i]) * tracescore(newtrace,trace)
    end
    return score
end
function conditional_expected_score(summary,trace,history::StormHistory; sampler::TraceSampler{D,T},rescalemethod,interpolation_method,tracescore) where {D,T<:UnitRange}
    score = 0.0
    computedistances!(summary,history,sampler)
    sortperm!(sampler.distance_index,sampler.distance_store,rev=true)
    for i in sampler.samplemethod
        newtrace = simulatesinglefixedtrace(sampler.distance_index[i],summary,history,rescalemethod,interpolation_method)
        score += tracescore(newtrace,trace) 
    end
    return score / length(sampler.samplemethod)
end
function simulatesinglefixedtrace(i,summary,history,rescalemethod,interpolation_method)
    trace = deepcopy(history.traces[i])
    adjustedtrace = rescaletrace!(trace,summary,rescalemethod)
    adjustedtrace = interpolatetrace(adjustedtrace,step(trace.time),interpolation_method)
    return adjustedtrace
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
        expected_score(history; summarymetric = D(x), kwargs...)
    end
    res = Optim.optimize(best_distance_objective, x₀, optim_kwargs...)
    return res
end