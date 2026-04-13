module FastLocalCorrelationCoefficients

# NOTE: Import `CUDA` and `CUDA.CUFFT` in a guard
using LoopVectorization, LinearAlgebra, CUDA, CUDA.CUFFT, Distributed, DistributedArrays
using DSP

struct FLCC_precomp
  F::AbstractArray
  nF::Tuple
  nT::Tuple
  pT::Int
  σ̅::AbstractArray
end

export lcc, flcc, best_correlated

include("flcc.jl")

end
