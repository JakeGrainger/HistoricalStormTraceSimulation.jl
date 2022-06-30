# Rescale Methods

Rescale methods define ways of rescaling a trace to match a summary.
They are defined to be subtypes of `RescaleMethod`.

The rescale method itself is defined by extending `rescalesinglevariable!` for the new type. For example:

```julia
struct RescaleMaxChangeMin <: RescaleMethod end
function rescalesinglevariable!(x::AbstractVector,y::Real,::RescaleMaxChangeMin)
    rescale = y/maximum(x)
    for i in eachindex(x)
        @inbounds x[i] *= rescale
    end
    nothing
end
```

is the implementation for `RescaleMaxChangeMin`.

The `rescaletrace!` function will call `rescalesinglevariable!` on each variable in a trace in turn, it takes a `Tuple` of `RescaleMethods` which allows for different rescales for different variables.


## Available Methods

```@docs
RescaleIdentity
RescaleMaxChangeMin
RescaleMaxPreserveMin
RescaleMean
```