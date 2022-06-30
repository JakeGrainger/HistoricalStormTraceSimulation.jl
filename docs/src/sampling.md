# Trace sampling

Trace sampling performs the following steps:
1) Draw a trace from the historical traces conditional on the summary.
2) Rescale the time to match the duration specified by the summary.
3) Interpolate the trace back to the original time resolution.
4) Rescale the trace based on the rescale rules.

Use `samplesingletrace` to perform this process for one trace.

```@docs
samplesingletrace
```

Sometimes, it is useful to fix which trace is chosen in step 1.
Use `samplesinglefixedtrace` to do this.

```@docs
samplesinglefixedtrace
```

## Sampling from the historical traces

The sampling depends on the chosen distribution and the chosen distance used to measure the similarity between summaries.

```@docs
samplehistoricaltrace
```

### Trace samplers

The method for trace sampling is specified by a `TraceSampler`.

```@docs
TraceSampler
computedistances!
```

## Rescaling time

Time rescaling of a trace can be done with `adjusttracetime`, which in turn calls `rescaletime` and then repacks as a StormTrace.

```@docs
adjusttracetime
rescaletime
```

## Interpolating the trace

Interpolation is performed with

```@docs
`interpolatetrace`
```

##  Rescaling the trace

Trace rescaling is performed by

```@docs
rescaletrace!
```

See [Rescale methods](@ref) for details of the available rescale methods.

