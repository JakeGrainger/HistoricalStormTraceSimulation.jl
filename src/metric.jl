"""
    WeightedPeriodicEuclidean(p,w)
Create a weighted Euclidean metric on a rectangular periodic domain (i.e., a torus or
a cylinder). Periods per dimension are contained in the vector `p`, and weights in `w`:
```math
\\sqrt{\\sum_i w_i*(\\min\\mod(|x_i - y_i|, p_i), p_i - \\mod(|x_i - y_i|, p_i))^2}.
```
"""
struct WeightedPeriodicEuclidean{W} <: Distances.UnionMetric
    periods_weights::W
    function WeightedPeriodicEuclidean(periods,weights)
        length(periods) == length(weights) || throw(DimensionMismatch("periods and weights should be of the same length."))

        periods_weights = [(p,w) for (p,w) in zip(periods,weights)]
        new{typeof(periods_weights)}(periods_weights)
    end
end

Distances.parameters(w::WeightedPeriodicEuclidean) = w.periods_weights
@inline (dist::WeightedPeriodicEuclidean)(a, b) = Distances._evaluate(dist, a, b, Distances.parameters(dist))

Distances._eval_start(d::WeightedPeriodicEuclidean, ::Type{Ta}, ::Type{Tb}, p) where {Ta,Tb} =
    zero(typeof(Distances.eval_op(d, oneunit(Ta), oneunit(Tb), oneunittuple(eltype(p)) )))
oneunittuple(::Type{Tuple{A,B}}) where {A,B} = (oneunittuple(A), oneunittuple(B))
oneunittuple(::Type{A}) where {A} = oneunit(A)

@inline function Distances.eval_op(::WeightedPeriodicEuclidean, ai, bi, p)
    s1 = abs(ai - bi)
    s2 = mod(s1, p[1])
    s3 = min(s2, p[1] - s2)
    abs2(s3) * p[2]
end
Distances.eval_end(::WeightedPeriodicEuclidean, s) = sqrt(s)