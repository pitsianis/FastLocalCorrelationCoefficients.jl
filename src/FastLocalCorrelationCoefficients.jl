module FastLocalCorrelationCoefficients

using DSP, LinearAlgebra

struct FLCC_precomp
  F::Array
  nF::Tuple
  pF::Int
  nT::Tuple
  pT::Int
  nM::Tuple
  fConvOnes::Array
  σ̅::Array
end

export lcc, flcc, best_correlated

include("flcc.jl")

end
