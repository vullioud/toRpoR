
<!-- README.md is generated from README.Rmd. Please edit that file -->

# torpor

![Project Status: WIP – Initial development is in progress, but there
has not yet been a stable, usable release suitable for the
public.](https://www.repostatus.org/badges/latest/wip.svg) [![Build
Status](https://travis-ci.org/vullioud/torpor.svg?branch=master)](https://travis-ci.org/vullioud/torpor)
[![Codecov test
coverage](https://codecov.io/gh/vullioud/torpor/branch/master/graph/badge.svg)](https://codecov.io/gh/vullioud/torpor?branch=master)

## Welcome to torpor

This is the repository of torpor an `R` (<https://www.r-project.org/>)
package aiming at an objective and standardized distinction between
torpid and euthermic metabolic rates (MR) measured in steady-state
conditions. Note: This package is not aimed for general use without
careful researcher’s attention.

## Installation

Torpor is using `JAGS` (Just Another Gibbs Sampler) in the background
and thus you should make sure to have
[JAGS](http://mcmc-jags.sourceforge.net) installed on your machine. Once
jags is properly installed and working you can installed torpor in R by
typing:

``` r
library(remotes)
remotes::install_github("vullioud/torpor", build_opts =  c("--build_vignettes"),force=TRUE)
```

The package will be submitted to cran in the forseeable future.

## Where can I find more about torpor?

You can learn more about the goal and the theory behind the package in
the companion article (Fassel et al., in prep). A developped example and
the model specification are also presented as vignettes. They can be
accessed through `R` direcly

``` r
library(torpor)
browseVignettes("torpor")
```
