var documenterSearchIndex = {"docs":
[{"location":"rescalemethods/#Rescale-methods","page":"Rescale Methods","title":"Rescale methods","text":"","category":"section"},{"location":"rescalemethods/","page":"Rescale Methods","title":"Rescale Methods","text":"Rescale methods define ways of rescaling a trace to match a summary. They are defined to be subtypes of RescaleMethod, e.g.","category":"page"},{"location":"rescalemethods/","page":"Rescale Methods","title":"Rescale Methods","text":"The rescale method itself is defined by extending rescalesinglevariable! for the new type. For example:","category":"page"},{"location":"rescalemethods/","page":"Rescale Methods","title":"Rescale Methods","text":"struct RescaleMaxChangeMin <: RescaleMethod end\nfunction rescalesinglevariable!(x::AbstractVector,y::Real,::RescaleMaxChangeMin)\n    rescale = y/maximum(x)\n    for i in eachindex(x)\n        @inbounds x[i] *= rescale\n    end\n    nothing\nend","category":"page"},{"location":"rescalemethods/","page":"Rescale Methods","title":"Rescale Methods","text":"is the implementation for RescaleMaxChangeMin.","category":"page"},{"location":"rescalemethods/","page":"Rescale Methods","title":"Rescale Methods","text":"The rescaletrace! function will call rescalesinglevariable! on each variable in a trace in turn, it takes a Tuple of RescaleMethods which allows for different rescales for different variables.","category":"page"},{"location":"rescalemethods/#Available-methods","page":"Rescale Methods","title":"Available methods","text":"","category":"section"},{"location":"rescalemethods/","page":"Rescale Methods","title":"Rescale Methods","text":"RescaleIdentity\nRescaleMaxChangeMin\nRescaleMaxPreserveMin\nRescaleMean","category":"page"},{"location":"tracescore/#Trace-scoring","page":"Trace Scoring","title":"Trace scoring","text":"","category":"section"},{"location":"tracescore/","page":"Trace Scoring","title":"Trace Scoring","text":"Trace scores can be specified as a subtype of TraceScore. A functor should then be defined taking in two traces, which returns a measure of similarity between the two, with 0 being identical.","category":"page"},{"location":"tracescore/","page":"Trace Scoring","title":"Trace Scoring","text":"Provided is MarginalTraceScore which allows the user to define weighted sums of scores (usually metrics) applied to each variable.","category":"page"},{"location":"tracescore/","page":"Trace Scoring","title":"Trace Scoring","text":"MarginalTraceScore","category":"page"},{"location":"tracescore/#Implementing-new-methods","page":"Trace Scoring","title":"Implementing new methods","text":"","category":"section"},{"location":"tracescore/","page":"Trace Scoring","title":"Trace Scoring","text":"New methods can be implemented by analogy to the implementation for MarginalTraceScore:","category":"page"},{"location":"tracescore/","page":"Trace Scoring","title":"Trace Scoring","text":"struct MarginalTraceScore{T,S} <: TraceScore\n    metrics::T\n    weights::S\n    function MarginalTraceScore(metrics::NTuple{N,Metric},weights=ones(length(metrics))) where {N}\n        length(metrics) == length(weights) || throw(DimensionMismatch(\"weights and metrics should be same length.\"))\n        new{typeof(metrics),typeof(weights)}(metrics,weights)\n    end\nend\n\nfunction (mscore::MarginalTraceScore)(t1::StormTrace,t2::StormTrace)\n    checkcompatible(t1,t2)\n    checkcompatible(mscore,t1)\n    score = 0.0\n    for i in eachindex(mscore.metrics)\n        @views score += mscore.weights[i]*mscore.metrics[i](t1.value[:,i],t2.value[:,i])\n    end\n    return score\nend","category":"page"},{"location":"basics/#Basic-usage","page":"Getting Started","title":"Basic usage","text":"","category":"section"},{"location":"basics/","page":"Getting Started","title":"Getting Started","text":"The HistoricalStormTraceSimulation.jl package is designed to generate storm traces based on historical storms to match simulated storm characteristics. There are two main interface functions which should be used:","category":"page"},{"location":"basics/#Sample-traces","page":"Getting Started","title":"Sample traces","text":"","category":"section"},{"location":"basics/","page":"Getting Started","title":"Getting Started","text":"sampletraces","category":"page"},{"location":"basics/#HistoricalStormTraceSimulation.sampletraces","page":"Getting Started","title":"HistoricalStormTraceSimulation.sampletraces","text":"sampletraces(new_summaries, historical_summaries, historical_traces; samplemethod=1:50, rescalemethod)\n\nSample new traces given summaries based on modifications of historical traces.\n\nArguments\n\nnew_summaries: Vector of summaries to generate traces for.\nhistory: Storm history information of type StormHistory. Best constructed using dataframes2storms function.\nsamplemethod: Method for sampling from closest points. Passing 1:m will sample uniformly from the closest m points. Defaults to 1:50. Could also be a Distribution. Note that if a Distribution is used, then it should be discrete, and should be defined on 1:n where n is the number of historical storms.\nrescalemethod: Tuple of methods for rescaling (one for each column of the trace). Should be a subtype of type RescaleMethod.\nsummarymetric: A metric for determining closeness of storm summaries (must be subtype of Metric). Default is Euclidean().\ninterpolation_method: Method for performing interpolation. LinearInterpolation is the default, but CubicSplineInterpolation may be preferable in some contexts (though it is much slower).\n\nRescaleMethods\n\nRescaleIdentity(): The identity (no rescale).\nRescaleMean(): Rescale the mean to match provided mean.\nRescaleMaxChangeMin(): Rescale the maximum to match provided maximum, using linear scaling and changing the minimum.\nRescaleMaxPreserveMin(): Rescale the maximum to match provided maximum, using linear scaling but preserving the minimum\n\n\n\n\n\n","category":"function"},{"location":"basics/","page":"Getting Started","title":"Getting Started","text":"This is the main function used to generate traces from historical storms.","category":"page"},{"location":"basics/#Converting-data-to-internal-types","page":"Getting Started","title":"Converting data to internal types","text":"","category":"section"},{"location":"basics/","page":"Getting Started","title":"Getting Started","text":"This package uses its own types to conveniently represent the concepts it deals with. In particular, types for representing storm traces and summaries. Data of this kind usually comes from outputs of other software, which usually is in the form of named data frames. The dataframes2storms function converts such data frames to the correct format for the package.","category":"page"},{"location":"basics/","page":"Getting Started","title":"Getting Started","text":"dataframes2storms","category":"page"},{"location":"basics/#HistoricalStormTraceSimulation.dataframes2storms","page":"Getting Started","title":"HistoricalStormTraceSimulation.dataframes2storms","text":"dataframes2storms(event_data, event_start_end, input_data, simulated_data)\n\nConvert dataframes containing storm parameters and data to traces and summaries for use in package.\n\nWill reorder variables to match up names of variables. Pass outputs to sampletraces function.\n\nArguments:\n\nevent_data - DataFrame containing summaries of historical storms.\nevent_start_end - DataFrame containing start and end indices of events in input_data.\ninput_data - DataFrame containing historical time series.\nsimulated_data - DataFrame containing simulated storm summaries.\n\nOutputs:\n\nnew_summaries - Vector of summary vectors.\nhistory - StormHistory object.\nsummary_names - Names of summary variables in order (traces are the same but one less variable (time is separate)).\n\n\n\n\n\n","category":"function"},{"location":"basics/","page":"Getting Started","title":"Getting Started","text":"The arguments event_data and simulated data are the storm summaries, input_data is the complete time series (including the non-extreme time periods), and event_start_end is a data frame with column 1 containing the start index for a storm, and column 2 containing the end index. Note that this should be 1-indexed, not 0-indexed!","category":"page"},{"location":"basics/","page":"Getting Started","title":"Getting Started","text":"Note that it is important that naming conventions are consistent across data frames for this function to work.","category":"page"},{"location":"","page":"Home","title":"Home","text":"CurrentModule = HistoricalStormTraceSimulation","category":"page"},{"location":"#HistoricalStormTraceSimulation","page":"Home","title":"HistoricalStormTraceSimulation","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Documentation for HistoricalStormTraceSimulation. A Julia package for simulating storm traces based on historical trace matching. See getting started for an introduction, or see the index for a list of functions and types.","category":"page"},{"location":"docstrings/","page":"Index","title":"Index","text":"","category":"page"},{"location":"docstrings/","page":"Index","title":"Index","text":"Modules = [HistoricalStormTraceSimulation]","category":"page"},{"location":"docstrings/#HistoricalStormTraceSimulation.MarginalTraceScore","page":"Index","title":"HistoricalStormTraceSimulation.MarginalTraceScore","text":"MarginalTraceScore(metrics::NTuple{N,Metric},weights=ones(length(metrics)))\n\nConstruct a scoring method for traces based on a weighted some of marginal metrics.\n\nArguments\n\nmetrics: Should be a tuple of p metrics, where p is the number of variables in the trace of interest (not including time).\nweights: A vector of weights to be used (defaults to vector of ones).\n\nUse\n\nGiven a MarginalTraceScore called mscore.\n\n(mscore::MarginalTraceScore)(t1::StormTrace,t2::StormTrace)\n\nwill compute the marginal trace score between two traces t1 and t2.\n\n\n\n\n\n","category":"type"},{"location":"docstrings/#HistoricalStormTraceSimulation.RescaleIdentity","page":"Index","title":"HistoricalStormTraceSimulation.RescaleIdentity","text":"RescaleIdentity()\n\nA rescale type to represent the identity rescale.\n\n\n\n\n\n","category":"type"},{"location":"docstrings/#HistoricalStormTraceSimulation.RescaleMaxChangeMin","page":"Index","title":"HistoricalStormTraceSimulation.RescaleMaxChangeMin","text":"RescaleMaxChangeMin()\n\nLinear rescale to adjust the maximum of the new trace to equal the summary value.\n\nGiven a trace variable series y_j, and summary value x_j, the new trace  tildey_j is constructed using the following rule, forall tin T_y:\n\ntilde y_j(t) = fracx_jmaxlimits_tin T_yy_j(t)y_j(t)\n\n\n\n\n\n","category":"type"},{"location":"docstrings/#HistoricalStormTraceSimulation.RescaleMaxPreserveMin","page":"Index","title":"HistoricalStormTraceSimulation.RescaleMaxPreserveMin","text":"RescaleMaxPreserveMin()\n\nLinear rescale to adjust the maximum of the new trace to equal the summary value whilst preserving the minimum. \n\nGiven a trace variable series y_j, and summary value x_j, the new trace  tildey_j is constructed using the following rule, forall tin T_y:\n\ntilde y_j(t) = fracx_j-minlimits_tin T_y  y_j(t)maxlimits_tin T_yy_j(t)-minlimits_tin T_y  y_j(t) left(y_j(t)-minlimits_tin T_y  y_j(t)right) + minlimits_tin T_y  y_j(t)\n\nThis only works if the new maximum x_j satisfies x_jminlimits_tin T_y  y_j(t). The formula is forall tin T_y. If this condition is not satisfied, a warning will be displayed.\n\n\n\n\n\n","category":"type"},{"location":"docstrings/#HistoricalStormTraceSimulation.RescaleMean","page":"Index","title":"HistoricalStormTraceSimulation.RescaleMean","text":"RescaleMean()\n\nAdditive rescaling to match the mean of the trace to the summary value.\n\nGiven a trace variable series y_j, and summary value x_j, the new trace \n\ntilde y_j(t) = y_j(t) - overliney_j + x_j\n\nwhere overliney_j = frac1T_y sum_tin T_yy_j(t).\n\n\n\n\n\n","category":"type"},{"location":"docstrings/#HistoricalStormTraceSimulation.StormHistory","page":"Index","title":"HistoricalStormTraceSimulation.StormHistory","text":"StormHistory(summaries,traces)\n\nFor storing historical storms.\n\nArguments\n\nsummaries: Should be a vector of vectors each of length q, containing summaries of storms.\ntraces: Should be a vector of StormTraces, each satisfying nvariables(t)==q.\n\n\n\n\n\n","category":"type"},{"location":"docstrings/#HistoricalStormTraceSimulation.StormTrace","page":"Index","title":"HistoricalStormTraceSimulation.StormTrace","text":"StormTrace(value,time)\n\nConstruct a StormTrace type used for storing a storm type.\n\nArguments\n\nvalue: A matrix of floats which is n × p.\ntime: An abstract range of length n.\n\n\n\n\n\n","category":"type"},{"location":"docstrings/#HistoricalStormTraceSimulation.TraceSampler","page":"Index","title":"HistoricalStormTraceSimulation.TraceSampler","text":"TraceSampler(d,samplemethod,n::Int)\n\nArguments\n\nsummarymetric: A metric for determining closeness of storm summaries (must be subtype of Metric). Default is Euclidean().\nsamplemethod: Method for sampling from closest points. Passing 1:m will sample uniformly from the closest m points. Defaults to 1:50. Could also be a Distribution.\nn: The number of storms.\n\nNote\n\nThere is an alternate constructor      TraceSampler(summarymetric,samplemethod,distance_store,distance_index) this is an internal feature, distance_store and distance_index are constructed based on n in the other constructor. Their purpose is to preallocate distance storage and improve performance.\n\n\n\n\n\n","category":"type"},{"location":"docstrings/#Base.length-Tuple{HistoricalStormTraceSimulation.StormHistory}","page":"Index","title":"Base.length","text":"length(s::StormHistory)\n\nCompute the length of a StormHistory, i.e. the number of storms contained in the history.\n\n\n\n\n\n","category":"method"},{"location":"docstrings/#Base.length-Tuple{HistoricalStormTraceSimulation.StormTrace}","page":"Index","title":"Base.length","text":"length(t::StormTrace)\n\nCompute the length of a StormTrace, which is the number of time points (not total number of elements).\n\n\n\n\n\n","category":"method"},{"location":"docstrings/#HistoricalStormTraceSimulation.adjusttracetime-Tuple{Any, Any}","page":"Index","title":"HistoricalStormTraceSimulation.adjusttracetime","text":"adjusttracetime(trace, summary)\n\nAdjust the time of a trace based on a summary (just calls rescaletime and then repacks in a StormTrace).\n\n\n\n\n\n","category":"method"},{"location":"docstrings/#HistoricalStormTraceSimulation.checkcompatible-Tuple{HistoricalStormTraceSimulation.StormTrace, HistoricalStormTraceSimulation.StormTrace}","page":"Index","title":"HistoricalStormTraceSimulation.checkcompatible","text":"checkcompatible(t1::StormTrace,t2::StormTrace)\n\nCheck two traces are compatible.\n\n\n\n\n\n","category":"method"},{"location":"docstrings/#HistoricalStormTraceSimulation.checkcompatible-Tuple{MarginalTraceScore, HistoricalStormTraceSimulation.StormTrace}","page":"Index","title":"HistoricalStormTraceSimulation.checkcompatible","text":"checkcompatible(m::MarginalTraceScore,t::StormTrace)\n\nCheck trace is compatible with MarginalTraceScore.\n\n\n\n\n\n","category":"method"},{"location":"docstrings/#HistoricalStormTraceSimulation.computedistances!-Tuple{Any, Any, HistoricalStormTraceSimulation.TraceSampler}","page":"Index","title":"HistoricalStormTraceSimulation.computedistances!","text":"computedistances!(summary,history,sampler::TraceSampler)\n\nCompute the distances for a given summary to all historical summaries.\n\nNote: This overwrites memory in sampler and returns nothing. See samplesingletrace for argument details.\n\n\n\n\n\n","category":"method"},{"location":"docstrings/#HistoricalStormTraceSimulation.conditional_expected_score-Tuple{Any, Any, HistoricalStormTraceSimulation.StormHistory, HistoricalStormTraceSimulation.TraceSampler, Any, Any, Any}","page":"Index","title":"HistoricalStormTraceSimulation.conditional_expected_score","text":"conditional_expected_score(summary,trace,history,sampler,rescalemethod,interpolation_method,tracescore)\n\nCompute the conditional expected score of a given historical trace. A different method will be used if the trace sampler uses a uniform over the closest m points method (i.e. if the sampler has a UnitRange for its samplemethod).\n\nArguments\n\nsummary: The summary of a historical trace.\ntrace: The corresponding trace.\nsampler: A TraceSampler.\nhistory, rescalemethod, interpolation_method: see sampletraces\ntracescore: Score for comparing traces.\n\n\n\n\n\n","category":"method"},{"location":"docstrings/#HistoricalStormTraceSimulation.dataframes2storms-NTuple{4, Any}","page":"Index","title":"HistoricalStormTraceSimulation.dataframes2storms","text":"dataframes2storms(event_data, event_start_end, input_data, simulated_data)\n\nConvert dataframes containing storm parameters and data to traces and summaries for use in package.\n\nWill reorder variables to match up names of variables. Pass outputs to sampletraces function.\n\nArguments:\n\nevent_data - DataFrame containing summaries of historical storms.\nevent_start_end - DataFrame containing start and end indices of events in input_data.\ninput_data - DataFrame containing historical time series.\nsimulated_data - DataFrame containing simulated storm summaries.\n\nOutputs:\n\nnew_summaries - Vector of summary vectors.\nhistory - StormHistory object.\nsummary_names - Names of summary variables in order (traces are the same but one less variable (time is separate)).\n\n\n\n\n\n","category":"method"},{"location":"docstrings/#HistoricalStormTraceSimulation.expected_score-Tuple{HistoricalStormTraceSimulation.StormHistory}","page":"Index","title":"HistoricalStormTraceSimulation.expected_score","text":"expected_score(history::StormHistory; samplemethod=1:50, rescalemethod, summarymetric::Metric=Euclidean(), interpolation_method=LinearInterpolation, tracescore::TraceScore)\n\nCompute the expected score.\n\nArguments:\n\nhistory, samplemethod, rescalemethod, summarymetric, interpolation_method: see sampletraces.\ntracescore: Score for comparing traces.\n\n\n\n\n\n","category":"method"},{"location":"docstrings/#HistoricalStormTraceSimulation.find_best_distance-Tuple{Type{<:Distances.Metric}, Any, Any}","page":"Index","title":"HistoricalStormTraceSimulation.find_best_distance","text":"find_best_distance(D::Type{<:Metric},x₀,history; lowerbounds, upperbounds, optim_kwargs=(), kwargs...)\n\nUse optim to find the best distance based on score_method scoring.\n\nArguments:\n\nD the type of distance (e.g. WeightedEuclidean). Note this is the type, not an instance!\nx₀ initial parameters for the distance to start optimisation.\nhistory the storm history.\nlowerbounds the lower bounds for the optimisation, defaults to fill(-Inf,length(x₀)).\nupperbounds the upper bounds for the optimisation, defaults to fill(Inf,length(x₀)).\noptim_kwargs: Key word arguments to be passed to Optim.\nkwargs additional key word arguments, similar to score_method, but not including summarymetric, as this is specified by the optimisation.\n\n\n\n\n\n","category":"method"},{"location":"docstrings/#HistoricalStormTraceSimulation.interpolatetrace","page":"Index","title":"HistoricalStormTraceSimulation.interpolatetrace","text":"interpolatetrace(trace,Δ,interpolation_method=LinearInterpolation)\n\nInterpolate a trace to a new resolution Δ.\n\nArguments\n\ntrace: The trace to be interpolated.\nΔ: The new time resolution.\ninterpolation_method: see docstring for sampletraces.\n\n\n\n\n\n","category":"function"},{"location":"docstrings/#HistoricalStormTraceSimulation.nvariables-Tuple{HistoricalStormTraceSimulation.StormTrace}","page":"Index","title":"HistoricalStormTraceSimulation.nvariables","text":"nvariables(t::StormTrace)\n\nCompute the number of variable contained by a storm trace, including time.\n\nThis is size(t.value,2)+1.\n\n\n\n\n\n","category":"method"},{"location":"docstrings/#HistoricalStormTraceSimulation.rescaletime-Tuple{Any, Any}","page":"Index","title":"HistoricalStormTraceSimulation.rescaletime","text":"rescaletime(time,duration)\n\nRescale the time to match the duration (d) and start at 0. The formula is, forall t in T_y\n\ntildet_t = (t-min T_y) fracdmax T_y - min T_y\n\nThen the time vector of tilde y is T_tildey = tildet_t mid t in T_y.\n\n\n\n\n\n","category":"method"},{"location":"docstrings/#HistoricalStormTraceSimulation.rescaletrace!-Union{Tuple{N}, Tuple{HistoricalStormTraceSimulation.StormTrace, Any, Tuple{Vararg{HistoricalStormTraceSimulation.RescaleMethod, N}}}} where N","page":"Index","title":"HistoricalStormTraceSimulation.rescaletrace!","text":"rescaletrace!(trace::StormTrace,summary,rescalemethod::NTuple{N,RescaleMethod}) where {N}\n\nRescale a trace to match a summary.\n\nArguments\n\ntrace: The StormTrace to be adjusted.\nsummary: The summary to simulate a trace for.\nrescalemethod: see docstring for sampletraces.\n\n\n\n\n\n","category":"method"},{"location":"docstrings/#HistoricalStormTraceSimulation.samplehistoricaltrace-Tuple{Any, Any, HistoricalStormTraceSimulation.TraceSampler}","page":"Index","title":"HistoricalStormTraceSimulation.samplehistoricaltrace","text":"samplehistoricaltrace(summary,history,sampler::TraceSampler)\n\nSample a historical trace from a history given a summary.\n\nSee samplesingletrace for argument details.\n\n\n\n\n\n","category":"method"},{"location":"docstrings/#HistoricalStormTraceSimulation.samplesingletrace","page":"Index","title":"HistoricalStormTraceSimulation.samplesingletrace","text":"samplesingletrace(summary,history,sampler,rescalemethod,interpolation_method=LinearInterpolation)\n\nFunction to sample a trace given a summary and history.\n\nArguments\n\nsummary: The summary to simulate a trace for.\nhistory: The StormHistory to match to.\nsampler: Sampler of type TraceSampler.\nrescalemethod: see docstring for sampletraces.\ninterpolation_method: see docstring for sampletraces.\n\n\n\n\n\n","category":"function"},{"location":"docstrings/#HistoricalStormTraceSimulation.sampletraces-Tuple{Any, HistoricalStormTraceSimulation.StormHistory}","page":"Index","title":"HistoricalStormTraceSimulation.sampletraces","text":"sampletraces(new_summaries, historical_summaries, historical_traces; samplemethod=1:50, rescalemethod)\n\nSample new traces given summaries based on modifications of historical traces.\n\nArguments\n\nnew_summaries: Vector of summaries to generate traces for.\nhistory: Storm history information of type StormHistory. Best constructed using dataframes2storms function.\nsamplemethod: Method for sampling from closest points. Passing 1:m will sample uniformly from the closest m points. Defaults to 1:50. Could also be a Distribution. Note that if a Distribution is used, then it should be discrete, and should be defined on 1:n where n is the number of historical storms.\nrescalemethod: Tuple of methods for rescaling (one for each column of the trace). Should be a subtype of type RescaleMethod.\nsummarymetric: A metric for determining closeness of storm summaries (must be subtype of Metric). Default is Euclidean().\ninterpolation_method: Method for performing interpolation. LinearInterpolation is the default, but CubicSplineInterpolation may be preferable in some contexts (though it is much slower).\n\nRescaleMethods\n\nRescaleIdentity(): The identity (no rescale).\nRescaleMean(): Rescale the mean to match provided mean.\nRescaleMaxChangeMin(): Rescale the maximum to match provided maximum, using linear scaling and changing the minimum.\nRescaleMaxPreserveMin(): Rescale the maximum to match provided maximum, using linear scaling but preserving the minimum\n\n\n\n\n\n","category":"method"},{"location":"docstrings/#HistoricalStormTraceSimulation.simulatesinglefixedtrace-NTuple{5, Any}","page":"Index","title":"HistoricalStormTraceSimulation.simulatesinglefixedtrace","text":"simulatesinglefixedtrace()\n\nMethod to simulate a fixed trace based on rescaling the ith historical trace.\n\n\n\n\n\n","category":"method"}]
}
