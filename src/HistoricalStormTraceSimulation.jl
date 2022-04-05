module HistoricalStormTraceSimulation

include("rescalemethods.jl")
include("tracesampling.jl")

export sanmpletrace, StormHistory, RescaleMaxChangeMin, RescaleMaxPreserveMin, IdentityRescale

end
