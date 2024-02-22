from juliacall import Main as jl
jl.seval("using FastLocalCorrelationCoefficients")

from array import array


def flcc(haystack: array, needle: array) -> array:
    return jl.flcc(haystack, needle)


def best_correlated(c: array):
    return jl.best_correlated(c) - 1 # julia uses 1-indexing


def lcc(haystack: array, needle: array) -> array:
    return jl.lcc(haystack, needle)
