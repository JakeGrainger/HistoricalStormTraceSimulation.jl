import HistoricalStormTraceSimulation: rescalesinglevariable!, IdentityRescale, RescaleMaxChangeMin, RescaleMaxPreserveMin, rescaletime
import Random: randperm
import Random
Random.seed!(6266) # seed chosen at random
@testset "rescalemethods" begin
    @testset "IdentityRescale" begin
        x = randperm(20).*0.1; x_origional = copy(x)
        rescalesinglevariable!(x,rand(),IdentityRescale())
        @test x == x_origional
    end

    @testset "RescaleMaxChangeMin" begin
        for _ in 1:10 # test multiple random values
            x = randperm(20).*0.1; xmax = minimum(x)+rand()
            x_origional = copy(x)
            rescalesinglevariable!(x,xmax,RescaleMaxChangeMin())
            @test maximum(x) ≈ xmax
            @test argmax(x) == argmax(x_origional)
        end
    end

    @testset "RescaleMaxPreserveMin" begin
        for _ in 1:10  # test multiple random values
            x = randperm(20).*0.1; xmax = minimum(x)+rand()
            x_origional = copy(x)
            rescalesinglevariable!(x,xmax,RescaleMaxPreserveMin())
            @test maximum(x) ≈ xmax
            @test argmax(x) == argmax(x_origional)
            @test minimum(x) == minimum(x_origional)
            @test argmax(x) == argmax(x_origional)
            @test argmin(x) == argmin(x_origional)
            @test_logs (:warn,"new maximum is less than minimum, this results in incorrect scaling.") rescalesinglevariable!(x,minimum(x)-0.1,RescaleMaxPreserveMin())
        end
    end
    computeduration(x) = x[end]-x[1]
    @testset "rescaletime" begin
        @test computeduration(rescaletime(1:10,2)) == 2.0
        @test computeduration(rescaletime(1:0.1:10,3)) == 3.0
        @test computeduration(rescaletime(-10:0.1:10,3)) == 3.0
    end
end