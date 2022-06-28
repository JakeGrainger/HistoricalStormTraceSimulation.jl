var documenterSearchIndex = {"docs":
[{"location":"","page":"Home","title":"Home","text":"CurrentModule = HistoricalStormTraceSimulation","category":"page"},{"location":"#HistoricalStormTraceSimulation","page":"Home","title":"HistoricalStormTraceSimulation","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Documentation for HistoricalStormTraceSimulation.","category":"page"},{"location":"","page":"Home","title":"Home","text":"","category":"page"},{"location":"","page":"Home","title":"Home","text":"Modules = [HistoricalStormTraceSimulation]","category":"page"},{"location":"#HistoricalStormTraceSimulation.MarginalTraceScore","page":"Home","title":"HistoricalStormTraceSimulation.MarginalTraceScore","text":"MarginalTraceScore(metrics::NTuple{N,Metric},weights=ones(length(metrics)))\n\nConstruct a scoring method for traces based on a weighted some of marginal metrics.\n\nArguments\n\nmetrics: Should be a tuple of p metrics, where p is the number of variables in the trace of interest (not including time).\nweights: A vector of weights to be used (defaults to vector of ones).\n\nUse\n\nGiven a MarginalTraceScore called mscore.\n\n(mscore::MarginalTraceScore)(t1::StormTrace,t2::StormTrace)\n\nwill compute the marginal trace score between two traces t1 and t2.\n\n\n\n\n\n","category":"type"},{"location":"#HistoricalStormTraceSimulation.RescaleIdentity","page":"Home","title":"HistoricalStormTraceSimulation.RescaleIdentity","text":"RescaleIdentity()\n\nA rescale type to represent the identity rescale.\n\n\n\n\n\n","category":"type"},{"location":"#HistoricalStormTraceSimulation.RescaleMaxChangeMin","page":"Home","title":"HistoricalStormTraceSimulation.RescaleMaxChangeMin","text":"RescaleMaxChangeMin()\n\nLinear rescale to adjust the maximum of the new trace to equal the summary value.\n\nGiven a trace variable series y_j, and summary value x_j, the new trace  tildey_j is constructed using the following rule, forall tin T_y:\n\ntilde y_j(t) = fracx_jmaxlimits_tin T_yy_j(t)y_j(t)\n\n\n\n\n\n","category":"type"},{"location":"#HistoricalStormTraceSimulation.RescaleMaxPreserveMin","page":"Home","title":"HistoricalStormTraceSimulation.RescaleMaxPreserveMin","text":"RescaleMaxPreserveMin()\n\nLinear rescale to adjust the maximum of the new trace to equal the summary value whilst preserving the minimum. \n\nGiven a trace variable series y_j, and summary value x_j, the new trace  tildey_j is constructed using the following rule, forall tin T_y:\n\ntilde y_j(t) = fracx_j-minlimits_tin T_y  y_j(t)maxlimits_tin T_yy_j(t)-minlimits_tin T_y  y_j(t) left(y_j(t)-minlimits_tin T_y  y_j(t)right) + minlimits_tin T_y  y_j(t)\n\nThis only works if the new maximum x_j satisfies x_jminlimits_tin T_y  y_j(t). The formula is forall tin T_y. If this condition is not satisfied, a warning will be displayed.\n\n\n\n\n\n","category":"type"},{"location":"#HistoricalStormTraceSimulation.RescaleMean","page":"Home","title":"HistoricalStormTraceSimulation.RescaleMean","text":"RescaleMean()\n\nAdditive rescaling to match the mean of the trace to the summary value.\n\nGiven a trace variable series y_j, and summary value x_j, the new trace \n\ntilde y_j(t) = y_j(t) - overliney_j + x_j\n\nwhere overliney_j = frac1T_y sum_tin T_yy_j(t).\n\n\n\n\n\n","category":"type"},{"location":"#HistoricalStormTraceSimulation.StormHistory","page":"Home","title":"HistoricalStormTraceSimulation.StormHistory","text":"StormHistory(summaries,traces)\n\nFor storing historical storms.\n\nArguments\n\nsummaries: Should be a vector of vectors each of length q, containing summaries of storms.\ntraces: Should be a vector of StormTraces, each satisfying nvariables(t)==q.\n\n\n\n\n\n","category":"type"},{"location":"#HistoricalStormTraceSimulation.StormTrace","page":"Home","title":"HistoricalStormTraceSimulation.StormTrace","text":"StormTrace(value,time)\n\nConstruct a StormTrace type used for storing a storm type.\n\nArguments\n\nvalue: A matrix of floats which is n × p.\ntime: An abstract range of length n.\n\n\n\n\n\n","category":"type"},{"location":"#HistoricalStormTraceSimulation.TraceSampler","page":"Home","title":"HistoricalStormTraceSimulation.TraceSampler","text":"TraceSampler(d,samplemethod,n::Int)\n\nArguments\n\nsummarymetric: A metric for determining closeness of storm summaries (must be subtype of Metric). Default is Euclidean().\nsamplemethod: Method for sampling from closest points. Passing 1:m will sample uniformly from the closest m points. Defaults to 1:50. Could also be a Distribution.\nn: The number of storms.\n\nNote\n\nThere is an alternate constructor      TraceSampler(summarymetric,samplemethod,distance_store,distance_index) this is an internal feature, distance_store and distance_index are constructed based on n in the other constructor. Their purpose is to preallocate distance storage and improve performance.\n\n\n\n\n\n","category":"type"},{"location":"#Base.length-Tuple{HistoricalStormTraceSimulation.StormHistory}","page":"Home","title":"Base.length","text":"length(s::StormHistory)\n\nCompute the length of a StormHistory, i.e. the number of storms contained in the history.\n\n\n\n\n\n","category":"method"},{"location":"#Base.length-Tuple{HistoricalStormTraceSimulation.StormTrace}","page":"Home","title":"Base.length","text":"length(t::StormTrace)\n\nCompute the length of a StormTrace, which is the number of time points (not total number of elements).\n\n\n\n\n\n","category":"method"},{"location":"#HistoricalStormTraceSimulation.adjusttracetime-Tuple{Any, Any}","page":"Home","title":"HistoricalStormTraceSimulation.adjusttracetime","text":"adjusttracetime(trace, summary)\n\nAdjust the time of a trace based on a summary (just calls rescaletime and then repacks in a StormTrace).\n\n\n\n\n\n","category":"method"},{"location":"#HistoricalStormTraceSimulation.checkcompatible-Tuple{HistoricalStormTraceSimulation.StormTrace, HistoricalStormTraceSimulation.StormTrace}","page":"Home","title":"HistoricalStormTraceSimulation.checkcompatible","text":"checkcompatible(t1::StormTrace,t2::StormTrace)\n\nCheck two traces are compatible.\n\n\n\n\n\n","category":"method"},{"location":"#HistoricalStormTraceSimulation.checkcompatible-Tuple{MarginalTraceScore, HistoricalStormTraceSimulation.StormTrace}","page":"Home","title":"HistoricalStormTraceSimulation.checkcompatible","text":"checkcompatible(m::MarginalTraceScore,t::StormTrace)\n\nCheck trace is compatible with MarginalTraceScore.\n\n\n\n\n\n","category":"method"},{"location":"#HistoricalStormTraceSimulation.computedistances!-Tuple{Any, Any, HistoricalStormTraceSimulation.TraceSampler}","page":"Home","title":"HistoricalStormTraceSimulation.computedistances!","text":"computedistances!(summary,history,sampler::TraceSampler)\n\nCompute the distances for a given summary to all historical summaries.\n\nNote: This overwrites memory in sampler and returns nothing. See samplesingletrace for argument details.\n\n\n\n\n\n","category":"method"},{"location":"#HistoricalStormTraceSimulation.conditional_expected_score-Tuple{Any, Any, HistoricalStormTraceSimulation.StormHistory, HistoricalStormTraceSimulation.TraceSampler, Any, Any, Any}","page":"Home","title":"HistoricalStormTraceSimulation.conditional_expected_score","text":"conditional_expected_score(summary,trace,history,sampler,rescalemethod,interpolation_method,tracescore)\n\nCompute the conditional expected score of a given historical trace. A different method will be used if the trace sampler uses a uniform over the closest m points method (i.e. if the sampler has a UnitRange for its samplemethod).\n\nArguments\n\nsummary: The summary of a historical trace.\ntrace: The corresponding trace.\nsampler: A TraceSampler.\nhistory, rescalemethod, interpolation_method: see sampletraces\ntracescore: Score for comparing traces.\n\n\n\n\n\n","category":"method"},{"location":"#HistoricalStormTraceSimulation.dataframes2storms-NTuple{4, Any}","page":"Home","title":"HistoricalStormTraceSimulation.dataframes2storms","text":"dataframes2storms(event_data, event_start_end, input_data, simulated_data)\n\nConvert dataframes containing storm parameters and data to traces and summaries for use in package.\n\nWill reorder variables to match up names of variables. Pass outputs to sampletraces function.\n\nArguments:\n\nevent_data - DataFrame containing summaries of historical storms.\nevent_start_end - DataFrame containing start and end indicies of events in input_data.\ninput_data - DataFrame containing historical time series.\nsimulated_data - DataFrame containing simulated storm summaries.\n\nOutputs:\n\nnew_summaries - Vector of summary vectors\nhistory - StormHistory object.\nsummary_names - Names of summary variables in order (traces are the same but one less variable (time is seperate)).\n\n\n\n\n\n","category":"method"},{"location":"#HistoricalStormTraceSimulation.expected_score-Tuple{HistoricalStormTraceSimulation.StormHistory}","page":"Home","title":"HistoricalStormTraceSimulation.expected_score","text":"expected_score(history::StormHistory; samplemethod=1:50, rescalemethod, summarymetric::Metric=Euclidean(), interpolation_method=LinearInterpolation, tracescore::TraceScore)\n\nCompute the expected score.\n\nArguments:\n\nhistory, samplemethod, rescalemethod, summarymetric, interpolation_method: see sampletraces.\ntracescore: Score for comparing traces.\n\n\n\n\n\n","category":"method"},{"location":"#HistoricalStormTraceSimulation.find_best_distance-Tuple{Type{<:Distances.Metric}, Any, Any}","page":"Home","title":"HistoricalStormTraceSimulation.find_best_distance","text":"find_best_distance(D::Type{<:Metric},x₀,history; lowerbounds, upperbounds, optim_kwargs=(), kwargs...)\n\nUse optim to find the best distance based on score_method scoring.\n\nArguments:\n\nD the type of distance (e.g. WeightedEuclidean). Note this is the type, not an instance!\nx₀ initial parameters for the distance to start optimisation.\nhistory the storm history.\nlowerbounds the lowerbounds for the optimisation, defaults to fill(-Inf,length(x₀)).\nupperbounds the upperbounds for the optimisation, defaults to fill(Inf,length(x₀)).\noptim_kwargs: Key word arguments to be passed to Optim.\nkwargs additional key word arguments, similar to score_method, but not including summarymetric, as this is specified by the optimisation.\n\n\n\n\n\n","category":"method"},{"location":"#HistoricalStormTraceSimulation.interpolatetrace","page":"Home","title":"HistoricalStormTraceSimulation.interpolatetrace","text":"interpolatetrace(trace,Δ,interpolation_method=LinearInterpolation)\n\nInterpolate a trace to a new resolution Δ.\n\nArguments\n\ntrace: The trace to be interpolated.\nΔ: The new time resolution.\ninterpolation_method: see docstring for sampletraces.\n\n\n\n\n\n","category":"function"},{"location":"#HistoricalStormTraceSimulation.nvariables-Tuple{HistoricalStormTraceSimulation.StormTrace}","page":"Home","title":"HistoricalStormTraceSimulation.nvariables","text":"nvariables(t::StormTrace)\n\nCompute the number of variable contained by a storm trace, including time.\n\nThis is size(t.value,2)+1.\n\n\n\n\n\n","category":"method"},{"location":"#HistoricalStormTraceSimulation.rescaletime-Tuple{Any, Any}","page":"Home","title":"HistoricalStormTraceSimulation.rescaletime","text":"rescaletime(time,duration)\n\nRescale the time to match the duration (d) and start at 0. The formula is, forall t in T_y\n\ntildet_t = (t-min T_y) fracdmax T_y - min T_y\n\nThen the time vector of tilde y is T_tildey = tildet_t mid t in T_y.\n\n\n\n\n\n","category":"method"},{"location":"#HistoricalStormTraceSimulation.rescaletrace!-Union{Tuple{N}, Tuple{HistoricalStormTraceSimulation.StormTrace, Any, Tuple{Vararg{HistoricalStormTraceSimulation.RescaleMethod, N}}}} where N","page":"Home","title":"HistoricalStormTraceSimulation.rescaletrace!","text":"rescaletrace!(trace::StormTrace,summary,rescalemethod::NTuple{N,RescaleMethod}) where {N}\n\nRescale a trace to match a summary.\n\nArguments\n\ntrace: The StormTrace to be adjusted.\nsummary: The summary to simulate a trace for.\nrescalemethod: see docstring for sampletraces.\n\n\n\n\n\n","category":"method"},{"location":"#HistoricalStormTraceSimulation.samplehistoricaltrace-Tuple{Any, Any, HistoricalStormTraceSimulation.TraceSampler}","page":"Home","title":"HistoricalStormTraceSimulation.samplehistoricaltrace","text":"samplehistoricaltrace(summary,history,sampler::TraceSampler)\n\nSample a historical trace from a history given a summary.\n\nSee samplesingletrace for argument details.\n\n\n\n\n\n","category":"method"},{"location":"#HistoricalStormTraceSimulation.samplesingletrace","page":"Home","title":"HistoricalStormTraceSimulation.samplesingletrace","text":"samplesingletrace(summary,history,sampler,rescalemethod,interpolation_method=LinearInterpolation)\n\nFunction to sample a trace given a summary and history.\n\nArguments\n\nsummary: The summary to simulate a trace for.\nhistory: The StormHistory to match to.\nsampler: Sampler of type TraceSampler.\nrescalemethod: see docstring for sampletraces.\ninterpolation_method: see docstring for sampletraces.\n\n\n\n\n\n","category":"function"},{"location":"#HistoricalStormTraceSimulation.simulatesinglefixedtrace-NTuple{5, Any}","page":"Home","title":"HistoricalStormTraceSimulation.simulatesinglefixedtrace","text":"simulatesinglefixedtrace()\n\nMethod to simulate a fixed trace based on rescaling the ith historical trace.\n\n\n\n\n\n","category":"method"}]
}
