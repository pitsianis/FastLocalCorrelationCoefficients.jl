using LinearAlgebra, BenchmarkTools

function sequential!(y,x,t,n,b)
  w = zeros(b)

  @inbounds @simd for i ∈ 1:n-b+1

    for j = 1:b
      w[j] = x[i+j-1]
    end
    w .-= sum(w)/b

    y[i] = dot( w, t ) / norm(w)
  end
  return
end

function parallel!(y,x,t,n,b)
  local W = zeros(b,Threads.nthreads())

  @inbounds Threads.@threads for i ∈ 1:n-b+1
    w = view(W,:,Threads.threadid())
    for j = 1:b
      w[j] = x[i+j-1]
    end
    w .-= sum(w)/b

    y[i] = dot( w, t ) / norm(w)
  end
  return
end

function testRace()
  n = 2^21
  b = 8
  x = rand(n); t = rand(b)
  ys = zeros(n-b+1)
  yp = zeros(n-b+1)

  begin
    @btime sequential!($ys,$x, $t,$n,$b)
    @btime parallel!($yp,$x, $t,$n,$b)

    maximum(abs.(ys .- yp))
  end
end

testRace()
