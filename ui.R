
source('data.r')

# Define UI for dataset viewer application
navbarPage("Performance Analysis",

  # Application title
  tabPanel("Performance Indicators and OEDB",

  # Sidebar with controls to select a dataset and specify the
  # number of observations to view
  sidebarLayout(
    sidebarPanel(
      selectInput("name", "Unit:",
                  choices = uNames),
      selectInput("qtr", "Quarter:",
                  choices = qtrs,selected=tail(qtrs,1)),
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
        plotOutput("resultChart", height = "300px"),
        dataTableOutput("events")
      #textOutput("dataset")
    )
  )
  ),
  tabPanel("Outliers",
           sidebarLayout(
               sidebarPanel(
                  selectInput("outqtr", "Quarter:",
                  choices = qtrs,selected=tail(qtrs,1)),
                  #selectInput("ind","Indicator and source data for:",
                  #choices = i),
                  selectInput("outwindow","Data window, months:",
                              choices = c(3,12,18,24,36,48)),
                  sliderInput("coef","Coefficient for IQR:",min = 0, max = 3, value = 1.5, step = 0.1)),
               mainPanel()
    )
    ),
  tabPanel("Download reports",
           sidebarLayout(
               sidebarPanel(
                   actionButton("update","Update DB"),
                   selectInput("repqtr", "Quarter:",
                               choices = qtrs,selected=tail(qtrs,1)),
                   actionButton("tisa","(Re)calculate TISA"),
                   actionButton("qreport","(Re)create LTT report"),
                   actionButton("excel","(Re)generate Excel spreadsheet")
               ),
               mainPanel(
                   verbatimTextOutput("dbcopydate")
                   #plotOutput('plot', width = "300px", height = "300px")
               ))
           ),
  tabPanel("PI report for Peer Review team"),
  tabPanel("LTT report",
           sidebarLayout(
               sidebarPanel(
                   selectInput("lttqtr", "Quarter:",
                               choices = qtrs,selected=tail(qtrs,1))),
               mainPanel(
                   dataTableOutput("wwltt"),
                   dataTableOutput("rcltt")
           ))),
  tabPanel("PI metrics"),
  tabPanel("ISA summary")
  )
