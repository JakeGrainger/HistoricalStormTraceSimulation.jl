# Basic usage

The *HistoricalStormTraceSimulation.jl* package is designed to generate storm traces based on historical storms to match simulated storm characteristics.
There are two main interface functions which should be used:

```@docs
sampletraces
```

This is the main function used to generate traces from historical storms.

```@docs
dataframes2storms
```

This is a helper function to convert standard formats from other packages/languages to appropriate formats for this package.
Note that it is important that naming conventions are consistent across data frames for this function to work.

