"""
    sampletraces(new_summaries, historical_summaries, historical_traces; samplemethod=1:50, rescalemethod)

Sample new traces given summmaries based on modifications of historical traces.

# Arguments
- `new_summaries`: Vector summaries for which we generate a trace.
- `historical_summaries`: Vector of historical summaries (themselves vectors).
- `historical_traces`: Vector of historical traces (which are matricies with size(x,2)==length(y) is x is the trace and y the summary).
- `samplemethod`: Method for sampling from closest points. Passing 1:m will sample uniformly from the closest `m` points.
- `rescalemethod`: Tuple of methods for rescaling (one for each column of the trace).

The representation of traces as matricies encodes a trace by including time as one of the columns. 
The summary of time (duration) should then be included in the corrsponding row of the summary.
"""

function sampletraces(new_summaries, historical_summaries, historical_traces; samplemethod=1:50, rescalemethod)
    all(length(s)==length(new_summaries[1]) for s in new_summaries) || throw(ArgumentError("new_summaries should all be the same length."))
    history = StormHistory(historical_summaries,historical_traces)
    sampler = TraceSampler(length(historical_summaries),samplemethod)
    traces = @showprogress "Sampling historical storms... " [
        sampledsingletrace(s,history,sampler,rescalemethod) for s ∈ new_summaries
    ]
    return traces
end