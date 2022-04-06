struct StormHistory{S,T}
    summaries::Vector{S}
    traces::Vector{T}
    function StormHistory(summaries::Vector{S},traces::Vector{T}) where {S,T}
        length(summaries) == length(traces) || throw(DimensionMismatch("Should be equal number of traces and summaries."))
        new{S,T}(summaries,traces)
    end
end

struct TraceSampler{D<:Metric,T}
    d::D
    samplemethod::T # could be 1:50 if we wanted even probs
    distance_store::Vector{Float64}
    distance_index::Vector{Int64}
    function TraceSampler(d::D,distance_store,distance_index,samplemethod::T) where {D,T}
        length(distance_store) == length(distance_index) || throw(DimensionMismatch("distance_store and distance_index not the same length."))
        new{D,T}(d,samplemethod::T,distance_store,distance_index)
    end
end
TraceSampler(d,n,samplemethod) = TraceSampler(d,samplemethod,Vector{Float64}(undef,n),Vector{Int64}(undef,n))


function samplesingletrace(summary,history::StormHistory,sampler,rescalemethod)
    trace = samplehistoricaltrace(summary,history,sampler)
    adjustedtrace = rescaletrace(trace,summary,rescalemethod)
    return adjustedtrace
end

function samplehistoricaltrace(summary,history,sampler::TraceSampler)
    for i in eachindex(history.summaries,sampler.distance)
        sampler.distance_store[i] = sampler.d(summary,history.summaries[i])
    end
    sortperm!(sampler.distance_index,sampler.distance_store,rev=true)
    sampled = rand(sampler.samplemethod)
    traceind = sample.distance_index[sampled]
    return deepcopy(history.traces[traceind])
end

function rescaletrace(trace,summary,rescalemethod::NTuple{N,RescaleMethod}) where {N}
    N == size(trace,2) || throw(ArgumentError("Should specify same number of rescale methods as variables."))
    for i in 1:size(trace,2)
        rescalesinglevariable!(view(trace,:,i),summary[i],rescalemethod)
    end
    return trace
end