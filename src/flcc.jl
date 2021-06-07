
# Fast Local Correlation Coefficients
#
#

# when Frobenious norm too small, assume a constant tensor
tooSmall = 1e-13

fcorr(x,y) = conv(x, reverse(y))

norm(x) = sqrt(sum(map(abs,x).^2))

"""
```
  flcc(haystack,needle)
```
Calculate the local correlation coefficients fast using `fft`.

# Example

Suppose you have a `haystack`, a tensor of reals and a `needle`, a
smaller tensor of the same dimensionality that you are are trying to
locate in the `haystack`. Note that the `needle` might be scaled and
translated.

The position of the maximum element of `LCC` is the best match between
the `needle` and a sliding window of `haystack`

```jldoctest
julia> using FastLocalCorrelationCoefficients

julia> haystack = rand(2^10,2^10);

julia> needle = rand(1) .* haystack[42:48, 45:50] .+ rand(1);

julia> LCC = flcc(haystack,needle);

julia> argmax(LCC)
CartesianIndex(42, 45)
```
"""
function flcc(F,Tin)

  T = copy(Tin)

  nF = size(F); pF = prod(nF)
  nT = size(T); pT = prod(nT)

  T .= T .- sum(T)/pT

  normT = norm(T)
  if normT > tooSmall
    T = T ./ normT
  else
    T .= one(typeof(T[1]), nT)
  end

  nM = nF .+ nT .- 1

  Bt = collect(PaddedView(zero(typeof(T[1])), ones(typeof(T[1]), nT), nM));
  Ss = collect(PaddedView(zero(typeof(F[1])), F, nM))

  FBt = fft(Bt)
  FS = fft(Ss)
  FS2 = fft(map(abs,Ss).^2)

  μ = ifft(FS .* FBt) ./ pT
  σ̅ = map(sqrt, ifft(FS2 .* FBt) .- pT .* map(abs, μ).^2) .* sqrt(pT)

  M = (fcorr(F, conj(T)) .- 1/pT .* conv(F, ones(typeof(F[1]), nT)) .* conv(T, ones(typeof(F[1]), nF))) ./ σ̅ .* sqrt(pT)

  # restrict to valid
  M = M[CartesianIndex((nT)):CartesianIndex(nF)]
  return ( eltype(M) <: Complex ) ? abs.(M) : M

end

"""
When you need to search for several needles of the same size, then you
can avoid redundant computations by precomputing all common information.

```
  haystack = rand(2^20)
  needle1 = rand(1) .* haystack[2:8] .+ rand(1)
  needle2 = rand(1) .* haystack[42:48] .+ rand(1)
  needle3 = rand(1) .* haystack[end-6:end] .+ rand(1)
  precomp = FastLocalCorrelationCoefficients.flccPrec(haystack,size(needle1))
  argmax(FastLocalCorrelationCoefficients.flccComp(precomp,needle1)) == 2
  argmax(FastLocalCorrelationCoefficients.flccComp(precomp,needle2)) == 42
  argmax(FastLocalCorrelationCoefficients.flccComp(precomp,needle3)) == 2^20-6
```
"""
function flccPrec(F,nT)

  nF = size(F)
  pF = prod(nF)
  pT = prod(nT)

  nM = nF .+ nT .- 1

  Bt = collect(PaddedView(zero(typeof(F[1])), ones(typeof(F[1]), nT), nM))
  Ss = collect(PaddedView(zero(typeof(F[1])), F, nM))

  FBt = fft(Bt)
  FS = fft(Ss)
  FS2 = fft(map(abs,Ss).^2)

  μ = ifft(FS .* FBt) ./ pT
  σ̅ = map(sqrt, ifft(FS2 .* FBt) .- pT .* map(abs, μ).^2) .* sqrt(pT)

  fConvOnes = conv(F, ones(typeof(F[1]), nT))

  return (F,nF,pF,nT,pT,nM,fConvOnes,σ̅)

end
"""

"""
function flccComp((F,nF,pF,nT,pT,nM,fConvOnes,σ̅), T)

  T .= T .- sum(T)/pT

  normT = norm(T)
  if normT > tooSmall
    T = T ./ normT
  else
    T .= one(typeof(T[1]), nT)
  end

  M = (fcorr(F, conj(T)) .- 1/pT .* fConvOnes .* conv(T, ones(typeof(F[1]), nF))) ./ σ̅ .* sqrt(pT)

  # restrict to valid
  return map(abs, M[CartesianIndex((nT)):CartesianIndex(nF)])

end

# Direct for debugging

"""
```
  lcc(haystack,needle)
```
Calculate the local correlation coefficients directly.

# Example

Suppose you have a `haystack`, a tensor of reals and a `needle`, a
smaller tensor of the same dimensionality that you are are trying to
locate in the `haystack`. Note that the `needle` might be scaled and
translated.

The position of the maximum element of `LCC` is the best match between
the `needle` and a sliding window of `haystack`

```jldoctest
julia> using FastLocalCorrelationCoefficients

julia> haystack = rand(2^10,2^10);

julia> needle = rand(1) .* haystack[42:48, 45:50] .+ rand(1);

julia> LCC = lcc(haystack,needle);

julia> argmax(LCC)
CartesianIndex(42, 45)
```
"""
function lcc(F,Tin)

  T = copy( Tin )

  nF = size(F); pF = prod(nF)
  nT = size(T); pT = prod(nT)

  T .= T .- sum(T)/pT

  normT = norm(T)
  if normT > tooSmall
    T = T ./ normT
  else
    T .= one(typeof(T[1]), nT)
  end

  M = zeros(typeof(F[1]), nF .- nT .+ 1)

  # pattern from # https://julialang.org/blog/2016/02/iteration/
  R  = CartesianIndices(M)
  Is = CartesianIndex( (nT.-1)... )

  w = zeros( eltype(T), nT )

  for I ∈ R
    w .= F[I : (I+Is)]
    w .-= sum(w)/pT
    w ./= norm(w)

    M[I] = sum( w .* conj(T) )
  end

  # for i = 1:(pF - pT + 1)
  #   w = F[i:i+pT-1];
  #   w .= w .- sum(w)/pT
  #   w = w ./ norm(w)

  #   M[i] = sum(w .* conj(T))
  # end

  # restrict to valid
  return ( eltype(M) <: Complex ) ? abs.(M) : M
  # return map(real, M)

end

