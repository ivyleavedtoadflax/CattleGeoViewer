# Load cattle data ----
# 
# source("scripts/sunset.R")
# 
# epping_data <- "../epping_data/combined/combined.csv" %>%
#   read_csv(
#     col_types = list(
#       col_character(),
#       col_datetime(),
#       col_integer(),
#       col_datetime(),
#       col_character(),
#       col_double(),
#       col_double(),
#       col_double(),
#       col_double(),
#       col_double(),
#       col_character(),
#       col_character()
#     )
#   ) %>%
#   dplyr::mutate(
#     month = month(date,label = TRUE, abbr = TRUE),
#     day = day(date),
#     week = week(date),
#     year = year(date),
#     wday = wday(date,label = TRUE, abbr = TRUE),
#     device = substr(device,9,15),
#     hour = hour(date),
#     time = format(date,"%H:%M:%S"),
#     date = format(date,"%Y-%m-%d"),
#     sunrise = ncalc(date, Position.Longitude, Position.Latitude, "sunrise"),
#     noon = ncalc(date, Position.Longitude, Position.Latitude, "noon"),
#     sunset = ncalc(date, Position.Longitude, Position.Latitude, "sunset"),
#     daylight = ifelse(
#       time > sunrise & time < sunset,
#       TRUE,
#       FALSE
#     )
#   ) %>%
#   dplyr::filter(
#     year %in% c(2013:2015)
#   ) %>%
#   select(
#     device,date,time,
#     lon = Position.Longitude,
#     lat = Position.Latitude,
#     alt = Position.Altitude,
#     heading = Position.Heading,
#     speed = Position.Speed,
#     day,month,year,week,wday,
#     hour,sunrise,noon,sunset,
#     daylight,MessageType
#   ) 
# 
# 
# saveRDS(epping_data,"epping_data.Rds")

epping_data <- readRDS("epping_data.Rds")

# Load layers ----

# layer_HC13 <- mapinfo2ggmap("../data/HC13 Restoration of wood pasture.TAB") %>%
# fortify
# saveRDS(layer_HC13,"layer_HC13.Rds")
# layer_bury_wood <- mapinfo2ggmap("../data/Invisible-Boviguard-cable Bury Wood north.TAB") %>%
# fortify
# saveRDS(layer_bury_wood,"layer_bury_wood.Rds")
# layer_fairmead <- mapinfo2ggmap("../data/Invisible-Boviguard-cable Farirmead north.TAB") %>%
# fortify
# saveRDS(layer_fairmead,"layer_fairmead.Rds")

# Load pre-prepared layers ----

layer_HC13 <- readRDS("layer_HC13.Rds")
layer_bury_wood <- readRDS("layer_bury_wood.Rds")
layer_fairmead <- readRDS("layer_fairmead.Rds")

# Setup filters for Fairmead shps ----

# epping_coord <- readRDS("epping_data.Rds") %>%
#   as.data.frame
# 
# coordinates(epping_coord) = ~lon+lat
# proj4string(epping_coord) = CRS("+proj=longlat +datum=WGS84")
# 
# fairmead_shp <- mapinfo2ggmap("../shps/Fairmead.shp")
# fairmead_HC_13_shp <- mapinfo2ggmap("../shps/Fairmead_HC13.shp")
# fairmead_EK3_shp <- mapinfo2ggmap("../shps/Fairmead_EK3.shp")
# 
# fairmead_filter <- over(x = epping_coord, y = fairmead_shp) %>% tbl_df
# fairmead_HC_13_filter <- over(x = epping_coord, y = fairmead_HC_13_shp) %>% tbl_df
# fairmead_EK3_filter <- over(x = epping_coord, y = fairmead_EK3_shp) %>% tbl_df
# 
# fairmead_shp %>% fortify %>% saveRDS("fairmead_shp.Rds")
# fairmead_HC_13_shp %>% fortify %>% saveRDS("fairmead_HC_13_shp.Rds")
# fairmead_EK3_shp %>% fortify %>% saveRDS("fairmead_EK3_shp.Rds")
# 
# fairmead_filter %>% saveRDS("fairmead_filter.Rds")
# fairmead_HC_13_filter %>% saveRDS("fairmead_HC_13_filter.Rds")
# fairmead_EK3_filter %>% saveRDS("fairmead_EK3_filter.Rds")

# Load pre-prepared layers ----

fairmead_shp <- readRDS("fairmead_shp.Rds") 
fairmead_HC_13_shp <- readRDS("fairmead_HC_13_shp.Rds")
fairmead_EK3_shp <- readRDS("fairmead_EK3_shp.Rds")

fairmead_filter <- readRDS("fairmead_filter.Rds")
fairmead_HC_13_filter <- readRDS("fairmead_HC_13_filter.Rds")
fairmead_EK3_filter <- readRDS("fairmead_EK3_filter.Rds")

