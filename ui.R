library(shiny)



fluidPage(
  includeCSS("moj_styl.css"),
  headerPanel("Tree Census 2015"),
  

    
    sidebarPanel(id="sidebar",
     
      fileInput("upload_data",label = "Upload Dataset", placeholder = "Browse File",
                multiple = FALSE, accept = c(
                  "text/csv",
                  "text/comma-separated-values,text/plain",
                  ".csv")),
      
      checkboxInput("header", "Header", TRUE),
      
      # fluidRow(
      #   column(5,numericInput("display_rows", label='Display Number of Rows',value = 5, width = '400px')),
      #   column(offset = 1,
      #          submitButton("submit"),width = 6)
      # 
      # ),
      
  numericInput("display_rows", label='Display Number of Rows',value = 5, width = '400px',min = 0),
                   actionButton(inputId = "submit",label = "Submit", width = '150px'),
                   
                   
      actionButton(inputId = "null_value",label = "Sum NA Values", width = '150px'),
      
      actionButton(inputId = "total_rows",label = " Total Rows",width = '150px'),
  
  hr(),
  
     actionButton(inputId = "stats",label = "Summary", width = '150px'),
 # downloadButton("download","Download Clean Data"),
      
     hr(),
      
      verbatimTextOutput("disp_value"),
 
 # hr(),
 # 
 # radioButtons("distx", "Distribution type:",
 #              c("Normal" = "norm",
 #                "Uniform" = "unif",
 #                "Log-normal" = "lnorm",
 #                "Exponential" = "exp")),
 
 hr(),
 tags$h3('Plots (Plot Panel)'),
 selectInput(inputId = "attri",
             label = "Choose Column (Plots)",
             choices = c('tree_dbh','stump_diam','community.board','cncldist','st_assem',
                         'st_senate','council.district','census.tract','bin')
 ),
 hr(),
 
 sliderInput("n",
             "Number of observations:",
             value = 80,
             min = 1,
             max = 400),
 hr(),
      
 tags$h3('Plots (Main Dashboard)'),
 
 selectInput('xcol',"X Variable ",
             choices = c('tree_dbh','stump_diam','community.board','cncldist','st_assem',
                         'st_senate','council.district','census.tract','bin')),
 
 selectInput('ycol',"Y Variable ",
             choices = c('tree_dbh','stump_diam','community.board','cncldist','st_assem',
                         'st_senate','council.district','census.tract','bin'), 
             selected = 'stump_diam'),
 
 # checkboxInput("line", "Regression Line", FALSE),
 
 checkboxInput("smooth", "Smoother", TRUE),
 
 hr(),
 
 # selectInput("borough","GeoLocation",
 #             choices = c('Bronx','Brooklyn','Manhattan','Queens','Staten Island'),selected = 'Manhattan'),
 tags$h3('Species Count (Histogram)'),
 selectInput("species","Species",
             choices = c('American beech',
                         'American elm',
                         'American hophornbeam',
                         'bald cypress',
                         'bigtooth aspen',
                         'black cherry',
                         'Callery pear',
                         'catalpa',
                         'cherry',
                         'white oak',
                         'white pine',
                         'willow oak'),selected = 'cherry'),
 radioButtons("hist_species", label = "Species",
              choices = c("All Species" = "all_species", 
                             "Top 20 Species" = "top_20", 
                             "Low 20 Species" = "low_20"), 
              selected = "all_species"),
 
 #checkboxInput("hist_species", "Create Histogram", FALSE), 
 hr(),
 verbatimTextOutput("total_species"),
 hr(),
 tags$h3('Tree Status Count (Histogram 1)'),
 selectInput("status","Status",
             choices = c('Alive','Dead','Stump'),selected = 'Alive'),
 checkboxInput("hist_status", "Create Histogram", FALSE), 
 hr(),
 verbatimTextOutput("total_status"),
 hr(),
 
 tags$h3('Tree Health Count (Histogram 2)'),
 selectInput("health","Health",
             choices = c('Fair','Good','Poor'),selected = 'Fair'),
 checkboxInput("hist_health", "Create Histogram", FALSE), 
 hr(),
 verbatimTextOutput("health_status"),
 
 hr(),
 

   # verbatimTextOutput("borough_name",),
  
  

 
    ),

    



# headerPanel("Plots"),
#    
#      selectInput('xcol', 'X Variable', 'vars'),
#      selectInput('ycol', 'Y Variable', 'vars'),
#      numericInput('clusters', 'Cluster count', 3, min = 1, max = 9),
  
 
 mainPanel(
   
   
  
   
     tabsetPanel(id= "inTabset",type = "tabs",
     tabPanel("Main Dashboard",value = 'panel4', plotOutput("main")),             
     tabPanel("Plot",value = 'panel1', plotOutput("plot")), 
     tabPanel("Summary",value = 'panel2', verbatimTextOutput("summary")), 
     tabPanel("Table",value = 'panel3', tableOutput("contents")),
     tabPanel("Histogram",value = 'panel5', plotOutput("hist_plot")),
     tabPanel("Histogram 1",value = 'panel6', plotOutput("hist_plot1")),
     tabPanel("Histogram 2",value = 'panel7', plotOutput("hist_plot2"))
     # tabPanel("Histograms", value = 'panel5', tableOutput("hist_species"))
     ),
     
     
    
            
     
    
   
 )
  
  
)