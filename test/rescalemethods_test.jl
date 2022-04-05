import HistoricalStormTraceSimulation: rescalesinglevariable!

@testset "rescalemethods" begin
    @testset "IdentityRescale" begin
        a = rand(10); b = copy(a)
        rescalesinglevariable!(a,rand(),IdentityRescale())
        @test a == b
    end

    @testset "RescaleMaxChangeMin" begin
        x = rand(10); xmax = rand()
        x_origional = copy(x)
        rescalesinglevariable!(x,xmax,RescaleMaxChangeMin())
        @test maximum(x) == xmax
        @test argmax(x) == argmax(x_origional)
    end

    @testset "RescaleMaxPreserveMin" begin
        x = rand(10); xmax = rand()
        x_origional = copy(x)
        rescalesinglevariable!(x,xmax,RescaleMaxPreserveMin())
        @test maximum(x) == xmax
        @test argmax(x) == argmax(x_origional)
        @test minimum(x) == minimum(x_origional)
        @test argmax(x) == argmax(x_origional)
        @test argmin(x) == argmin(x_origional)
    end
end