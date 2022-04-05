abstract type RescaleMethod end

struct IdentityRescale <: RescaleMethod end
function rescalesinglevariable!(x::AbstractVector,y::Real,::IdentityRescale)
    nothing
end

struct RescaleMaxChangeMin <: RescaleMethod end
function rescalesinglevariable!(x::AbstractVector,y::Real,::RescaleMaxChangeMin)
    rescale = y/maximum(x)
    for i in eachindex(x)
        @inbounds x[i] *= rescale
    end
    nothing
end

struct RescaleMaxPreserveMin <: RescaleMethod end
function rescalesinglevariable!(x::AbstractVector,y::Real,::RescaleMaxPreserveMin)
    xmin = minimum(x)
    rescale = (y-xmin)/maximum(x)
    for i in eachindex(x)
        @inbounds x[i] = (x[i]-xmin)*rescale + xmin
    end
    nothing
end