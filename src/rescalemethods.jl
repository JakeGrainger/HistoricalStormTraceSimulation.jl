abstract type RescaleMethod end

""" 
    RescaleIdentity()

A rescale type to represent the identity rescale.
"""
struct RescaleIdentity <: RescaleMethod end
function rescalesinglevariable!(x::AbstractVector,y::Real,::RescaleIdentity)
    nothing
end

""" 
    RescaleMaxChangeMin()

Linear rescale to adjust the maximum of the new trace to equal the summary value.

Given a trace variable series ``y_j``, and summary value ``x_j``, the new trace 
``\\tilde{y}_j`` is constructed using the following rule, ``\\forall t\\in T_y``:

``\\tilde y_j(t) = \\frac{x_j}{\\max\\limits_{t\\in T_y}y_j(t)}y_j(t).``

"""
struct RescaleMaxChangeMin <: RescaleMethod end
function rescalesinglevariable!(x::AbstractVector,y::Real,::RescaleMaxChangeMin)
    rescale = y/maximum(x)
    for i in eachindex(x)
        @inbounds x[i] *= rescale
    end
    nothing
end

""" 
    RescaleMaxPreserveMin()

Linear rescale to adjust the maximum of the new trace to equal the summary value whilst preserving the minimum. 

Given a trace variable series ``y_j``, and summary value ``x_j``, the new trace 
``\\tilde{y}_j`` is constructed using the following rule, ``\\forall t\\in T_y``:

``\\tilde y_j(t) = \\frac{x_j-\\min\\limits_{t\\in T_y}  y_j(t)}{\\max\\limits_{t\\in T_y}y_j(t)-\\min\\limits_{t\\in T_y}  y_j(t)} \\left(y_j(t)-\\min\\limits_{t\\in T_y}  y_j(t)\\right) + \\min\\limits_{t\\in T_y}  y_j(t).``

This only works if the new maximum ``x_j`` satisfies ``x_j>\\min\\limits_{t\\in T_y}  y_j(t)``. The formula is ``\\forall t\\in T_y``.
If this condition is not satisfied, a warning will be displayed.
"""
struct RescaleMaxPreserveMin <: RescaleMethod end
function rescalesinglevariable!(x::AbstractVector,y::Real,::RescaleMaxPreserveMin)
    xmin = minimum(x)
    xmin < y || @warn "new maximum is less than minimum, this results in incorrect scaling."
    rescale = (y-xmin)/(maximum(x)-xmin)
    for i in eachindex(x)
        @inbounds x[i] = (x[i]-xmin)*rescale + xmin
    end
    nothing
end

""" 
    RescaleMean()

Additive rescaling to match the mean of the trace to the summary value.

Given a trace variable series ``y_j``, and summary value ``x_j``, the new trace 

``\\tilde y_j(t) = y_j(t) - \\overline{y_j} + x_j``

where ``\\overline{y_j} = \\frac{1}{|T_y|} \\sum_{t\\in T_y}y_j(t)``.
"""
struct RescaleMean <: RescaleMethod end
function rescalesinglevariable!(x::AbstractVector,y::Real,::RescaleMean)
    x .+= y-mean(x)
    nothing
end

""" 
    RescaleMeanCircularDeg()

Rescale the angular mean assuming data is in degrees.

Given a trace variable series ``y_j``, and summary value ``x_j``, the new trace 

``\\tilde y_j(t) = y_j(t) - \\overline{y_j} + x_j``

where ``\\overline{y_j} = \\arg\\left(\\frac{1}{|T_y|} \\sum_{t\\in T_y}\\exp\\{i y_j(t)\\}\\right)``.
"""
struct RescaleMeanCircularDeg <: RescaleMethod end
function rescalesinglevariable!(x::AbstractVector,y::Real,::RescaleMeanCircularDeg)
    x_cir_mean = rad2deg(angle(mean(exp(1im*deg2rad(xi)) for xi in x)))
    x .+= y-x_cir_mean
    nothing
end

"""
    rescaletime(time,duration)

Rescale the time to match the duration ``(d)`` and start at 0. The formula is, ``\\forall t \\in T_y``

``\\tilde{t}_t = (t-\\min T_y) \\frac{d}{\\max T_y - \\min T_y}.``

Then the time vector of ``\\tilde y`` is ``T_{\\tilde{y}} = \\{\\tilde{t}_t \\mid t \\in T_y\\}``.
"""
function rescaletime(time,duration)
    return range(0,duration,length=length(time)) # (time.-time[1]) .* (duration/(time[end]-time[1])) this is more stable
end