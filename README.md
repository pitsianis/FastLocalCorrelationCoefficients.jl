# FastLocalCorrelationCoefficients.jl

<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/">Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License</a>.

[![Build Status](https://github.com/pitsianis/FastLocalCorrelationCoefficients.jl/workflows/CI/badge.svg)](https://github.com/pitsianis/FastLocalCorrelationCoefficients.jl/actions)
[![Coverage](https://codecov.io/gh/pitsianis/FastLocalCorrelationCoefficients.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/pitsianis/FastLocalCorrelationCoefficients.jl)

Full documentation of latest release can be found [here](https://pitsianis.github.io/FastLocalCorrelationCoefficients.jl/stable)

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://pitsianis.github.io/FastLocalCorrelationCoefficients.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://pitsianis.github.io/FastLocalCorrelationCoefficients.jl/dev)

## Overview

Computing locally normalized correlation coefficients (also known as Pearson correlation coefficients) is a basic step in various image-based data or information processing applications, including template or pattern matching, detection and estimation of motion or some other change in an image frame series, image registration from data collected at different times, projections, perspectives or with different acquisition modalities, and compression across multiple image frames.

The Fast Local Correlation Coefficients (FLCC) Library `FastLocalCorrelationCoefficients.jl`
computes the Local Correlation Coefficients between a template (the needle) and all sliding subframes of a frame (the haystack). The maximum values of the LCCs correspond to the subframes that are most similar to the template. The implementation supports arbitrary dimensional tensors with real or complex values. 

For example:

```julia

julia> using FastLocalCorrelationCoefficients

julia> haystack = rand(ComplexF32,2^5,2^5,2^5,2^5);

julia> needle = rand(ComplexF32,1) .* haystack[10:14, 11:15, 12:16, 13:17] .+ rand(ComplexF32,1);

julia> c = flcc(haystack,needle);

julia> best_correlated(c)
CartesianIndex(10, 11, 12, 13)

```

For more information see:

 1. X. Sun, N. P. Pitsianis, and P. Bientinesi, [Fast computation of local correlation coefficients](http://www.cs.duke.edu/~nikos/reprints/C-027-LCC-SPIE.pdf), Proc. SPIE 7074, 707405 (2008)

 2. G. Papamakarios, G. Rizos, N. P. Pitsianis, and X. Sun, [Fast computation of local correlation coefficients on graphics processing units](http://www.cs.duke.edu/~nikos/reprints/C-032-LCCGPU-SPIE09.pdf), Proc. SPIE 7444, 744412 (2009)
