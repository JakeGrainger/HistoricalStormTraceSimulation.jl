# Choosing summary metrics

The choice of distance measure in the storm summary space is not always obvious.
One way to choose is to pick some parametric distance (e.g. weighted Euclidean distance) and then choose the parameters by try to optimise for the performance of the simulated traces.

If we have a score for the similarity of two traces, we can try to minimise the expected score of the simulated traces against the true historical traces.

To do this, use

```@docs
find_best_distance
expected_score
conditional_expected_score
```

## Trace scoring

Trace scores can be specified as a subtype of `TraceScore`.
A functor should then be defined taking in two traces, which returns a measure of similarity between the two, with 0 being identical.

Provided is `MarginalTraceScore` which allows the user to define weighted sums of scores (usually metrics) applied to each variable.

```@docs
MarginalTraceScore
```

Convenience functions for checking compatibility are also provided:

```@docs
HistoricalStormTraceSimulation.checkcompatible
```

### Implementing new trace scores

New methods can be implemented by analogy to the implementation for `MarginalTraceScore`:

```julia
struct MarginalTraceScore{T,S} <: TraceScore
    metrics::T
    weights::S
    function MarginalTraceScore(metrics::NTuple{N,Metric},weights=ones(length(metrics))) where {N}
        length(metrics) == length(weights) || throw(DimensionMismatch("weights and metrics should be same length."))
        new{typeof(metrics),typeof(weights)}(metrics,weights)
    end
end

function (mscore::MarginalTraceScore)(t1::StormTrace,t2::StormTrace)
    checkcompatible(t1,t2)
    checkcompatible(mscore,t1)
    score = 0.0
    for i in eachindex(mscore.metrics)
        @views score += mscore.weights[i]*mscore.metrics[i](t1.value[:,i],t2.value[:,i])
    end
    return score
end
```

