abstract type TraceScore end

struct MarginalTraceScore{T,S} <: TraceScore
    metrics::T
    weights::S
    function MarginalTraceScore(metrics::NTuple{N,Metric},weights=ones(size(metrics)))
        length(metrics) == length(weights) || throw(DimensionMismatch("weights and metrics should be same length."))
        new{typeof(metrics)}(metrics)
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

function checkcompatible(m::MarginalTraceScore,t::StormTrace)
    size(t.value,2) == length(m.metrics) || throw(DimensionMismatch("metrics should be equal to number of cols in trace.value."))
    nothing
end

function checkcompatible(t1::StormTrace,t2::StormTrace)
    nvariables(t1) == nvariables(t2) || throw(DimensionMismatch("Storm traces have a different number of variables."))
    length(t1) == length(t2) || throw(DimensionMismatch("Storms not the same length."))
    nothing
end