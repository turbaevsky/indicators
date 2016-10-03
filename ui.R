
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
                  selectInput("outind","Indicator and source data for:",
                              choices = i),
                  selectInput("outwindow","Data window, months:",
                              choices = c(3,12,18,24,36,48)),
                  sliderInput("coef","Coefficient for IQR:",min = 0, max = 20, value = 1.5, step = .5)),
               mainPanel(
                   plotOutput("boxplot"),
                   dataTableOutput("outliers")
                   #verbatimTextOutput("outliers")
               )
    )
    ),
  tabPanel("Download reports",
           sidebarLayout(
               sidebarPanel(
                   actionButton("update","Update DB"),
                   selectInput("repqtr", "Quarter:",
                               choices = qtrs,selected=tail(qtrs,1)),
                   actionButton("tisa","(Re)calculate TISA"),
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
                               choices = qtrs,selected=tail(qtrs,1)),
                   actionButton("qreport","(Re)create LTT report and update the LTT data")
                   #downloadButton('qRepDown', 'Download')
               ),
               mainPanel(
                   plotOutput("wwlttplot",width = "400px"),
                   plotOutput("wwilttplot",width = "400px"),
                   dataTableOutput("wwltt"),
                   plotOutput("rclttplot"),
                   dataTableOutput("rcltt")
           ))),
  tabPanel("PI metrics",
           sidebarLayout(
               sidebarPanel(
                   selectInput("metricsqtr", "Quarter:",
                               choices = qtrs,selected=tail(qtrs,1)),
                   checkboxInput("mDetail","Detailed metrics info",value=TRUE)
               ),
               mainPanel(
                   verbatimTextOutput("metrics"),
                   plotOutput("pi1"),
                   plotOutput("pi2"),
                   plotOutput("ltp1")
                   ))
           ),
  tabPanel("ISA summary"),
  tabPanel("Indicator trend")#,
 #          sidebarLayout(
 #              mainPanel(
 #                  imageOutput("pict1")
 #          )))
  )
