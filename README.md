# HistoricalStormTraceSimulation

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://JakeGrainger.github.io/HistoricalStormTraceSimulation.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://JakeGrainger.github.io/HistoricalStormTraceSimulation.jl/dev)
[![Build Status](https://github.com/JakeGrainger/HistoricalStormTraceSimulation.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/JakeGrainger/HistoricalStormTraceSimulation.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/JakeGrainger/HistoricalStormTraceSimulation.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/JakeGrainger/HistoricalStormTraceSimulation.jl)

A Julia package for simulating storm traces based on historical trace matching.
- Allows specification of distance for comparing traces, the distribution for simulation, and rescaling rules.
- Provides a framework which is easy to extend, and a convenient representation for traces.
- Contains routines for tuning distances based on the expected score of trace distributions vs the provided historical traces, with the option to use arbitrary scores.