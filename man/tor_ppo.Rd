% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tor_summarise.R
\name{tor_ppo}
\alias{tor_ppo}
\title{Check priors/posteriors overlap}
\usage{
tor_ppo(tor_obj)
}
\arguments{
\item{tor_obj}{a fitted model from \code{\link[=tor_fit]{tor_fit()}}}
}
\value{
a data.frame
}
\description{
\code{\link[=tor_ppo]{tor_ppo()}} generates prior/posterior overlap values for Tlc,
Tt and Betat. Values larger than 0.3 should lead to the conclusion that conforming
torpor, regulated torpor or thermoregulation respectively could not be modeled
with the data provided (Fasel et al. (in prep)). \code{\link[=tor_ppo]{tor_ppo()}} can be used independently but is also used internally in
\code{\link[=tor_summarise]{tor_summarise()}}.
}
\seealso{
Other summary: 
\code{\link{get_parameters}()},
\code{\link{tor_summarise}()}
}
\concept{summary}
