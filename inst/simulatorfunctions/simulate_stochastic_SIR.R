############################################################
##simulating a stochastic SIR type model
##written by Andreas Handel, ahandel@uga.edu, last change: 7/18/18
############################################################

#this specifies the rates used by the adapativetau routine
stochasticSIRfunc <- function(y, parms, t)
{
    with(as.list(c(y, parms)),
         {
            #specify each rate/transition/reaction that can happen in the system
             rates=c(  m,
                       n * S,
                       n * I,
                       n * R,
                       b * I * S,
                       g * I
             ) #end specification of each rate/transition/reaction
             return(rates)
         })
} #end function specifying rates used by adaptivetau


#' Stochastic simulation of an SIR-type model
#' 
#' @description  Simulation of a stochastic SIR type model with the following
#'   compartments: Susceptibles (S), 
#'   Infected and Infectious (I), Recovered and Immune (R)
#'   
#' @param S0 initial number of susceptible hosts
#' @param I0 initial number of infected, symptomatic hosts
#' @param b level/rate of infectiousness for hosts in the I compartment
#' @param g rate at which a person leaves the I compartment
#' @param m the rate at which new individuals enter the model (are born)
#' @param n the rate of natural death (the inverse is the average lifespan)
#' @param rngseed seed for random number generator to allow reproducibility
#' @param tmax maximum simulation time, units depend on choice of units for 
#' your parameters
#' @return The function returns a list. The list has one element, a data frame ts
#' which contains the time series of the simulated model, 
#' with one column per compartment/variable. The first column is time.
#' @details A compartmental SIR model is
#'   simulated. Initial conditions for the R variable is 0. Units of
#'   time depend on the time units chosen for model parameters. The simulation
#'   runs as a stochastic model using the adaptive-tau algorithm as implemented
#'   by ssa.adaptivetau in the adpativetau package. See the manual of this
#'   package for more details. The function returns a list,
#'   with the time series of the
#'   simulated disease as list element ts, with one column per
#'   compartment/variable. The first column is time.
#' @section Warning: This function does not perform any error checking. So if
#'   you try to do something nonsensical (e.g. specify negative parameter values
#'   or fractions > 1), the code will likely abort with an error message.
#' @examples
#' # To run the simulation with default parameters, just call the function:
#' result <- simulate_stochastic_SIR()
#' # To choose parameter values other than the standard one, specify them like this:
#' result <- simulate_stochastic_SIR(S0 = 2000,  tmax = 200, b = 1/100)
#' # You can display or further process the result, like this:
#' plot(result$ts[,'Time'],result$ts[,'S'],xlab='Time',ylab='Number Susceptible',type='l')
#' print(paste('Max number of infected: ',max(result$ts[,'I']))) 
#' @seealso See the Shiny app documentation corresponding to this simulator
#' function for more details on this model. See the manual for the adaptivetau
#' package for details on the stochastic algorithm.
#' @author Andreas Handel
#' @export




simulate_stochastic_SIR <- function(S0 = 1000, I0 = 10, tmax = 100,  b = 1/1000,  g = 0.5,  m = 0, n = 0, rngseed  = 100)
{
    Y0 = c(S = S0,  I = I0, R = 0);  #combine initial conditions into a vector
    dt = tmax / 1000; #time step for which to get results back
    timevec = seq(0, tmax, dt); #vector of times for which solution is returned (not that internal timestep of the integrator is different)

    #combining parameters into a parameter vector
    pars = c(b = b,  g = g,  m = m, n = n);

    #specify for each reaction/rate/transition how the different variables change
    #needs to be in exactly the same order as the rates listed in the rate function
    transitions = list(c(S = +1), #births of susceptible
                       c(S = -1), #deaths of susceptible
                       c(I = -1), #deaths of I
                       c(R = -1), #deaths of R
                       c(S = -1, I = +1), #infection of S by I
                       c(I = -1, R = +1) #move of I to R (recovery)
    ) #end list of transitions


    #this line runs the simulation using the SSA algorithm in the adaptivetau package
    set.seed(rngseed) # to allow reproducibility
    simres = adaptivetau::ssa.adaptivetau(init.values = Y0, transitions = transitions,  rateFunc = stochasticSIRfunc, params = pars, tf = tmax)

    colnames(simres) <- c("Time", "S", "I", "R")
    result <- list()
    result$ts <- as.data.frame(simres)
    
    return(result)
}
