using FastLocalCorrelationCoefficients

for n = 2 .^(4:7)
  x = rand(n,n,n);
  y = x[1:2^3,1:2^3,1:2^3];

  println("n = $n")

  M1 = @time lcc(x,y);
  M2 = @time flcc(x,y);

end
