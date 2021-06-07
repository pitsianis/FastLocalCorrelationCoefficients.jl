# FastLocalCorrelationCoefficients.jl

[![Build Status](https://github.com/pitsianis/FastLocalCorrelationCoefficients.jl/workflows/CI/badge.svg)](https://github.com/pitsianis/FastLocalCorrelationCoefficients.jl/actions)
[![Coverage](https://codecov.io/gh/pitsianis/FastLocalCorrelationCoefficients.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/pitsianis/FastLocalCorrelationCoefficients.jl)

Computing local correlation coefficients (also known as LCCs) is a basic step in various image-based data or information processing applications, including template or pattern matching, detection and estimation of motion or some other change in an image frame series, image registration from data collected at different times, projections, perspectives or with different acquisition modalities, and compression across multiple image frames.

The Fast Local Correlation Coefficients (FLCC) Library `FastLocalCorrelationCoefficients.jl`
computes the Correlation Coefficients with Local Normalization for arbitrary dimensional tensors with real or complex values.

For more information see:

 1. X. Sun, N. P. Pitsianis, and P. Bientinesi, [Fast computation of local correlation coefficients](http://www.cs.duke.edu/~nikos/reprints/C-027-LCC-SPIE.pdf), Proc. SPIE 7074, 707405 (2008)

 2. G. Papamakarios, G. Rizos, N. P. Pitsianis, and X. Sun, [Fast computation of local correlation coefficients on graphics processing units](http://www.cs.duke.edu/~nikos/reprints/C-032-LCCGPU-SPIE09.pdf), Proc. SPIE 7444, 744412 (2009)
