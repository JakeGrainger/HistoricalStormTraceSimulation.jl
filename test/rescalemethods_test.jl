import HistoricalStormTraceSimulation: rescalesinglevariable!, IdentityRescale, RescaleMaxChangeMin, RescaleMaxPreserveMin, rescaletime
import Random: randperm
@testset "rescalemethods" begin
    @testset "IdentityRescale" begin
        x = randperm(20).*0.1; x_origional = copy(x)
        rescalesinglevariable!(a,rand(),IdentityRescale())
        @test x == x_origional
    end

    @testset "RescaleMaxChangeMin" begin
        x = randperm(20).*0.1; xmax = rand()
        x_origional = copy(x)
        rescalesinglevariable!(x,xmax,RescaleMaxChangeMin())
        @test maximum(x) ≈ xmax
        @test argmax(x) == argmax(x_origional)
    end

    @testset "RescaleMaxPreserveMin" begin
        x = randperm(20).*0.1; xmax = rand()
        x_origional = copy(x)
        rescalesinglevariable!(x,xmax,RescaleMaxPreserveMin())
        @test maximum(x) ≈ xmax
        @test argmax(x) == argmax(x_origional)
        @test minimum(x) == minimum(x_origional)
        @test argmax(x) == argmax(x_origional)
        @test argmin(x) == argmin(x_origional)
    end
    computeduration(x) = x[end]-x[1]
    @testset "rescaletime" begin
        @test computeduration(rescaletime(1:10,2)) == 2.0
        @test computeduration(rescaletime(1:0.1:10,3)) == 3.0
        @test computeduration(rescaletime(-10:0.1:10,3)) == 3.0
    end
end