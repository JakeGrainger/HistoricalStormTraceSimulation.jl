## copied from the tests of Distances.jl

function test_metricity(dist, x, y, z)
    @testset "Test metricity of $(typeof(dist))" begin
        @test dist(x, y) == evaluate(dist, x, y)

        dxy = dist(x, y)
        dxz = dist(x, z)
        dyz = dist(y, z)
        if isa(dist, PreMetric)
            # Unfortunately small non-zero numbers (~10^-16) are appearing
            # in our tests due to accumulating floating point rounding errors.
            # We either need to allow small errors in our tests or change the
            # way we do accumulations...
            @test dist(x, x) + one(eltype(x)) ≈ one(eltype(x))
            @test dist(y, y) + one(eltype(y)) ≈ one(eltype(y))
            @test dist(z, z) + one(eltype(z)) ≈ one(eltype(z))
            @test dxy ≥ zero(eltype(x))
            @test dxz ≥ zero(eltype(x))
            @test dyz ≥ zero(eltype(x))
        end
        if isa(dist, SemiMetric)
            @test dxy ≈ dist(y, x)
            @test dxz ≈ dist(z, x)
            @test dyz ≈ dist(y, z)
        else # Not symmetric, so more PreMetric tests
            @test dist(y, x) ≥ zero(eltype(x))
            @test dist(z, x) ≥ zero(eltype(x))
            @test dist(z, y) ≥ zero(eltype(x))
        end
        if isa(dist, Metric)
            # Again we have small rounding errors in accumulations
            @test dxz ≤ dxy + dyz || dxz ≈ dxy + dyz
            dyx = dist(y, x)
            @test dyz ≤ dyx + dxz || dyz ≈ dyx + dxz
            dzy = dist(z, y)
            @test dxy ≤ dxz + dzy || dxy ≈ dxz + dzy
        end
    end
end

@testset "metric.jl" begin
    test_metricity(WeightedPeriodicEuclidean([0.5,0.5,Inf],[1,2,1]),[1.0,2.3,4.0],[5.0,2.0,1.0],[5.0,2.0,7.3])
    @test_throws DimensionMismatch WeightedPeriodicEuclidean([0.5,0.5,Inf],[1,2])
end