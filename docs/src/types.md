# Internal Types

There are two important objects when thinking about trace rescaling.
First is the storm trace, and second is its summary.
We store the trace as a `StormTrace` and the summary as a `Vector{Float64}`.
A history of storm traces and summaries is then stored as a `StormHistory`.

## Storm Traces

The storm trace type contains both the time points (a range) and the values (a matrix).

```@docs
StormTrace
```

You can compute the number of variables using 

```@docs
nvariables
```

You can compute the length (number of time points) with

```@docs
length(::StormTrace)
```

## Storm History

```@docs
StormHistory
```

You can compute the number of storms with

```@docs
length(::StormHistory)
```