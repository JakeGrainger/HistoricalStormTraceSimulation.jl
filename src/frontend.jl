"""
    sampletraces(new_summaries, historical_summaries, historical_traces; samplemethod=1:50, rescalemethod)

Sample new traces given summmaries based on modifications of historical traces.
"""

function sampletraces(new_summaries, historical_summaries, historical_traces; samplemethod=1:50, rescalemethod)
    history = StormHistory(historical_summaries,historical_traces)
    sampler = TraceSampler(length(historical_summaries),samplemethod)
    traces = @showprogress "Sampling historical storms... " [
        sampledsingletrace(s,history,sampler,rescalemethod) for s ∈ new_summaries
    ]
    return traces
end