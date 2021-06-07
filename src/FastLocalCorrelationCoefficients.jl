module FastLocalCorrelationCoefficients

using PaddedViews, DSP, FFTW

export lcc, flcc, flccPrec, flccComp
include("flcc.jl")

end
