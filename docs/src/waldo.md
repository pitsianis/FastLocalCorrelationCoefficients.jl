
# Where's Waldo?

We will use `FLCC` to find Waldo

```@example 1
using FastLocalCorrelationCoefficients, Images


img = mktemp() do fn,f
    download("https://i.stack.imgur.com/reNlF.jpg", fn)
    load(fn)
end
```

Our template is a noisy, darkened version of Waldo

```@example 1
waldo = 0.5 .* img[140:200, 160:195] .+ Gray.( 0.2*rand(200-140+1, 195-160+1) )
```

Transform the images into 3D tensors

```@example 1
T = permutedims( Float64.( collect( channelview(waldo) ) ), [2 3 1] );
F = permutedims( Float64.( collect( channelview(img) ) ), [2 3 1] );
nothing # to suppress output
```

First, we show that the un-normalized convolution is unable to locate
Waldo

```@example 1
R = FastLocalCorrelationCoefficients.fcorr( F, T );
R = R[CartesianIndex((size(T))):CartesianIndex(size(F))][:,:,1]
R = R / maximum(R)
Gray.( R )
```


The position with the maximum value is not Waldo.

```@example 1
idx_R = best_correlated( R ) .+ (CartesianIndex(0,0):CartesianIndex(70, 35))
img[idx_R]
```

Next, we compute `FLCC` and visualize the correlations.

```@example 1
M = flcc( F, T )[:,:,1];

Gray.( (M .+ 1) ./ 2 )
```

*We found Waldo!*

```@example 1
idx = best_correlated( M ) .+ (CartesianIndex(0,0):CartesianIndex(70, 35))
img[idx]
```
