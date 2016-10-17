
source('data.r')

# Define UI for dataset viewer application
navbarPage("Performance Analysis",

  # Application title
  tabPanel("PI and OEDB",

  # Sidebar with controls to select a dataset and specify the
  # number of observations to view
  sidebarLayout(
    sidebarPanel(
      selectizeInput("name", "Unit:",
                  choices = uNames,selected = uNames[1], multiple=FALSE),
      selectizeInput("qtr", "Quarter:",
                  choices = qtrs,selected=tail(qtrs,2)[-2],multiple=FALSE),
      selectizeInput("ind","Indicator and source data for:",
                  choices = i, selected = i[1], multiple=FALSE),
      selectInput("window","Data window, months:",
                  choices = c(3,12,18,24,36,48), selected = 3)
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
        dataTableOutput("index"),
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
                              choices = qtrs,selected=tail(qtrs,2)[-2]),
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
                               choices = qtrs,selected=tail(qtrs,2)[-2]),
                   actionButton("tisa","(Re)calculate TISA"),
                   actionButton("excel","(Re)generate Excel spreadsheet")
               ),
               mainPanel(
                   verbatimTextOutput("dbcopydate")
                   #plotOutput('plot', width = "300px", height = "300px")
               ))
           ),
  tabPanel("PI report for Peer Review team",
           sidebarLayout(
               sidebarPanel(
                   selectizeInput("PRname", "Unit:",
                                  choices = uNames,selected = uNames[1], multiple=FALSE),
                   #selectizeInput("qtr", "Quarter:",
                   #               choices = qtrs,selected=tail(qtrs,2)[-2],multiple=TRUE),
                   selectizeInput("PRind","Indicator and source data for:",
                                  choices = i, selected = i[1], multiple=FALSE),
                   selectInput("PRwindow","Data window, months:",
                               choices = c(3,36), selected = 36),
                   selectInput("dist","Distribution:",choices = c('Worldwide','Same reactor type','Same reactor type and RC')),
                   radioButtons('rStyle','Report style:',
                   c("WANO AC style" = 'ac',
                     "WANO PC style" = 'pc')),
                   checkboxInput("print","Create printable (all key indicators)",value=FALSE)
               ),
               mainPanel(
                   plotOutput('acAll', height = "600px"),
                   dataTableOutput("pc")
               ))
           ),
  tabPanel("LTT report",
           sidebarLayout(
               sidebarPanel(
                   selectInput("lttqtr", "Quarter:",
                               choices = qtrs,selected=tail(qtrs,2)[-2]),
                   checkboxInput("LTTChart","Chart",value=TRUE),
                   actionButton("qreport","(Re)create LTT report and update the LTT data")
                   #downloadButton('qRepDown', 'Download')
               ),
               mainPanel(
                   dataTableOutput("wwltt"),
                   dataTableOutput("rcltt"),
                   plotOutput("wwlttplot", width = "400px"),
                   plotOutput("wwilttplot", width = "400px"),
                   plotOutput("rclttplot", width = "400px")
           ))),
  tabPanel("PI metrics",
           sidebarLayout(
               sidebarPanel(
                   selectizeInput("metricsqtr", "Quarter(s):",
                               choices = qtrs,selected=tail(qtrs,2)[-2],multiple=TRUE),
                   #selectInput("metricsFirstQtr", "Starting quarter:",
                               #choices = qtrs,selected=qtrs[1]),
                   selectizeInput("centre","Centre No.(1=AC, 2=MC, 3=PC, 4=TC):",
                                  choices = c(1,2,3,4), selected = 1, multiple=TRUE),
                   checkboxInput("mDetail","Detailed metrics info",value=FALSE),
                   checkboxInput("mChart","Chart",value=FALSE)
               ),
               mainPanel(
                   verbatimTextOutput("metrics"),
                   #textOutput("summary"),
                   plotOutput("pi1")
                   #plotOutput("pi2"),
                   #plotOutput("ltp1")
                   ))
           ),

  tabPanel("Indicator trend",
           sidebarLayout(
               sidebarPanel(
                   selectInput("trendind","Indicator and source data for:",
                               choices = i),
                   selectInput("rType","Reactor type (for CRE and US7 only:",
                               choices = rType),
                   checkboxInput("outliers","Show outliers",value=FALSE)
                   ),
               mainPanel(
                   plotOutput("indtrend",height = '600px')
               ))
           ),

  tabPanel("Unit status",
           sidebarLayout(
               sidebarPanel(
                   selectInput("pname", "Unit:",
                               choices = allNames)),
               mainPanel(
                   dataTableOutput("status"),
                   dataTableOutput("uData")
                   ))
           ),
  tabPanel("Submitting progress",
           sidebarLayout(
               sidebarPanel(
                   selectInput("subqtr", "Quarter:",
                               choices = qtrs,selected=tail(qtrs,1)),
                   checkboxInput("sDetail","Detailed info",value=FALSE)
               ),
               mainPanel(
                   plotOutput('submit',width = '400px'),
                   verbatimTextOutput("submitting")
                   )))
  )
