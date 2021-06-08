module FastLocalCorrelationCoefficients

using PaddedViews, DSP, FFTW, LinearAlgebra

export lcc, flcc, flccPrec, flccComp
include("flcc.jl")

end
