using FastLocalCorrelationCoefficients
using Test
using Distributed
using CUDA


function run_test()
    @everywhere @eval using DistributedArrays

    sF = (2^10, 2^10)
    F  = rand(sF...)
    cF = CuArray(F)
    dF = distribute(F)

    sT = (2^5, 2^5)
    T  = rand(sT...)
    cT = CuArray(T)

    R = Dict{AbstractString, AbstractArray}()

    R["lcc"]    =  lcc(F,  T)
    R["flcc"]   = flcc(F,  T)
    R["gflcc"]  = Array(flcc(cF, cT))
    R["dflcc"]  = Array(flcc(dF, T))
    R["dgflcc"] = Array(flcc(dF, T; cuda=true))

    ground_truth_key = "lcc"
    ground_truth = R[ground_truth_key]
    @testset "Equivalence" begin
        @testset "$key" for key in keys(R)
            key == ground_truth_key && continue

            result = R[key]
            @test maximum(abs.(result .- ground_truth)) <= 1e-12
            @test best_correlated(result) == best_correlated(ground_truth)
        end
    end

    close(dF)
end

run_test()
