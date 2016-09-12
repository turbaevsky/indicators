
library(shiny)

source('../functions.r')
units <- activeStation(Sys.Date())
uNames <- sort(as.character(subset(place,place$LocId %in% units,AbbrevLocName)[[1]]))
i <- readRDS('DBCopy/PI_IndicatorCodes.rds')
i <- as.character(subset(i,i$IsActive==1,IndicatorCode)[[1]])

# Define UI for dataset viewer application
shinyUI(fluidPage(

  # Application title
  titlePanel("Performance Indicators"),

  # Sidebar with controls to select a dataset and specify the
  # number of observations to view
  sidebarLayout(
    sidebarPanel(
      selectInput("name", "Unit:",
                  choices = uNames),
      selectInput("qtr", "Quarter:",
                  choices = c(201303,201306,201309,201312,
                              201403,201406,201409,201412,
                              201503,201506,201509,201512,
                              201603,201606)),
      selectInput("ind","Indicator and source data for:",
                  choices = i),
      selectInput("window","Data window, months:",
                  choices = c(3,12,18,24,36,48))
    ),
      #sliderInput("price", "Price range:",
      #            min = 0, max = 2000, value = c(100,500)),
      #numericInput("obs", "Number of observations to view:", 10),
      #actionButton("load","Load and show whole database"),
      #actionButton("update","Update Database")),

    # Show a summary of the dataset and an HTML table with the
	 # requested number of observations
    mainPanel(
        verbatimTextOutput("Indicator"),
        verbatimTextOutput("Elements"),
        tableOutput("sourceData"),
        tableOutput("result")
      #textOutput("dataset")
    )
  )
))

