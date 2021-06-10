using FastLocalCorrelationCoefficients

for n = 2 .^(3:5)
  x = rand(n,n,n,n);
  y = x[1:2^2,1:2^2,1:2^2,1:2^2];

  println("n = $n")

  M1 = @time lcc(x,y);
  M2 = @time flcc(x,y);

  maximum(abs.(M1 - M2))

end
