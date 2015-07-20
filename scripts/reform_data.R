bla <- epping_data %>%
  mutate(
    time = format(date,"%H:%M:%S"),
    date = format(date,"%Y-%m-%d")
    ) %>%
  select(
    device,date,time,
    lon=Position.Longitude,
    lat=Position.Latitude,
    alt=Position.Altitude,
    heading=Position.Heading,
    speed=Position.Speed,
    day,month,year,week,wday,MessageType
    ) 



bla %>%
  write_csv(
    "new_epping.csv"
    )



