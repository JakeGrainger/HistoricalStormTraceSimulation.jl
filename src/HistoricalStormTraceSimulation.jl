module HistoricalStormTraceSimulation

include("rescalemethods.jl")
include("tracesampling.jl")

export sampletrace, StormHistory, RescaleMaxChangeMin, RescaleMaxPreserveMin, IdentityRescale

end
