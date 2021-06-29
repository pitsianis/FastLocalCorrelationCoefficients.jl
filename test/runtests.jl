using FastLocalCorrelationCoefficients
using Test
using Random

@testset "lcc equivalence" begin
    Random.seed!(0)

  x = randn(ComplexF64,7,8,9)
  y = randn(ComplexF64,2,3,4)

  @test maximum(abs.(flcc(x,y) - lcc(x,y))) <= 1e-14
end

@testset "FastLocalCorrelationCoefficients.jl" begin

  Random.seed!(0)

  # with precomputation
  haystack = randn(2^6)
  needle1 = rand(1) .* haystack[2:8] .+ rand(1)
  needle2 = rand(1) .* haystack[42:48] .+ rand(1)
  needle3 = rand(1) .* haystack[end-6:end] .+ rand(1)
  precomp = flcc(haystack,size(needle1))
  @test best_correlated(flcc(precomp,needle1)) == 2
  @test best_correlated(flcc(precomp,needle2)) == 42
  @test best_correlated(flcc(precomp,needle3)) == 2^6-6

  # with 2-d complex numbers and precomputation
  haystack = randn(Complex{Float64}, 2^6,2^6)
  needle1 = rand(1) .* haystack[2:8,3:9] .+ rand(1)
  needle2 = rand(1) .* haystack[42:48,43:49] .+ rand(1)
  needle3 = rand(1) .* haystack[end-6:end,end-6:end] .+ rand(1)
  precomp = flcc(haystack,size(needle1))
  @test best_correlated(flcc(precomp,needle1)) == CartesianIndex(2,3)
  @test best_correlated(flcc(precomp,needle2)) == CartesianIndex(42,43)
  @test best_correlated(flcc(precomp,needle3)) == CartesianIndex(2^6-6,2^6-6)

end

@testset "datatype vs dimensions" begin
  @testset "d = $d | $ntype | $fun" for d ∈ 1:4, ntype ∈ [Float32, Float64, ComplexF32, ComplexF64], fun ∈ [flcc, lcc]

    Random.seed!(0)

    needle_template = [1:4, 1:3, 1:3, 2:2];
    x = Int.( ones(d) .* ceil( 2 ^ (11 / d) ) ) .+ rand( -1:1, d);
    haystack = randn( ntype, x... );
    needle = haystack[ needle_template[1:d]... ]; # .* rand(1) .+ rand(1);

    isvalid = CartesianIndex( best_correlated(fun(haystack,needle)) ) ==
      CartesianIndex( getindex.( needle_template[1:d], 1)... )

    @test isvalid

  end
end
