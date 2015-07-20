# This script returns distance travelled in metres For some reason the
# distVicentyEllipsoid method fails. Can give errors up to 0.3%
# http://www.movable-type.co.uk/scripts/latlong.html


bla <- epping_data %>%
  mutate(
    timestamp = ymd_hms(paste(date,time))
  ) %>%
  group_by(
    device
  ) %>%
  arrange(
    timestamp
  ) %>%
  filter(
    !is.null(lon)
  ) %>%
  mutate(
    next_lat = lead(lat),
    next_lon = lead(lon),
    next_timestamp = lead(timestamp)
    ) %>%
    rowwise %>%
  mutate(
    vic = distVincentySphere(
      p1 = c(lon,lat),
      p2 = c(next_lon,next_lat)
    ),
    time = abs(timestamp - next_timestamp),
    speed = vic/as.numeric(time)
  ) %>% select(
    lat,lon,
    next_lat,next_lon,
    time,
    vic,
    speed
  )

median(bla$speed,na.rm=TRUE)

