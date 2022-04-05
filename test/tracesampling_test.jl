@testset "tracesampling" begin
    @testset "StormHistory" begin
        @test_throws DimensionMismatch StormHistory(ones(10),ones(9)) # throw error if not same number of summaries as traces
    end
end