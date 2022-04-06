"""
    sampletraces(new_summaries, historical_summaries, historical_traces; samplemethod=1:50, rescalemethod)

Sample new traces given summmaries based on modifications of historical traces.

# Arguments
- `new_summaries`: Vector summaries for which we generate a trace.
- `historical_summaries`: Vector of historical summaries (themselves vectors), assuming final entry is duration.
- `historical_trace_values`: Vector of historical traces (which are matricies with size(x,2)==length(y) is x is the trace and y the summary).
- `historical_trace_times`: Vector of trace times, make sure they are all stored as the same type (e.g. a UnitRange).
- `samplemethod`: Method for sampling from closest points. Passing 1:m will sample uniformly from the closest `m` points. Defaults to 1:50.
- `rescalemethod`: Tuple of methods for rescaling (one for each column of the trace). Should be a subtype of type RescaleMethod.
- `summarymetric`: A metric for determining closeness of storm summaries (must be subtype of Metric). Default is Euclidean().

# RescaleMethods
- `IdentityRescale()`: The identity (no rescale).
- `RescaleMaxChangeMin()`: Rescale the maximum to match provided maximum, using linear scaling and changing the minimum.
- `RescaleMaxPreserveMin()`: Rescale the maximum to match provided maximum, using linear scaling but preserving the minimum
"""

function sampletraces(new_summaries, historical_summaries, historical_trace_values, historical_trace_times; samplemethod=1:50, rescalemethod, summarymetric::Metric=Euclidean())
    all(length(s)==length(new_summaries[1]) for s in new_summaries) || throw(ArgumentError("new_summaries should all be the same length."))
    historical_traces = StormTrace.(historical_trace_values,historical_trace_times)
    history = StormHistory(historical_summaries,historical_traces)
    sampler = TraceSampler(summarymetric,samplemethod,length(historical_summaries))
    traces = @showprogress "Sampling historical storms... " [
        sampledsingletrace(s,history,sampler,rescalemethod) for s ∈ new_summaries
    ]
    return traces
end