struct StormTrace{T<:AbstractRange{<:Real}}
    value::Matrix{Float64}
    time::T
end
nvariables(t::StormTrace) = size(t.value,2)+1

struct StormHistory{T}
    summaries::Vector{Vector{Float64}}
    traces::Vector{StormTrace{T}}
    function StormHistory(summaries,traces::Vector{StormTrace{T}}) where {T}
        length(summaries) == length(traces) || throw(DimensionMismatch("Should be equal number of traces and summaries."))
        all(length(s) == nvariables(t) for (s,t) ∈ zip(summaries,traces)) || throw(DimensionMismatch("Trace and summary have different number of variables."))
        all(length(s) == length(summaries[1]) for s in summaries) || throw(ArgumentError("summaries should all be same length."))
        new{T}(summaries,traces)
    end
end

struct TraceSampler{D<:Metric,T}
    d::D
    samplemethod::T # could be 1:50 if we wanted even probs
    distance_store::Vector{Float64}
    distance_index::Vector{Int64}
    function TraceSampler(d::D,samplemethod::T,distance_store,distance_index) where {D<:Metric,T}
        length(distance_store) == length(distance_index) || throw(DimensionMismatch("distance_store and distance_index not the same length."))
        new{D,T}(d,samplemethod::T,distance_store,distance_index)
    end
end
TraceSampler(d,samplemethod,n::Int) = TraceSampler(d,samplemethod,Vector{Float64}(undef,n),Vector{Int64}(undef,n))

function samplesingletrace(summary,history::StormHistory,sampler,rescalemethod)
    trace = samplehistoricaltrace(summary,history,sampler)
    adjustedtrace = rescaletrace(trace,summary,rescalemethod)
    # finaltrace = interpolate()
    return adjustedtrace
end

function samplehistoricaltrace(summary,history,sampler::TraceSampler)
    for i in eachindex(history.summaries,sampler.distance_store)
        sampler.distance_store[i] = sampler.d(summary,history.summaries[i])
    end
    sortperm!(sampler.distance_index,sampler.distance_store,rev=true)
    sampled = rand(sampler.samplemethod)
    sampled ≤ length(sampler.distance_store) || error("Sampler sampled out of bounds, check sampler provided is appropriate.")
    traceind = sampler.distance_index[sampled]
    return deepcopy(history.traces[traceind])
end

function rescaletrace(trace::StormTrace,summary,rescalemethod::NTuple{N,RescaleMethod}) where {N}
    N == size(trace.value,2) || throw(ArgumentError("Should specify same number of rescale methods as variables."))
    for i in 1:size(trace.value,2)
        rescalesinglevariable!(view(trace.value,:,i),summary[i],rescalemethod[i])
    end
    newtime = rescaletime(trace.time,summary[end])
    return StormTrace(trace.value,newtime)
end