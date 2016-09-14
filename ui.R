
library(shiny)

source('../functions.r')
#units <- activeStation(Sys.Date())
units <- unique(unlist(subset(uData,select=LocId))) # show all units in the DB
uNames <- sort(as.character(subset(place,place$LocId %in% units,AbbrevLocName)[[1]]))
i <- readRDS('DBCopy/PI_IndicatorCodes.rds')
i <- as.character(subset(i,i$IsActive==1,IndicatorCode)[[1]])

data <- readRDS('DBCopy/PI_IndValues.rds') #Source  data
#qtrs <- sort(unique(unlist(subset(data,select=YrMn)))) # not sure if it is OK <<<<<<<
qtrs <- c(201303,201306,201309,201312,
          201403,201406,201409,201412,
          201503,201506,201509,201512,
          201603,201606)

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
                  choices = qtrs),
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
        dataTableOutput("unitStatus"),
        #verbatimTextOutput("Indicator"),
        #verbatimTextOutput("Elements"),
        dataTableOutput("sourceData"),
        dataTableOutput("comments"),
        dataTableOutput("result"),
        dataTableOutput("events")
      #textOutput("dataset")
    )
  )
))

