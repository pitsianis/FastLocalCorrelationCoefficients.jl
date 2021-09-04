module FastLocalCorrelationCoefficients

using LoopVectorization, DSP, LinearAlgebra

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
