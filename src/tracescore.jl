abstract type TraceScore end

"""
    MarginalTraceScore(metrics::NTuple{N,Metric},weights=ones(length(metrics)))

Construct a scoring method for traces based on a weighted some of marginal metrics.

# Arguments
- `metrics`: Should be a tuple of `p` metrics, where `p` is the number of variables in the trace of interest (not including time).
- `weights`: A vector of weights to be used (defaults to vector of ones).

# Use
Given a `MarginalTraceScore` called `mscore`.

`(mscore::MarginalTraceScore)(t1::StormTrace,t2::StormTrace)`

will compute the marginal trace score between two traces `t1` and `t2`.
"""
struct MarginalTraceScore{T,S} <: TraceScore
    metrics::T
    weights::S
    function MarginalTraceScore(metrics::NTuple{N,Metric},weights=ones(length(metrics))) where {N}
        length(metrics) == length(weights) || throw(DimensionMismatch("weights and metrics should be same length."))
        new{typeof(metrics),typeof(weights)}(metrics,weights)
    end
end

# make MarginalTraceScore a functor.
function (mscore::MarginalTraceScore)(t1::StormTrace,t2::StormTrace)
    checkcompatible(t1,t2)
    checkcompatible(mscore,t1)
    score = 0.0
    for i in eachindex(mscore.metrics)
        @views score += mscore.weights[i]*mscore.metrics[i](t1.value[:,i],t2.value[:,i])
    end
    return score
end

"""
    checkcompatible(m::MarginalTraceScore,t::StormTrace)

Check trace is compatible with MarginalTraceScore.
"""
function checkcompatible(m::MarginalTraceScore,t::StormTrace)
    size(t.value,2) == length(m.metrics) || throw(DimensionMismatch("metrics should be equal to number of cols in trace.value."))
    nothing
end

"""
    checkcompatible(t1::StormTrace,t2::StormTrace)

Check two traces are compatible.
"""
function checkcompatible(t1::StormTrace,t2::StormTrace)
    nvariables(t1) == nvariables(t2) || throw(DimensionMismatch("Storm traces have a different number of variables."))
    length(t1) == length(t2) || throw(DimensionMismatch("Storms not the same length."))
    nothing
end