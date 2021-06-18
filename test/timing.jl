using FastLocalCorrelationCoefficients, BenchmarkTools

function timing_test()
  for n = 2 .^(2:9)

    x = rand(2^20);
    y = x[1:n];

    println("n = $n")

    M1 = @btime lcc($x,$y);
    M2 = @btime flcc($x,$y);

    println("Max Difference ", maximum(abs.(M1 - M2)))

  end
end

timing_test()
