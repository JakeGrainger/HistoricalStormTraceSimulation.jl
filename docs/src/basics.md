# Getting Started

## Installation

The package can be installed from the repl using
```julia-repl
(v1.7) pkg> add https://github.com/JakeGrainger/HistoricalStormTraceSimulation.jl
```

There are two main interface functions which should be used:

## Sample Traces

```@docs
sampletraces
```

This is the main function used to generate traces from historical storms.
This package provides an additional metric for periodic Weighted Euclidean distance:

```@docs
WeightedPeriodicEuclidean
```

## Converting Data to Internal Types

This package uses its own types to conveniently represent the concepts it deals with. In particular, types for representing storm traces and summaries.
Data of this kind usually comes from outputs of other software, which usually is in the form of named data frames. The `dataframes2storms` function converts such data frames to the correct format for the package.

```@docs
dataframes2storms
```

The arguments `event_data` and `simulated data` are the storm summaries, `input_data` is the complete time series (including the non-extreme time periods), and `event_start_end` is a data frame with column 1 containing the start index for a storm, and column 2 containing the end index. **Note that this should be 1-indexed, not 0-indexed!**

Note that it is important that naming conventions are consistent across data frames for this function to work.

