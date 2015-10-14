#require(checkpoint)
#checkpoint::checkpoint("2015-05-15")
require(shiny)
require(ggplot2)
require(maptools)
require(sp)
require(rgdal)
require(dplyr)
require(magrittr)
require(ggplot2)
require(testthat)
require(readr)
require(lubridate)
require(ggmap)
require(geosphere)

source("scripts/wrappers.R")
source("scripts/load_data.R")



shinyServer(
  function(input, output) {
    
    # Reactives for setting UIs from data ----
    
    
    centre_point <- reactive({
      
      c(lon = input$longitude,lat = input$latitude)
      
    })
    
    min_date <- reactive({
      epping_data %$% date %>% min(na.rm=TRUE)
    })
    
    max_date <- reactive({
      epping_data %$% date %>% max(na.rm=TRUE)
    })
    
    message_types <- reactive({
      epping_data %$% MessageType %>% unique
    })
    
    collars <- reactive({
      
      epping_data %$% device %>% unique
    })
    
    hours <- reactive({
      epping_data %$% hour %>% unique
    })
    
    # Set up base map ----
    
    base_map  <- reactive({
      get_map(
        centre_point(), 
        scale = 2,
        zoom = input$zoom_level,
        source = "google",
        maptype = "satellite"
      )
      
    })
    # Render UIs ----
    
    output$collars <- renderUI({
      selectInput(
        inputId = "collar_select",
        label = "Select collars",
        choices = collars(),
        selected = collars()[1:8],
        multiple = TRUE
      )
    })
    
    output$message_type_selector <- renderUI({
      selectInput(
        inputId = "message_type",
        label = "Message Type", 
        choices = message_types(),
        selected = c(
          "GTFRI_POSITIONREPORT",
          "GTRTL_POSITIONREQUESTREPORT",
          "GTNMR_NONMOVEMENTREPORT"
        ),
        multiple = TRUE,
        width = "100%"
      )
    })
    
    output$hour_selector <- renderUI({
      sliderInput(
        inputId = "hour_selector",
        label = "Select hour", 
        value = range(hours()),
        min = min(hours()),
        max = max(hours()),
        step = 1,
        animate = TRUE,
        round = TRUE
      )
    })
    
    output$dateRangeInput <- renderUI({
      dateRangeInput(
        inputId = "date_select",
        label = "Select date range", 
        min = min_date(),
        max = max_date(),
        startview = "year",
        separator = "to",
        start = min_date(),
        end = max_date()
      )
    })
    
    output$startDate <- renderUI({
      dateInput(
        inputId = "startDateSelect",
        label = "Select start date", 
        min = min_date(),
        max = max_date(),
        startview = "year",
        value = min_date()
      )
    })
    
    output$endDate <- renderUI({
      dateInput(
        inputId = "endDateSelect",
        label = "Select end date", 
        min = min_date(),
        max = max_date(),
        value = max_date()
      )
    })
    
    output$daylight_select <- renderUI({
      selectInput(
        inputId = "daylight_select",
        label = "Filter by daylight", 
        choices = c(TRUE, FALSE),
        selected = c(TRUE, FALSE),
        multiple = TRUE,
        width = "50%"
      )
    })
    
    # Create plot layers ----
    
    plot_layers <- reactive({
      
      ggmap(
        base_map(), 
        extent = 'device',
        legend="bottomright"
      ) +
        choose_HC13(
          x = input$layers,
          label = "WPP restoration"
        ) +
        choose_fencing(
          x = input$layers,
          label = "Invisible Fencing"
        )
      
    })
    
        
    select_data <- reactive({
      
      epping_data %>%
        choose_filter(
          input$spatial_filter
          ) %>%
        dplyr::filter(
          !is.na(date),
          device %in% input$collar_select,
          as.Date(date) >= as.Date(input$date_select[1]),
          as.Date(date) <= as.Date(input$date_select[2]),
          daylight %in% input$daylight_select,
          hour %in% seq(min(input$hour_selector),max(input$hour_selector),1)
        ) %>%
        dplyr::arrange(
          date
        ) %>%
        dplyr::filter(
          MessageType %in% input$message_type
        )
        
    })
    
    output$plotOutput <- renderPlot(
      
      plot_layers() + 
        geom_point(
          data = select_data(),
          aes(
            x = lon,
            y = lat,
            colour = device,
            group = device
          ),
          size = input$point_size,
          alpha = input$alpha_level
        ) + 
        theme(
          legend.position = "top"
        ) +
        choose_facet(input$facet_by),
      height = 800
    )
    
    output$plot_paths <- renderPlot(
      
      plot_layers() + 
        geom_path(
          data = select_data(),
          aes(
            x = lon,
            y = lat,
            colour = device,
            group = device
          ),
          size = input$line_width,
          alpha = input$alpha_level
        ) + 
        theme(
          legend.position = "top"
        ) +
        choose_facet(input$facet_by),
      height = 800
    )
    
    output$heat_map <- renderPlot(
      
      plot_layers() + 
        stat_density2d(
          data = select_data(),
          aes(
            x = lon,
            y = lat,
            fill = ..level..,
            alpha = ..level..
          ),
          #colour = "black",
          geom = "polygon",
          bins = input$bins,
          size = input$line_width,
          alpha = input$alpha_level  
          ) + 
        scale_fill_gradient(
          low = "yellow", 
          high = "red"
          ) +
        scale_alpha(
          range = c(0.00, 0.5), 
          guide = FALSE
          ) +
        # geom_density2d(
          # colour = "black", 
          # bins = 10 
          # ) +
        guides(
          alpha = FALSE
          ) +
        theme(
          legend.position = "top"
        ) +
        choose_facet(input$facet_by),
      height = 800
    )
    
    output$data_download_button <- downloadHandler(
      
      filename <- function() { paste(
        "downloadData",
        gsub("-|:|\ ","-",Sys.time(),perl="TRUE"),
        ".csv",
        sep = "_"
      ) },
      content = function(file) {
        write.csv(
          select_data(), 
          file
        )
      }
    )
    
    output$table <- renderDataTable(
      select_data(),
      options = list(
        pageLength = 10
      )
    )
    
  }
  
)