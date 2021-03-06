############################################################
#This is the Shiny file for the ID Characteristics App
#written by Andreas Handel, with contributions from others 
#maintained by Andreas Handel (ahandel@uga.edu)
#last updated 7/13/2018
############################################################

#the main server-side function 
#this function is wrapped inside the shiny server function below to allow return to main menu when window is closed
refresh <- function(input, output){

    # This reactive takes the input data and sends it over to the simulator
    # Then it will get the results back and return it as the "res" variable
    result <- reactive({
    input$submitBtn

    # Read all the input values from the UI
    S0 = isolate(input$S0);
    P0 = isolate(input$P0);
    tmax = isolate(input$tmax);
    bP = isolate(input$bP);
    bA = isolate(input$bA);
    bI = isolate(input$bI);
    gP = isolate(input$gP);
    gA = isolate(input$gA);
    gI = isolate(input$gI);
    f = isolate(input$f);
    d = isolate(input$d);
    plotscale = isolate(input$plotscale) 
    
    #save all results to a list for processing plots and text
    listlength = 1; #here we do all simulations in the same figure
    result = vector("list", listlength) #create empty list of right size for results
    
    #shows a 'running simulation' message
    withProgress(message = 'Running Simulation', value = 0,
                 {
      simresult <- simulate_idcharacteristics(S0 = S0, P0 = P0, tmax = tmax, bP = bP, bA = bA, bI = bI, gP = gP , gA = gA, gI = gI, f = f, d = d)
                 })
    
    #data for plots and text
    #needs to be in the right format to be passed to generate_plots and generate_text
    #see documentation for those functions for details
    result[[1]]$dat = simresult$ts
    
    #Meta-information for each plot
    result[[1]]$plottype = "Lineplot"
    result[[1]]$xlab = "Time"
    result[[1]]$ylab = "Numbers"
    result[[1]]$legend = "Compartments"
    
    result[[1]]$xscale = 'identity'
    result[[1]]$yscale = 'identity'
    if (plotscale == 'x' | plotscale == 'both') { result[[1]]$xscale = 'log10'}
    if (plotscale == 'y' | plotscale == 'both') { result[[1]]$yscale = 'log10'}
    
    
    #the following are for text display for each plot
    result[[1]]$maketext = TRUE #if true we want the generate_text function to process data and generate text, if 0 no result processing will occur insinde generate_text
    result[[1]]$showtext = '' #text can be added here which will be passed through to generate_text and displayed for each plot
    result[[1]]$finaltext = 'Numbers are rounded to 2 significant digits.' #text can be added here which will be passed through to generate_text and displayed for each plot
    
    return(result)
  })
    #ends inner shiny server function that runs the simulation and returns output

    
    #functions below take result saved in reactive expression result and produce output
    #to produce figures, the function generate_plot is used
    #function generate_text produces text
    #data needs to be in a specific structure for processing
    #see information for those functions to learn how data needs to look like
    #output (plots, text) is stored in reactive variable 'output'
    
    output$plot  <- renderPlot({
      input$submitBtn
      res=isolate(result()) #list of all results that are to be turned into plots
      generate_plots(res) #create plots with a non-reactive function
    }, width = 'auto', height = 'auto'
    ) #finish render-plot statement
    
    output$text <- renderText({
      input$submitBtn
      res=isolate(result()) #list of all results that are to be turned into plots
      generate_text(res) #create text for display with a non-reactive function
    })
    
} #ends the 'refresh' shiny server function that runs the simulation and returns output   
    
    

#main/outer shiny server function, which calls other functions
server <- function(input, output, session) {
  
  # Waits for the Exit Button to be pressed to stop the app server
  observeEvent(input$exitBtn, {
    input$exitBtn
    stopApp(returnValue = NULL)
  })
  
  # This function is called to refresh the content of the UI
  refresh(input, output)
 
  
} #ends main/outer shiny server function


ui <- fluidPage(
  
  includeCSS("../../media/dsaide.css"),
  withMathJax(),
  
  #add header and title
   
  div( includeHTML("../../media/header.html"), align = "center"),
  h1('ID Characteristics App', align = "center", style = "background-color:#123c66; color:#fff"),
  
  #start section to add buttons
  fluidRow(
    column(6,
           actionButton("submitBtn", "Run Simulation", class="submitbutton")  
    ),
    column(6,
           actionButton("exitBtn", "Exit App", class="exitbutton")
    ),
    align = "center"
  ), #end section to add buttons
  
  tags$hr(),
  
  ################################
  #Split screen with input on left, output on right
  fluidRow(
    #all the inputs in here
    column(6,
           #################################
           # Inputs section
           h2('Simulation Settings'),
           fluidRow(
             column(4,
                    numericInput("S0", "Initial number of susceptible hosts (S0)", min = 1000, max = 5000, value = 1000, step = 500)
             ),
             column(4,
                    numericInput("P0", "Initial number of presymptomatic hosts (P0) ", min = 0, max = 100, value = 1, step = 1)
             ),
             column(4,
                    numericInput("tmax", "Maximum simulation time (tmax)", min = 10, max = 1000, value = 300, step = 10)
             ),
             align = "center"
           ), #close fluidRow structure for input
           
           fluidRow(
             column(4,
                    numericInput("bP", "Rate of transmission by presymptomatic hosts (bP)", min = 0, max = 0.01, value = 0, step = 0.0001  )
             ),
             column(4,
                    numericInput("bA", "Rate of transmission by asymptomatic hosts (bA)", min = 0, max = 0.01, value = 0, step = 0.0001  )
             ),
             column(4,
                    numericInput("bI", "Rate of transmission by symptomatic hosts (bI)", min = 0, max = 0.01, value = 0.001, step = 0.0001  )
             ),
             align = "center"
           ), #close fluidRow structure for input
           fluidRow(
             column(4,
                    numericInput("gP", "Rate of recovery of presymptomatic hosts (gP)", min = 0, max = 2, value = 0.5, step = 0.1)
             ),
             column(4,
                    numericInput("gA", "Rate of recovery of asymptomatic hosts (gA)", min = 0, max = 2, value = 0.5, step = 0.1)
             ),
             column(4,
                    numericInput("gI", "Rate of recovery of symptomatic hosts (gI)", min = 0, max = 2, value = 0.5, step = 0.1)
             ),
             align = "center"
           ), #close fluidRow structure for input
           fluidRow(
             column(4,
                    numericInput("f", "Fraction of asymptomatic infections (f)", min = 0, max = 1, value = 0, step = 0.1)
             ),
             column(4,
                    numericInput("d", "Fraction of deaths in symptomatic hosts (d)", min = 0, max = 1, value = 0, step = 0.1)
             ),
             column(4,
                    selectInput("plotscale", "Log-scale for plot:",c("none" = "none", 'x-axis' = "x", 'y-axis' = "y", 'both axes' = "both")) #--
                    ),
             
             align = "center"
           )
    ), #end sidebar column for inputs
    
    #all the outcomes here
    column(6,
           
           #################################
           #Start with results on top
           h2('Simulation Results'),
           plotOutput(outputId = "plot", height = "500px"),
           # PLaceholder for results of type text
           htmlOutput(outputId = "text"),
           #Placeholder for any possible warning or error messages (this will be shown in red)
           htmlOutput(outputId = "warn"),
           
           tags$head(tags$style("#warn{color: red;
                                font-style: italic;
                                }")),
           tags$hr()
           
           ) #end main panel column with outcomes
  ), #end layout with side and main panel
  
  #################################
  #Instructions section at bottom as tabs
  h2('Instructions'),
  #use external function to generate all tabs with instruction content
  # do.call(tabsetPanel,generate_instruction_tabs()),
  do.call(tabsetPanel, generate_documentation()),
  div(includeHTML("../../media/footer.html"), align="center", style="font-size:small") #footer

) #end fluidpage, i.e. the UI part of the app

shinyApp(ui = ui, server = server)

