"""
    StormTrace(value,time)

Construct a StormTrace type used for storing a storm type.

# Arguments
- `value`: A matrix of floats which is `n × p`.
- `time`: An abstract range of length `n`.
"""
struct StormTrace{T<:AbstractRange{<:Real}}
    value::Matrix{Float64}
    time::T
    function StormTrace(value,time)
        size(value,1) == length(time) || throw(DimensionMismatch("time is not the same length as first dimension of value."))
        new{typeof(time)}(value,time)
    end
end
"""
    nvariables(t::StormTrace)

Compute the number of variable contained by a storm trace, including time.

This is size(t.value,2)+1.
"""
nvariables(t::StormTrace) = size(t.value,2)+1
"""
    length(t::StormTrace)

Compute the length of a StormTrace, which is the number of time points (not total number of elements).
"""
Base.length(t::StormTrace) = size(t.value,1)

"""
    StormHistory(summaries,traces)

For storing historical storms.

# Arguments
- `summaries`: Should be a vector of vectors each of length `q`, containing summaries of storms.
- `traces`: Should be a vector of `StormTrace`s, each satisfying ` nvariables(t)==q`.
"""
struct StormHistory{T,S}
    summaries::T
    traces::S
    function StormHistory(summaries::AbstractVector{Vector{Float64}},traces::AbstractVector{StormTrace{M}}) where {M}
        length(summaries) == length(traces) || throw(DimensionMismatch("Should be equal number of traces and summaries."))
        all(length(s) == nvariables(t) for (s,t) ∈ zip(summaries,traces)) || throw(DimensionMismatch("Trace and summary have different number of variables."))
        all(length(s) == length(summaries[1]) for s in summaries) || throw(ArgumentError("summaries should all be same length."))
        new{typeof(summaries),typeof(traces)}(summaries,traces)
    end
end
"""
    length(s::StormHistory)

Compute the length of a StormHistory, i.e. the number of storms contained in the history.
"""
Base.length(s::StormHistory) = Base.length(s.summaries)

"""
    TraceSampler(d,samplemethod,n::Int)

# Arguments
- `summarymetric`: A metric for determining closeness of storm summaries (must be subtype of Metric). Default is Euclidean().
- `samplemethod`: Method for sampling from closest points. Passing 1:m will sample uniformly from the closest `m` points. Defaults to 1:50. Could also be a `Distribution`.
- `n`: The number of storms.

# Note 
There is an alternate constructor 
    `TraceSampler(summarymetric,samplemethod,distance_store,distance_index)`
this is an internal feature, `distance_store` and `distance_index` are constructed based on `n` in the other constructor.
Their purpose is to preallocate distance storage and improve performance.
"""
struct TraceSampler{D<:Metric,T}
    d::D # note this is called summarymetric elsewhere
    samplemethod::T # could be 1:50 if we wanted even probs
    distance_store::Vector{Float64}
    distance_index::Vector{Int64}
    function TraceSampler(summarymetric::D,samplemethod::T,distance_store,distance_index) where {D<:Metric,T}
        length(distance_store) == length(distance_index) || throw(DimensionMismatch("distance_store and distance_index not the same length."))
        new{D,T}(summarymetric,samplemethod::T,distance_store,distance_index)
    end
end
TraceSampler(d,samplemethod,n::Int) = TraceSampler(d,samplemethod,Vector{Float64}(undef,n),Vector{Int64}(undef,n))

"""
    samplesingletrace(summary,history,sampler,rescalemethod,interpolation_method=LinearInterpolation)

Function to sample a trace given a `summary` and `history`.

# Arguments
- `summary`: The summary to simulate a trace for.
- `history`: The StormHistory to match to.
- `sampler`: Sampler of type `TraceSampler`.
- `rescalemethod`: see docstring for `sampletraces`.
- `interpolation_method`: see docstring for `sampletraces`.
"""
function samplesingletrace(summary,history::StormHistory,sampler,rescalemethod,interpolation_method=LinearInterpolation)
    trace = samplehistoricaltrace(summary,history,sampler)
    adjustedtrace = adjusttracetime(trace, summary)
    interpolatedtrace = interpolatetrace(adjustedtrace,step(trace.time),interpolation_method)
    finaltrace = rescaletrace!(interpolatedtrace,summary,rescalemethod)
    return finaltrace
end

"""
    adjusttracetime(trace, summary)

Adjust the time of a trace based on a summary (just calls `rescaletime` and then repacks in a `StormTrace`).
"""
adjusttracetime(trace, summary) = StormTrace(trace.value, rescaletime(trace.time,summary[end]))

"""
    interpolatetrace(trace,Δ,interpolation_method=LinearInterpolation)

Interpolate a `trace` to a new resolution `Δ`.

# Arguments
- `trace`: The trace to be interpolated.
- `Δ`: The new time resolution.
- `interpolation_method`: see docstring for `sampletraces`.
"""
function interpolatetrace(trace,Δ,interpolation_method=LinearInterpolation)
    traceend = trace.time[end]
    if traceend % Δ ≈ 0 || traceend % Δ ≈ Δ # catch cases of floating point error
        traceend = round(traceend/Δ)*Δ
        trace = StormTrace(trace.value,range(0.0,traceend,length=length(trace.time))) # replace trace with corrected time
    end
    newtime = 0:Δ:traceend
    newvalue = Matrix{Float64}(undef,length(newtime),size(trace.value,2))
    for i in 1:size(trace.value,2)
        sp = @views interpolation_method(trace.time, trace.value[:,i])
        for j in 1:size(newvalue,1)
            newvalue[j,i] = sp(newtime[j])
        end
    end
    return StormTrace(newvalue,newtime)
end

"""
    samplehistoricaltrace(summary,history,sampler::TraceSampler)

Sample a historical trace from a `history` given a `summary`.

See `samplesingletrace` for argument details.
"""
function samplehistoricaltrace(summary,history,sampler::TraceSampler)
    computedistances!(summary,history,sampler)
    sortperm!(sampler.distance_index,sampler.distance_store,rev=true)
    sampled = rand(sampler.samplemethod)
    sampled ≤ length(sampler.distance_store) || error("Sampler sampled out of bounds, check sampler provided is appropriate.")
    traceind = sampler.distance_index[sampled]
    return deepcopy(history.traces[traceind])
end

"""
    computedistances!(summary,history,sampler::TraceSampler)

Compute the distances for a given summary to all historical summaries.

*Note*: This overwrites memory in `sampler` and returns `nothing`.
See `samplesingletrace` for argument details.
"""
function computedistances!(summary,history,sampler::TraceSampler)
    for i in eachindex(history.summaries,sampler.distance_store)
        sampler.distance_store[i] = sampler.d(summary,history.summaries[i])
    end
    nothing
end

"""
    rescaletrace!(trace::StormTrace,summary,rescalemethod::NTuple{N,RescaleMethod}) where {N}

Rescale a trace to match a summary.

# Arguments
- `trace`: The `StormTrace` to be adjusted.
- `summary`: The summary to simulate a trace for.
- `rescalemethod`: see docstring for `sampletraces`.
"""
function rescaletrace!(trace::StormTrace,summary,rescalemethod::NTuple{N,RescaleMethod}) where {N}
    N == size(trace.value,2) || throw(ArgumentError("Should specify same number of rescale methods as variables."))
    for i in 1:size(trace.value,2)
        rescalesinglevariable!(view(trace.value,:,i),summary[i],rescalemethod[i])
    end
    return trace
end