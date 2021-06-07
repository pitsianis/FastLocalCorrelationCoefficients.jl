using FastLocalCorrelationCoefficients
using Test
using Random

@testset "FastLocalCorrelationCoefficients.jl" begin

  Random.seed!(0)

  # 1-d find random
  haystack = rand(2^20)
  needle = rand(1) .* haystack[42:48] .+ rand(1)
  @test argmax(flcc(haystack,needle)) == 42

  # 2-d find random
  haystack = rand(2^10,2^10)
  needle = rand(1) .* haystack[42:48, 45:50] .+ rand(1)
  @test argmax(flcc(haystack,needle)) == CartesianIndex(42,45)

  # 3-d find random
  haystack = rand(2^7,2^7,2^6)
  needle = rand(1) .* haystack[42:48, 45:50, 47:52] .+ rand(1)
  @test argmax(flcc(haystack,needle)) == CartesianIndex(42,45,47)

  # 4-d find first
  haystack = rand(2^5,2^5,2^5,2^5)
  needle = rand(1) .* haystack[1:5, 1:4, 1:3, 1:2] .+ rand(1)
  @test argmax(flcc(haystack,needle)) == CartesianIndex(1,1,1,1)

  # 5-d find last
  haystack = rand(2^4,2^4,2^4,2^4,2^4)
  needle = rand(1) .* haystack[15:end, 14:end, 13:end, 12:end, 11:end] .+ rand(1)
  @test argmax(flcc(haystack,needle)) == CartesianIndex(15,14,13,12,11)

  # with precomputation
  haystack = rand(2^20)
  needle1 = rand(1) .* haystack[2:8] .+ rand(1)
  needle2 = rand(1) .* haystack[42:48] .+ rand(1)
  needle3 = rand(1) .* haystack[end-6:end] .+ rand(1)
  precomp = flccPrec(haystack,size(needle1))
  @test argmax(flccComp(precomp,needle3)) == 2^20-6
  @test argmax(flccComp(precomp,needle1)) == 2
  @test argmax(flccComp(precomp,needle2)) == 42

  # with complex numbers
  haystack = rand(Complex{Float64}, 2^7,2^7,2^6)
  needle = rand(1) .* haystack[42:48, 45:50, 47:52] .+ rand(1)
  @test argmax(flcc(haystack,needle)) == CartesianIndex(42,45,47)

  # with 2-d complex numbers and precomputation
  haystack = rand(Complex{Float64}, 2^8,2^8)
  needle1 = rand(1) .* haystack[2:8,3:9] .+ rand(1)
  needle2 = rand(1) .* haystack[42:48,43:49] .+ rand(1)
  needle3 = rand(1) .* haystack[end-6:end,end-6:end] .+ rand(1)
  precomp = flccPrec(haystack,size(needle1))
  @test argmax(flccComp(precomp,needle3)) == CartesianIndex(2^8-6,2^8-6)
  @test argmax(flccComp(precomp,needle1)) == CartesianIndex(2,3)
  @test argmax(flccComp(precomp,needle2)) == CartesianIndex(42,43)

end

@testset "datatype vs dimensions" begin
  @testset "d = $d | $ntype | $fun" for d ∈ 1:4, ntype ∈ [Float32, Float64, ComplexF32, ComplexF64], fun ∈ [flcc, lcc]

    Random.seed!(0)

    needle_template = [1:4, 1:3, 1:3, 2:2];
    x = Int.( ones(d) .* ceil( 2 ^ (11 / d) ) ) .+ rand( -1:1, d);
    haystack = rand( ntype, x... );
    needle = haystack[ needle_template[1:d]... ]; # .* rand(1) .+ rand(1);

    isvalid = CartesianIndex( argmax(fun(haystack,needle)) ) ==
      CartesianIndex( getindex.( needle_template[1:d], 1)... )

    @test isvalid

  end
end
