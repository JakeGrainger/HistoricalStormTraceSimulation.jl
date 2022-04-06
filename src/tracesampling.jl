struct StormHistory{S,T}
    summaries::Vector{S}
    traces::Vector{T}
    function StormHistory(summaries::Vector{S},traces::Vector{T}) where {S,T}
        length(summaries) == length(traces) || throw(DimensionMismatch("Should be equal number of traces and summaries."))
        new{S,T}(summaries,traces)
    end
end

struct TraceSampler{T}
    distance::Vector{Float64}
    distance_index::Vector{Int64}
    samplemethod::T # could be 1:50 if we wanted even probs
    function TraceSampler(distance,distance_index,samplemethod::T) where {T}
        length(distance) == length(distance_index) || throw(DimensionMismatch("distance and distance_index not the same length."))
        new{T}(distance,distance_index,samplemethod::T)
    end
end
TraceSampler(n,samplemethod) = TraceSampler(Vector{Float64}(undef,n),Vector{Int64}(undef,n),samplemethod)


function sampletrace(summary,history::StormHistory,sampler,rescalemethod)
    trace = samplehistoricaltrace(summary,history,sampler)
    adjustedtrace = rescaletrace(trace,summary,rescalemethod)
    return adjustedtrace
end

function samplehistoricaltrace(summary,history,sampler::TraceSampler)
    for i in eachindex(history.summaries,sampler.distance)
        sampler.distance[i] = sampler.d(summary,history.summaries[i])
    end
    sortperm!(sampler.distance_index,distance,rev=true)
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