"""
    sampletraces(new_summaries, historical_summaries, historical_traces; samplemethod=1:50, rescalemethod)

Sample new traces given summaries based on modifications of historical traces.

# Arguments
- `new_summaries`: Vector of summaries to generate traces for.
- `history`: Storm history information of type `StormHistory`. Best constructed using `dataframes2storms` function.
- `samplemethod`: Method for sampling from closest points. Passing 1:m will sample uniformly from the closest `m` points. Defaults to `1:50`. Could also be a `Distribution`. Note that if a `Distribution` is used, then it should be discrete, and should be defined on `1:n` where `n` is the number of historical storms.
- `rescalemethod`: Tuple of methods for rescaling (one for each column of the trace). Should be a subtype of type RescaleMethod.
- `summarymetric`: A metric for determining closeness of storm summaries (must be subtype of Metric). Default is `Euclidean()`. Note care should be taken when dealing with directions, in this case, use `PeriodicEuclidean` or `WeightedPeriodicEuclidean` with the appropriate period choices.
- `interpolation_method`: Method for performing interpolation. `LinearInterpolation` is the default, but `CubicSplineInterpolation` may be preferable in some contexts (though it is much slower).

# RescaleMethods
- `RescaleIdentity()`: The identity (no rescale).
- `RescaleMean()`: Rescale the mean to match provided mean.
- `RescaleMaxChangeMin()`: Rescale the maximum to match provided maximum, using linear scaling and changing the minimum.
- `RescaleMaxPreserveMin()`: Rescale the maximum to match provided maximum, using linear scaling but preserving the minimum
"""
function sampletraces(new_summaries, history::StormHistory; samplemethod=1:50, rescalemethod, summarymetric::Metric=Euclidean(),interpolation_method=LinearInterpolation)
    all(length(s)==length(new_summaries[1]) for s in new_summaries) || throw(ArgumentError("new_summaries should all be the same length."))
    sampler = TraceSampler(summarymetric,samplemethod,length(history))
    traces = @showprogress "Sampling historical storms... " [
        samplesingletrace(s,history,sampler,rescalemethod,interpolation_method) for s ??? new_summaries
    ]
    return traces
end

"""
    dataframes2storms(event_data, event_start_end, input_data, simulated_data)

Convert dataframes containing storm parameters and data to traces and summaries for use in package.

Will reorder variables to match up names of variables.
Pass outputs to `sampletraces` function.

# Arguments:
- `event_data` - DataFrame containing summaries of historical storms.
- `event_start_end` - DataFrame containing start and end indices of events in `input_data`.
- `input_data` - DataFrame containing historical time series.
- `simulated_data` - DataFrame containing simulated storm summaries.

# Outputs:
- `new_summaries` - Vector of summary vectors.
- `history` - `StormHistory` object.
- `summary_names` - Names of summary variables in order (traces are the same but one less variable (time is separate)).
"""
function dataframes2storms(event_data, event_start_end, input_data, simulated_data)
    # needs error handling to check names of input cols are the same.
    
    all(r[1] < r[2] for r in eachrow(event_start_end)) || throw(ArgumentError("event_start_end has end times before start times. Should be first col start index, second col end index."))
    all(r[1] isa Int && r[2] isa Int for r in eachrow(event_start_end)) || throw(ArgumentError("event_start_end is not integer valued. Should be an index, not the actual time."))

    event_names = names(event_data)
    simulated_names = names(simulated_data)
    input_names = names(input_data)
    time_ind = findfirst(x->x=="time", event_names)
    dur_ind = findfirst(x->x=="D", event_names)

    event_order = [setdiff(1:ncol(event_data),[time_ind,dur_ind]); dur_ind]
    simulated_order = [findfirst(x->x==event_names[i], simulated_names) for i in event_order]
    input_order = @views [findfirst(x->x==event_names[i], input_names) for i in event_order[1:end-1]]

    historical_summaries = [[c[i] for i in event_order] for c in eachrow(Matrix(event_data))]
    historical_trace_values = [reduce(hcat,input_data[r[1]:r[2],i] for i in input_order) for r in eachrow(event_start_end)]
    ?? = input_data.time[2]-input_data.time[1]
    historical_trace_times = [(r[1]-1:r[2]-1) .* ?? for r in eachrow(event_start_end)] # note these are not necessarily the true times, but we rescale later anyway
    new_summaries = [[c[i] for i in simulated_order] for c in eachrow(Matrix(simulated_data))]

    all(@. length(historical_trace_times) == size(historical_trace_values,1)) || throw(DimensionMismatch("Times of traces do not match there lengths. Load manually."))

    good_trace_index = [i for i in eachindex(historical_trace_values) if !any(ismissing,historical_trace_values[i]) && size(historical_trace_values[i],1)>3]
    historical_traces = [StormTrace(identity.(historical_trace_values[i]),historical_trace_times[i]) for i in good_trace_index]
    history = StormHistory(historical_summaries[good_trace_index],historical_traces)
    summary_names = event_names[event_order]
    return new_summaries, history, summary_names
end