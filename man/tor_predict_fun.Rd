% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tor_predict.R
\name{tor_predict_fun}
\alias{tor_predict_fun}
\title{tor_predict_fun // internal}
\usage{
tor_predict_fun(x, Tt, intr, intc, betat, betac, Ym)
}
\arguments{
\item{x}{a temperature}

\item{Tt}{turning point T}

\item{intr}{intercept 1}

\item{intc}{intercept 2}

\item{betat}{slope 1}

\item{betac}{slope 2}

\item{Ym}{mean of Y to back-transform}
}
\value{
a numerical value
}
\description{
Function to fit the model in torpor
}
\seealso{
Other predict: 
\code{\link{eut_predict_fun}()},
\code{\link{tor_assign}()},
\code{\link{tor_predict}()}
}
\concept{predict}
