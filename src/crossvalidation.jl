"""
    expected_score(history::StormHistory; samplemethod=1:50, rescalemethod, summarymetric::Metric=Euclidean(), interpolation_method=LinearInterpolation, tracescore::TraceScore)

Compute the expected score.

# Arguments:
- `history`, `samplemethod`, `rescalemethod`, `summarymetric`, `interpolation_method`: see `sampletraces`.
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
"""
    conditional_expected_score(summary,trace,history,sampler,rescalemethod,interpolation_method,tracescore)

Compute the conditional expected score of a given historical trace.
A different method will be used if the trace sampler uses a uniform over the closest `m` points method (i.e. if the sampler has a `UnitRange` for its `samplemethod`).

# Arguments
- `summary`: The summary of a historical trace.
- `trace`: The corresponding trace.
- `sampler`: A `TraceSampler`.
- `history`, `rescalemethod`, `interpolation_method`: see `sampletraces`
- `tracescore`: Score for comparing traces.
"""
function conditional_expected_score(summary,trace,history::StormHistory, sampler::TraceSampler,rescalemethod,interpolation_method,tracescore)
    score = 0.0
    computedistances!(summary,history,sampler)
    for i in 1:length(history)
        newtrace = samplesinglefixedtrace(i,summary,history,rescalemethod,interpolation_method)
        score += pdf(samplemethod,sampler.distance_store[i]) * tracescore(newtrace,trace)
    end
    return score
end
function conditional_expected_score(summary,trace,history::StormHistory, sampler::TraceSampler{D,T},rescalemethod,interpolation_method,tracescore) where {D<:Metric,T<:UnitRange}
    score = 0.0
    computedistances!(summary,history,sampler)
    sortperm!(sampler.distance_index,sampler.distance_store,rev=true)
    for i in sampler.samplemethod
        newtrace = samplesinglefixedtrace(sampler.distance_index[i],summary,history,rescalemethod,interpolation_method)
        score += tracescore(newtrace,trace) 
    end
    return score / length(sampler.samplemethod) # divide by k at the end
end

"""
    samplesinglefixedtrace()

Method to simulate a fixed trace based on rescaling the `i`th historical trace.
"""
function samplesinglefixedtrace(i,summary,history,rescalemethod,interpolation_method)
    trace = deepcopy(history.traces[i])
    adjustedtrace = adjusttracetime(trace, summary)
    interpolatedtrace = interpolatetrace(adjustedtrace,step(trace.time),interpolation_method)
    finaltrace = rescaletrace!(interpolatedtrace,summary,rescalemethod)
    return finaltrace
end

"""
    find_best_distance(D::Type{<:Metric},x???,history; lowerbounds, upperbounds, optim_kwargs=(), kwargs...)

Use optim to find the best distance based on `score_method` scoring.

# Arguments:
- `D` the type of distance (e.g. WeightedEuclidean). Note this is the constructor for the type, not an instance!
- `x???` initial parameters for the distance to start optimisation.
- `history` the storm history.
- `lowerbounds` the lower bounds for the optimisation, defaults to `fill(-Inf,length(x???))`.
- `upperbounds` the upper bounds for the optimisation, defaults to `fill(Inf,length(x???))`.
- `optim_kwargs`: Key word arguments to be passed to Optim.
- `kwargs` additional key word arguments, similar to `score_method`, but not including `summarymetric`, as this is specified by the optimisation.

# Note:

To use `WeightedPeriodicEuclidean`, you first need to select the periods `p`, and then create a constructor to fix these, e.g.

```julia-repl
julia> myperiods = [Inf,Inf,360.0]
3-element Vector{Float64}:
  Inf
  Inf
 360.0

julia> myperiodicdistance(w) = WeightedPeriodicEuclidean(myperiods,w)
myperiodicdistance (generic function with 1 method)
```

Then pass `myperiodicdistance` as the argument `D` to `find_best_distance`.

"""
function find_best_distance(D,x???,history; lowerbounds=fill(-Inf,length(x???)), upperbounds=fill(Inf,length(x???)), optim_kwargs=(), kwargs...)
    function best_distance_objective(x)
        if all(lowerbounds[i] < x[i] < upperbounds[i] for i in eachindex(x))
            return expected_score(history; summarymetric = D(x), kwargs...)
        else
            return Inf
        end
    end
    res = Optim.optimize(best_distance_objective, x???, optim_kwargs...)
    return res
end