require(shiny)

# Load cattle data ----

shinyUI(
  fluidPage(
    
    headerPanel("Cattle GPS data explorer"),
    sidebarLayout(
      sidebarPanel(
        #         tags$head(
        #           tags$style(type="text/css", "label.radio { display: inline-block; }", ".radio input[type=\"radio\"] { float: none; }"),
        #           tags$style(type="text/css", "select { max-width: 200px; }"),
        #           tags$style(type="text/css", "textarea { max-width: 185px; }"),
        #           tags$style(type="text/css", ".jslider { max-width: 200px; }"),
        #           tags$style(type='text/css', ".well { max-width: 310px; }"),
        #           tags$style(type='text/css', ".span4 { max-width: 310px; }")
        #         ),
        submitButton("Update plot"),
        hr(width = 2),
        h3("Data selection"),
        #a("Select a centre point. You can use http://www.latlong.net to get a Lat/Lon or enter the name of a location to lookup coordinates with google.", href="http://www.latlong.net"),
        numericInput(
          inputId = "latitude", 
          label = "Latitude", 
          value = 51.648334,
          step = 0.005
        ),
        numericInput(
          inputId = "longitude", 
          label = "Longitude", 
          value = 0.027769,
          step = 0.005
        ),
        sliderInput(
          inputId = "zoom_level", 
          label = "Zoom Level", 
          min = 3,
          max = 21,
          value = 15
        ),
        uiOutput(
          outputId = "dateRangeInput"
        ),
        uiOutput(
          outputId = "collars"
        ),
        uiOutput(
          outputId = "message_type_selector"
        ),
        uiOutput(
          outputId = "daylight_select"
        ),
        uiOutput(
          outputId = "hour_selector"
        ),
        #         uiOutput(
        #           outputId = "hour_select"
        #         ),
        selectInput(
          inputId = "facet_by", 
          label = "Multiple plots", 
          selected = "None",
          choices = c("None","Year","Month","Week","Day","Weekday","Collar","Daylight"),
          multiple = FALSE,
          width = "50%"
        ),
        selectInput(
          inputId = "spatial_filter", 
          label = "Apply spatial filter", 
          selected = "Fairmead",
          choices = c("None","Fairmead","Fairmead/HC13","Fairmead/EK3"),
          multiple = FALSE,
          width = "50%"
        ),
        selectInput(
          inputId = "layers", 
          label = "Select overlays", 
          selected = "",
          choices = c("","WPP restoration","Invisible Fencing"),
          multiple = TRUE,
          width = "50%"
        ),
        #         numericInput(
        #           inputId = "max_speed", 
        #           label = "Max speed", 
        #           value = 40,
        #           step = 1,
        #           min = 0
        #         ),
        hr(),
        h3("Aesthetics"),
        sliderInput(
          inputId = "alpha_level", 
          label = "Point/Line transparency", 
          min = 0,
          max = 1,
          value = 0.6,
          step = 0.1
        ),
        sliderInput(
          inputId = "bins", 
          label = "Number of bins", 
          min = 1,
          max = 30,
          value = 10,
          step = 1
        ),
        sliderInput(
          inputId = "point_size", 
          label = "Point size", 
          min = 0,
          max = 4,
          value = 2,
          step = 0.5
        ),
        sliderInput(
          inputId = "line_width", 
          label = "Line width", 
          min = 0,
          max = 2,
          value = 0.5,
          step = 0.2
        )
      ),
      mainPanel(
        tabsetPanel(
          type = "tabs",
          selected = "quickstart",
          position = "right",
          tabPanel(
            title = "Quick start",
            value = "quickstart",
            h2("Quick start"),
            tags$div(
              list(
                tags$ul(
                  tags$li("Choose a plot type using the tabs above."),
                  tags$li("Click update plot button to generate plot."),
                  tags$li("Adjust data selection using controls."),
                  tags$li("Choose different plot types using tabs above.")
                )
              )
            )
          ),
          tabPanel(
            title = "Points",
            value = "point_plot",
            plotOutput("plotOutput", width = "100%")
          ),
          tabPanel(
            title = "Heat map",
            value = "heat_map",
            plotOutput("heat_map", width = "100%")
          ),
          tabPanel(
            title = "Paths",
            value = "path_map",
            plotOutput("plot_paths", width = "100%")
          ),
          tabPanel(
            title = "Data",
            value = "data_download",
            downloadButton(
             outputId = "data_download_button", 
             label =  "Download Data"
            ),
            fluidRow(
              column(12,
                     dataTableOutput('table')
              )
            )
          ),
          tabPanel(
            title = "Notes",
            value = "notes",
            h1("To be completed"),
            h2("Instructions"),
            h4("Map centre"),
            p(
              "To use the app, a central point for the map must be specified in latitude
              and longitude. At present a default location within Fairmead, Epping Forest
              has been specified. Latitude and Longitude lookup can be made easier with
              http://www.latlong.net/."
            ),
            h4("Zoom level"),
            p(
              "This app makes use of the google maps API, and is therefore limited to the
              same zoom range used by google maps."
            ),
            
            h2("Data"),
            p(
              "This application is built using data extracted from the global alerting API 
              (see: https://developer.globalalerting.com/API). At present this app does not
              support the live download of data from this API, and instead provides access
              to historical data. Access to the latest data could be incorporated in a 
              future update."
            ),
            h2("Build"),
            p(
              "This application is written using the R package shiny, and makes use of the 
              google maps API through the ggmaps package."
            )
          )
          
        )
      )
      
    )    
  )
)