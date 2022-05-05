abstract type TraceScore end

struct MarginalTraceScore{T} <: TraceScore
    metrics::T
    function MarginalTraceScore(marginalmetrics::NTuple{N,Metric})
        new{typeof(marginalmetrics)}(marginalmetrics)
    end
end

function (mscore::MarginalTraceScore)(t1::StormTrace,t2::StormTrace)
    checkcompatible(t1,t2)

end

function checkcompatible(t1::StormTrace,t2::StormTrace)
    nvariables(t1) == nvariables(t2) || throw(DimensionMismatch("Storm traces have a different number of variables."))
    length(t1) == length(t2) || throw(DimensionMismatch("Storms not the same length."))
    nothing
end