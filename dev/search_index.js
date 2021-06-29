var documenterSearchIndex = {"docs":
[{"location":"api/#FLCC-documentation","page":"FLCC documentation","title":"FLCC documentation","text":"","category":"section"},{"location":"api/","page":"FLCC documentation","title":"FLCC documentation","text":"CurrentModule = FastLocalCorrelationCoefficients","category":"page"},{"location":"api/","page":"FLCC documentation","title":"FLCC documentation","text":"The FastLocalCorrelationCoefficients package exports the following functions","category":"page"},{"location":"api/","page":"FLCC documentation","title":"FLCC documentation","text":"","category":"page"},{"location":"api/","page":"FLCC documentation","title":"FLCC documentation","text":"Modules = [FastLocalCorrelationCoefficients]","category":"page"},{"location":"api/#FastLocalCorrelationCoefficients.best_correlated-Tuple{AbstractArray}","page":"FLCC documentation","title":"FastLocalCorrelationCoefficients.best_correlated","text":"  best_correlated(c::Array)\n\nLocate the position of the element with the maximum local correlation value.\n\n\n\n\n\n","category":"method"},{"location":"api/#FastLocalCorrelationCoefficients.flcc-Tuple{AbstractArray, AbstractArray}","page":"FLCC documentation","title":"FastLocalCorrelationCoefficients.flcc","text":"  flcc(haystack,needle)\n\nCalculate the local (Pearson) correlation coefficients\n\nmathrmlcc(xy) = frac(x - mu_x)^T(y - mu_y)sigma_x sigma_y\n\nbetween needle and all sliding windows of same size within haystack.\n\nflcc uses the fast Fourier transform to reduce the computational complexity from O(n_H n_N) to O((n_H + n_N) log(n_H + n_N)), where n_H and n_N are the number of elements of the haystack and the needle, respectively.\n\nflcc supports tensors of any dimensions with real or complex entries.\n\nExamples\n\nSuppose you have a haystack, a tensor of reals and a needle, a smaller tensor of the same dimensionality that you are are trying to locate in the haystack. Note that the needle might be scaled and translated.\n\nThe position of the maximum element of LCC is the best match between the needle and a sliding window of haystack\n\njulia> using FastLocalCorrelationCoefficients\n\njulia> haystack = rand(2^10,2^10);\n\njulia> needle = rand(1) .* haystack[42:48, 45:50] .+ rand(1);\n\njulia> c = flcc(haystack,needle);\n\njulia> best_correlated(c)\nCartesianIndex(42, 45)\n\nWhen you need to search for many needles of the same size,\n\n  haystack = rand(2^20);\n  needle1 = rand(1) .* haystack[2:8] .+ rand(1);\n  needle2 = rand(1) .* haystack[42:48] .+ rand(1);\n  needle3 = rand(1) .* haystack[end-6:end] .+ rand(1);\n\nyou can preprocess the haystack to avoid redundant computations by precomputing all common information. There is no such preprocessing when using the direct method.\n\n  precomp = flcc(haystack,size(needle1));\n\n\nThen use it for much faster queries.\n\n  best_correlated(flcc(precomp,needle1)) == 2\n  best_correlated(flcc(precomp,needle2)) == 42\n  best_correlated(flcc(precomp,needle3)) == 2^20-6\n\n\n\n\n\n","category":"method"},{"location":"api/#FastLocalCorrelationCoefficients.lcc-Tuple{Any, Any}","page":"FLCC documentation","title":"FastLocalCorrelationCoefficients.lcc","text":"  lcc(haystack,needle)\n\nCalculate the local (Pearson) correlation coefficients between a needle and a sliding window within haystack, directly.\n\nExample\n\nSuppose you have a haystack, a tensor of reals and a needle, a smaller tensor of the same dimensionality that you are are trying to locate in the haystack. Note that the needle might be scaled and translated.\n\nThe position of the maximum LCC is the best match between the needle and a sliding window of haystack\n\njulia> using FastLocalCorrelationCoefficients\n\njulia> haystack = rand(2^10,2^10);\n\njulia> needle = rand(1) .* haystack[42:47, 45:50] .+ rand(1);\n\njulia> c = lcc(haystack,needle);\n\njulia> best_correlated(c)\nCartesianIndex(42, 45)\n\n\n\n\n\n","category":"method"},{"location":"waldo/#Where's-Waldo?","page":"Where's Waldo?","title":"Where's Waldo?","text":"","category":"section"},{"location":"waldo/","page":"Where's Waldo?","title":"Where's Waldo?","text":"We will use FLCC to find Waldo","category":"page"},{"location":"waldo/","page":"Where's Waldo?","title":"Where's Waldo?","text":"using FastLocalCorrelationCoefficients, Images\n\n\nimg = mktemp() do fn,f\n    download(\"https://i.stack.imgur.com/reNlF.jpg\", fn)\n    load(fn)\nend","category":"page"},{"location":"waldo/","page":"Where's Waldo?","title":"Where's Waldo?","text":"Our template is a noisy, darkened version of Waldo","category":"page"},{"location":"waldo/","page":"Where's Waldo?","title":"Where's Waldo?","text":"waldo = 0.5 .* img[140:200, 160:195] .+ Gray.( 0.2*rand(200-140+1, 195-160+1) )","category":"page"},{"location":"waldo/","page":"Where's Waldo?","title":"Where's Waldo?","text":"Transform the images into 3D tensors","category":"page"},{"location":"waldo/","page":"Where's Waldo?","title":"Where's Waldo?","text":"T = permutedims( Float64.( collect( channelview(waldo) ) ), [2 3 1] );\nF = permutedims( Float64.( collect( channelview(img) ) ), [2 3 1] );\nnothing # to suppress output","category":"page"},{"location":"waldo/","page":"Where's Waldo?","title":"Where's Waldo?","text":"First, we show that the un-normalized convolution is unable to locate Waldo","category":"page"},{"location":"waldo/","page":"Where's Waldo?","title":"Where's Waldo?","text":"R = FastLocalCorrelationCoefficients.fcorr( F, T );\nR = R[CartesianIndex((size(T))):CartesianIndex(size(F))][:,:,1]\nR = R / maximum(R)\nGray.( R )","category":"page"},{"location":"waldo/","page":"Where's Waldo?","title":"Where's Waldo?","text":"The position with the maximum value is not Waldo.","category":"page"},{"location":"waldo/","page":"Where's Waldo?","title":"Where's Waldo?","text":"idx_R = best_correlated( R ) .+ (CartesianIndex(0,0):CartesianIndex(70, 35))\nimg[idx_R]","category":"page"},{"location":"waldo/","page":"Where's Waldo?","title":"Where's Waldo?","text":"Next, we compute FLCC and visualize the correlations.","category":"page"},{"location":"waldo/","page":"Where's Waldo?","title":"Where's Waldo?","text":"M = flcc( F, T )[:,:,1];\n\nGray.( (M .+ 1) ./ 2 )","category":"page"},{"location":"waldo/","page":"Where's Waldo?","title":"Where's Waldo?","text":"We found Waldo!","category":"page"},{"location":"waldo/","page":"Where's Waldo?","title":"Where's Waldo?","text":"idx = best_correlated( M ) .+ (CartesianIndex(0,0):CartesianIndex(70, 35))\nimg[idx]","category":"page"},{"location":"","page":"Home","title":"Home","text":"CurrentModule = FastLocalCorrelationCoefficients","category":"page"},{"location":"#FastLocalCorrelationCoefficients","page":"Home","title":"FastLocalCorrelationCoefficients","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"FastLocalCorrelationCoefficients.","category":"page"},{"location":"","page":"Home","title":"Home","text":"Computing local correlation coefficients (also known as LCCs) is a basic step in various image-based data or information processing applications, including template or pattern matching, detection and estimation of motion or some other change in an image frame series, image registration from data collected at different times, projections, perspectives or with different acquisition modalities, and compression across multiple image frames.","category":"page"},{"location":"","page":"Home","title":"Home","text":"The Fast Local Correlation Coefficients (FLCC) Library FastLocalCorrelationCoefficients.jl computes the Correlation Coefficients with Local Normalization for arbitrary dimensional tensors with real or complex values.","category":"page"},{"location":"","page":"Home","title":"Home","text":"For more information see:","category":"page"},{"location":"","page":"Home","title":"Home","text":"X. Sun, N. P. Pitsianis, and P. Bientinesi, Fast computation of local correlation coefficients, Proc. SPIE 7074, 707405 (2008)\nG. Papamakarios, G. Rizos, N. P. Pitsianis, and X. Sun, Fast computation of local correlation coefficients on graphics processing units, Proc. SPIE 7444, 744412 (2009)","category":"page"}]
}