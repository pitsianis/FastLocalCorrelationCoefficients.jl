
# Where's Waldo?

We will use `FLCC` to find Waldo

```@example 1
using Images


img = mktemp() do fn,f
    download("https://i.stack.imgur.com/reNlF.jpg", fn)
    load(fn)
end
```

Our template is a noisy, darkened version of Waldo

```@example 1
waldo = 0.5 .* img[140:200, 160:195] .+ Gray.( 0.2*rand(200-140+1, 195-160+1) )
```

Next, we compute `FLCC` and visualize the correlations.

```@example 1
T = permutedims( Float64.( collect( channelview(waldo) ) ), [2 3 1] );
F = permutedims( Float64.( collect( channelview(img) ) ), [2 3 1] )
M = flcc( F, T );

Gray.( M[:,:,1] )
```

*We found Waldo!*
