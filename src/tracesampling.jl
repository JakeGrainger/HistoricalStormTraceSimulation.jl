struct StormHistory{S,T}
    summaries::Vector{S}
    traces::Vector{T}
    function StormHistory(summaries::Vector{S},traces::Vector{T}) where {S,T}
        length(summaries) == length(traces) || throw(DimensionMismatch("Should be equal number of traces and summaries."))
        new{S,T}(summaries,traces)
    end
end

function sampletrace(summary,history::StormHistory;samplemethod,rescalemethod)
    trace = samplehistoricaltrace(summary,history,samplemethod)
    adjustedtrace = rescaletrace(trace,summary,rescalemethod)
    return adjustedtrace
end

struct TraceSampler{T}
    distance::Vector{Float64}
    distance_index::Vector{Int64}
    samplemethod::T # could be 1:50 if we wanted even probs
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