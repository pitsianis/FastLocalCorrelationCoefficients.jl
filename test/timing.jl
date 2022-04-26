using FastLocalCorrelationCoefficients, BenchmarkTools, CUDA, Distributed
@everywhere using DistributedArrays

function timing_test(dtype, nF, nT)

  F = rand(dtype, nF); cF = CuArray(F); dF = distribute(F)
  T = rand(dtype, nT); cT = CuArray(T)

  @info("Timing Results",
    lcc  = @belapsed( lcc( $F,  $T)),
    flcc = @belapsed(flcc( $F,  $T)),
    cuda = @belapsed(flcc($cF, $cT)),
    dist = @belapsed(flcc($dF,  $T)),
    duda = @belapsed(flcc($dF,  $T; cuda=true))
  )

  close(dF)
end

timing_test(Float64, (2^10, 2^10), (2^5, 2^5))
