% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/simulate_SIR_model_ode.R
\name{simulate_SIR_model_ode}
\alias{simulate_SIR_model_ode}
\title{SIR model}
\usage{
simulate_SIR_model_ode(vars = c(S = 1000, I = 1, R = 0), pars = c(b =
  0.002, g = 1), times = c(tstart = 0, tfinal = 100, dt = 0.1))
}
\arguments{
\item{vars}{vector of starting conditions for model variables: 
\itemize{ 
\item S : starting value for Susceptible
\item I : starting value for Infected
\item R : starting value for Recovered
}}

\item{pars}{vector of values for model parameters: 
\itemize{ 
\item b : infection rate
\item g : recovery rate
}}

\item{times}{vector of values for model times: 
\itemize{ 
\item tstart : Start time of simulation
\item tfinal : Final time of simulation
\item dt : Time step
}}
}
\value{
The function returns the output as a list. 
The time-series from the simulation is returned as a dataframe saved as list element \code{ts}. 
The \code{ts} dataframe has one column per compartment/variable. The first column is time.
}
\description{
A basic SIR model with 3 compartments and infection and recovery processes
}
\details{
The model includes susceptible, infected, and recovered compartments. The two processes that are modeled are infection and recovery.
}
\section{Warning}{
 This function does not perform any error checking. So if you try to do something nonsensical (e.g. have negative values for parameters), the code will likely abort with an error message.
}

\section{Model Author}{
 Andreas Handel
}

\section{Model creation date}{
 2018-09-14
}

\section{Code Author}{
 generated by the \code{generate_ode} function
}

\section{Code creation date}{
 2018-09-14
}

\examples{
 
# To run the simulation with default parameters:  
result <- simulate_SIR_model_ode() 
}
