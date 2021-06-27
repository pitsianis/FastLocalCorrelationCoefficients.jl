module FastLocalCorrelationCoefficients

using DSP, LinearAlgebra

struct FLCC_precomp
  F::Array
  nF::Tuple
  nT::Tuple
  pT::Int
  σ̅::Array
end

export lcc, flcc, best_correlated

include("flcc.jl")

end
