# Wrapper function to load MAPINFO data and prepare it for plotting with ggmap: ----

mapinfo2ggmap <- function(file, ...) {
  
  # test input ----
  
  test_that(
    "Check input file exists",
    {
      expect_true(file.exists(file))
    }
  )
  
  # ----
  
  layer = ogrListLayers(file)
  
  # Test layer ----
  
  test_that(
    "One input layer is given.",
    {
      expect_equal(length(layer[1]), 1)
    }
  )
  
  # ----
  
  message(
    paste("Using layer: ", layer, ".", sep = "")
  )
  
  layer_SSSI <- readOGR(file, layer = layer) %>%
    spTransform(
      CRS("+proj=longlat +datum=WGS84")
    )
}

# Wrapper function for quick add of layers to ggplot2 ----

add_polygon <- function(
  data, 
  colour = "black", 
  fill = "green", 
  alpha = 0.3,
  size = 0.2
) {
  
  geom_polygon(
    aes(
      x = long, 
      y = lat, 
      group = group
    ), 
    fill = fill, 
    size = size, 
    colour = colour, 
    data = data, 
    alpha = alpha
  ) 
  
}

# Wrapper function for adding facets ----


choose_facet <- function(x) {
  
  if(x == "None") {
    
  } else if (x == "Year") {
    
    facet_wrap(
      ~year
    )
    
  } else if (x == "Month") {
    
    facet_wrap(
      ~month
    )
    
  } else if (x == "Weekday") {
    
    facet_wrap(
      ~wday
    )
    
  } else if (x == "Week") {
    
    facet_wrap(
      ~week
    )
    
  } else if (x == "Day") {
    
    facet_wrap(
      ~day
    )
    
  } else if (x == "Collar") {
    
    facet_wrap(
      ~device
    )
    
  }  else if (x == "Daylight") {
    
    facet_wrap(
      ~daylight
    )
    
  }
}

# Wrapper function for adding layers ----


choose_HC13 <- function(x, label) {
  
  if(!label %in% x) {
    
  } else if (label %in% x) {
    
    add_polygon(
      layer_HC13,
      alpha = 0.1,
      fill = "yellow",
      colour = "yellow"
    )
    
  }
  
}


choose_fencing <- function(x, label) {
  
  if(!label %in% x) {
    
  } else if (label %in% x) {
    
    add_polygon(
      fairmead_shp,
      alpha = 0,
      colour = "red"
    )
    
  }
  
}

# Wrapper for writing out to .shp files

OGR <- function(
  x, 
  folder, 
  layer, 
  driver = "ESRI Shapefile"
) {
  
  df <- x %>% 
    mutate(
      month = as.character(date), 
      wday = as.character(wday)
    ) %>%
    as.data.frame
  
  XY <- df
  
  coordinates(XY) = ~lon+lat
  proj4string(XY) = CRS("+proj=longlat +datum=WGS84")
  XY.df <- SpatialPointsDataFrame(XY, df)
  XY.df <- spTransform(UTMcoor.df,CRS("+proj=longlat +datum=WGS84"))
  writeOGR(
    XY.df, 
    dsn = folder, 
    layer = layer, 
    driver = driver
  )
}

# chosee filter

choose_filter <- function(data,x) {
  
  if(x == "None") {
    
    data
    
  } else if (x == "Fairmead") {
    
    data %>% filter(
      !is.na(fairmead_filter)
    )
    
  } else if (x == "Fairmead/HC13") {
    
    data %>% filter(
      !is.na(fairmead_HC_13_filter$Id)
    )
    
  }
  else if (x == "Fairmead/EK3") {
    
    data %>% filter(
      !is.na(fairmead_EK3_filter$Id)
    )
    
  }
}